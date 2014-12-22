//
//  HCObject+DBWrapper.m
//  PianoMemory
//
//  Created by 张 波 on 14/12/19.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "HCObject+DBWrapper.h"
#import <objc/runtime.h>


static NSString *kdefaultDataBaseName = @"default";

static NSString *ksqlitePrimaryKey = @"PRIMARY KEY NOT NULL";
static NSString *ksqliteDataTypeText = @"TEXT";
static NSString *ksqliteDataTypeInteger = @"INTEGER";
static NSString *ksqliteDataTypeReal = @"REAL";
static NSString *ksqliteSeperateSymbol = @",";

@implementation PMColumn

@end

@implementation PMTable
- (instancetype)initWithClassType:(Class<HCDBTableProtocol,HCInspectProtocol>)objectClass
{
    self = [super init];
    if (self) {
        self.tableName = [objectClass tableName];
        self.primaryKeyPropertyName = [objectClass primaryKeyPropertyName];

        NSArray *tablePropertyNames = [objectClass tablePropertyNames];
        NSMutableArray *columnArray = [NSMutableArray arrayWithCapacity:[tablePropertyNames count]];
        [tablePropertyNames enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
            PMColumn *column = [[PMColumn alloc] init];
            column.name = [objectClass columnNameForPropertyName:propertyName];
            column.propertyName = propertyName;
            column.objectClass = [objectClass propertyClassOfPropertyName:propertyName];
            [columnArray addObject:column];
        }];
        self.columnArray = columnArray;
    }
    return self;
}
@end

@implementation PMDataTableCache

+ (PMDataTableCache *)sharedTableCache
{
    static PMDataTableCache *sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[PMDataTableCache alloc] init];
    });

    return sharedCache;
}

- (id)init
{
    self = [super init];
    if (self) {
        // NOTE: We use an `NSMutableDictionary` because it is *much* faster than `NSCache` on lookup
        self.tableCache = [NSMutableDictionary dictionary];
        self.queue = dispatch_queue_create("com.plam4fun.pianomemory.hcobjectclass.table-cache-queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (PMTable *)tableForForClass:(Class)objectClass
{
    __block PMTable *tableInfo;
    dispatch_sync(self.queue, ^{
        tableInfo = [self.tableCache objectForKey:objectClass];
    });
    if (tableInfo) return tableInfo;

    tableInfo = [[PMTable alloc] initWithClassType:objectClass];
    dispatch_barrier_async(self.queue, ^{
        [self.tableCache setObject:tableInfo forKey:(id<NSCopying>)objectClass];
    });
    return tableInfo;
}
@end


@implementation PMDataBaseConfiguration

- (instancetype)initWithDatabasePath:(NSString *)databasePath
{
    self = [super init];
    if (self) {
        if (databasePath) {
            _databasePath = databasePath;
        } else {
            _databasePath = kdefaultDataBaseName;
        }
        if (![_databasePath hasSuffix:@".db"]) {
            _databasePath = [_databasePath stringByAppendingString:@".db"];
        }
        // Set a database file path in the documents directory.
        NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _databasePathInDocuments = [dir stringByAppendingPathComponent:self.databasePath];

        // Initialize database file.
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:self.databasePathInDocuments]) {
            // The database file is not found in the documents directory. Create empty database file.
            [fm createFileAtPath:self.databasePathInDocuments contents:nil attributes:nil];
        }
    }
    return self;
}
@end


@implementation PMDataBase

- (instancetype)initWithConfiguration:(PMDataBaseConfiguration *)configuration
{
    self = [super init];
    if (self) {
        _configuration = configuration;
        _database = [FMDatabase databaseWithPath:configuration.databasePathInDocuments];
    }
    return self;
}

- (void)performDatabaseAction:(void (^)(FMDatabase *database))action
{
    [self.database open];
    if (action) {
        action(self.database);
    }
    [self.database close];
}

@end

@interface PMDataBaseManager()
@property (strong, nonatomic) NSMutableDictionary *configurations;
@end

@implementation PMDataBaseManager

+ (PMDataBaseManager *)sharedInstance
{
    static PMDataBaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PMDataBaseManager alloc] init];
    });

    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.configurations = [NSMutableDictionary dictionary];
    }
    return self;
}

/**
 *  Destroy database.
 *
 *  @param database database name
 */
- (void)destroyDatabase:(NSString *)database
{
    PMDataBaseConfiguration *configuration = [[PMDataBaseConfiguration alloc] initWithDatabasePath:database];
    NSFileManager *fileMananger = [NSFileManager defaultManager];
    if (configuration.databasePathInDocuments
        && [fileMananger fileExistsAtPath:configuration.databasePathInDocuments]) {
        [fileMananger removeItemAtPath:configuration.databasePathInDocuments error:nil];
    }
}

/**
 *  Destroy default database.
 */
- (void)destroyDefaultDatabase
{
    [self destroyDatabase:kdefaultDataBaseName];
}


/**
 *  Get a database.
 *
 *  @param database database name
 *
 *  @return FMDatabase object
 */
- (PMDataBase *)database:(NSString *)database
{
    if (!database) {
        database = kdefaultDataBaseName;
    }
    PMDataBase *dataBaseInstance = [self.configurations objectForKey:database];
    if (!dataBaseInstance) {
        PMDataBaseConfiguration *configuration = [[PMDataBaseConfiguration alloc] initWithDatabasePath:database];
        dataBaseInstance = [[PMDataBase alloc] initWithConfiguration:configuration];
        [self.configurations setObject:dataBaseInstance forKey:database];
    }
    return dataBaseInstance;
}
- (PMDataBase *)defaultDatabase
{
    return [self database:nil];
}
@end


@implementation PMDatabaseMigration
- (id)init
{
    self = [super init];
    if (self) {
        // Default version schema table name is `schema_version`.
        _versionTable = @"schema_version";
        _configuration = [[PMDataBaseConfiguration alloc] initWithDatabasePath:nil];
        _database = [[PMDataBase alloc] initWithConfiguration:_configuration];
    }
    return self;
}
- (id)initWithVersionTable:(NSString *)versionTable configuration:(PMDataBaseConfiguration *)configuration
{
    self = [super init];
    if (self) {
        _versionTable = versionTable;
        _configuration = configuration;
        _database = [[PMDataBase alloc] initWithConfiguration:configuration];
        _currentVersion = 0;
    }
    return self;
}

- (void)performDatabaseAction:(void (^)(FMDatabase *database))action
{
    [self.database performDatabaseAction:^(FMDatabase *database) {
        [database beginTransaction];
        if (action) {
            action(database);
        }
        [database commit];
    }];
}


- (void)prepareMigration
{
    [self performDatabaseAction:^(FMDatabase *database) {
        // Check existing schema version table.
        FMResultSet *rs = [database executeQuery:[NSString stringWithFormat:
                                            @"select * from sqlite_master where type='table' and name = '%@'",
                                            self.versionTable]];
        if (![rs next]) {
            [database executeUpdate:[NSString stringWithFormat:
                               @"create table %@ (version INTGER PRIMARY KEY NOT NULL)",
                               self.versionTable]];
            [database executeUpdate:[NSString stringWithFormat:
                               @"insert into %@ (version) values (0)",
                               self.versionTable]];
        }

        rs = [database executeQuery:[NSString stringWithFormat:@"select version from %@", self.versionTable]];
        if ([rs next]) {
            _currentVersion = [rs intForColumn:@"version"];
        } else {
            _currentVersion = 0;
        }
    }];
}

-(void)migrate
{
}

- (void)upToVersion:(int)version action:(void (^)(FMDatabase *))action
{
    if (version <= self.currentVersion) {
        // check version.
        return;
    }
    [self performDatabaseAction:^(FMDatabase *database) {
        if (action) {
            action(database);
        }
        // Update schema version.
        [database executeUpdate:[NSString stringWithFormat:@"update %@ set version = %d", self.versionTable, version]];
        _currentVersion = version;;
    }];
}

@end

@implementation HCObject (DBWrapper)
/**
 *  Get a snake case string from camel case.
 *
 *  @param input camel case string
 *
 *  @return snake case string
 */
+(NSString *)snakeCaseFromCamelCase:(NSString *)input
{
    NSMutableString *output = [NSMutableString string];
    NSCharacterSet *uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    for (NSInteger idx = 0; idx < [input length]; idx += 1) {
        unichar c = [input characterAtIndex:idx];
        if ([uppercase characterIsMember:c] && idx == 0) {
            [output appendFormat:@"%@", [[NSString stringWithCharacters:&c length:1] lowercaseString]];
        } else if ([uppercase characterIsMember:c]) {
            [output appendFormat:@"_%@", [[NSString stringWithCharacters:&c length:1] lowercaseString]];
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

/**
 *  Get a lower camel case string from snake case.
 *
 *  @param input snake case string
 *
 *  @return lower camel case string
 */
+(NSString *)lowerCamelCaseFromSnakeCase:(NSString *)input
{
    NSMutableString *output = [NSMutableString string];
    BOOL makeNextCharacterUpperCase = NO;
    for (NSInteger idx = 0; idx < [input length]; idx += 1) {
        unichar c = [input characterAtIndex:idx];
        if (idx == 0) {
            [output appendString:[[NSString stringWithCharacters:&c length:1] uppercaseString]];
        } else if (c == '_') {
            makeNextCharacterUpperCase = YES;
        } else if (makeNextCharacterUpperCase) {
            [output appendString:[[NSString stringWithCharacters:&c length:1] uppercaseString]];
            makeNextCharacterUpperCase = NO;
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

#pragma HCDBProtocol
+ (NSString *)tableName
{
    return NSStringFromClass([self class]);
}

+ (NSString *)primaryKeyPropertyName
{
    return nil;
}

+ (NSArray*)tablePropertyNames
{
    NSArray *mutablePropertyNames = [self mutablePropertyNamesOfThisClass];
    NSMutableArray *targetArray = [NSMutableArray array];
    for (NSString *propertyName in mutablePropertyNames) {
        Class propertyClass = [self propertyClassOfPropertyName:propertyName];
        if ([propertyClass isSubclassOfClass:[NSNumber class]]
            || [propertyClass isSubclassOfClass:[NSString class]]
            || [propertyClass isSubclassOfClass:[NSData class]]) {
            [targetArray addObject:propertyName];
        }
    }
    return targetArray;
}

+ (NSString *)columnNameForPropertyName:(NSString *)propertyName
{
    return [self snakeCaseFromCamelCase:propertyName];
}


#pragma HCDBProtocol
+ (HCObject *)objectWithResultSet:(FMResultSet *)rs
{
    HCObject *object = [[[self class] alloc] init];
    PMTable *table = [self tableInfo];
    for (PMColumn *column in table.columnArray) {
        BOOL isValid = NO;
        id columnValue = [rs objectForColumnName:column.name];
        if (!columnValue) {
            continue;
        }
        if ([column.objectClass isSubclassOfClass:[NSNumber class]]
            || [column.objectClass isSubclassOfClass:[NSString class]]
            || [column.objectClass isSubclassOfClass:[NSData class]]) {
            isValid = YES;
        } else if ([column.objectClass isSubclassOfClass:[NSArray class]]
                   && ([columnValue isKindOfClass:[NSString class]] || [columnValue isKindOfClass:[NSData class]])) {
            if (columnValue) {
                NSError *error = nil;
                NSData *data = columnValue;
                if ([columnValue isKindOfClass:[NSString class]]) {
                    data = [columnValue dataUsingEncoding:NSUTF8StringEncoding];
                }
                columnValue = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            }

            isValid = YES;
        } else if ([column.objectClass isSubclassOfClass:[HCObject class]]) {
            id primataryValue = columnValue;
            columnValue = [column.objectClass objectByPrimaryKeyValue:primataryValue];
            isValid = YES;
        }

        NSError *error = nil;
        if (isValid
            && [object validateValue:&columnValue forKey:column.propertyName error:&error]){
            [object setValue:columnValue forKey:column.propertyName];
        }
    }
    return object;
}

+ (PMTable*)tableInfo
{
    return [[PMDataTableCache sharedTableCache] tableForForClass:[self class]];
}


- (void)executeInDatabase:(FMDatabase *)database withAction:(void (^)(FMDatabase *targetDatabase))action
{
    FMDatabase *targetDatabase = database;
    if (!database) {
        targetDatabase = [[PMDataBaseManager sharedInstance] defaultDatabase].database;
        [targetDatabase open];
        [targetDatabase beginTransaction];
    }

    if (action) {
        action(targetDatabase);
    }

    if (!database) {
        [targetDatabase commit];
        [targetDatabase close];
    }
}

- (BOOL)isNewRecord
{
    NSString *primaryKeyPropertyName = [[self class] primaryKeyPropertyName];
    if (primaryKeyPropertyName) {
        id primaryKeyNameValue = [self valueForKey:primaryKeyPropertyName];
        if (primaryKeyNameValue) {
            if ([primaryKeyNameValue isKindOfClass:[NSString class]]) {
                return 0 < [primaryKeyNameValue length];
            } else if ([primaryKeyNameValue isKindOfClass:[NSNumber class]]){
                return  0 != [primaryKeyNameValue integerValue];
            }
        }
    }
    return YES;
}

- (void)setAsNewRecord:(BOOL)isNewRecord
{

}

- (void)saveRecord
{
    [self saveWithDatabase:nil];
}

- (void)saveWithDatabase:(FMDatabase *)db
{
    if ([self isNewRecord]) {
        [self insertWithDatabase:db];
    } else {
        [self updateWithDatabase:db];
    }
}

- (void)insertWithDatabase:(FMDatabase *)database
{
    if (![self isNewRecord]) {
        return;
    }

    PMTable *table = [[self class] tableInfo];
    NSMutableArray *fields = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (PMColumn *column in table.columnArray) {
        id columnValue = [self valueForKey:column.propertyName] ?: NSNull.null;
        if ([column.objectClass isSubclassOfClass:[HCObject class]]) {
            if ([columnValue isNewRecord]) {
                [columnValue saveWithDatabase:database];

                //todo:添加外键
                id referPrimaryValue = [columnValue objectForKey:[[columnValue class] primaryKeyPropertyName]];
                if (referPrimaryValue) {
                    [fields addObject:column.name];
                    [values addObject:referPrimaryValue];
                }
            }
        } else {
            if ([column.name isEqualToString:table.primaryKeyPropertyName]
                && columnValue == NSNull.null) {
                continue;
            }
            [fields addObject:column.name];
            [values addObject:columnValue];
        }
    }

    // Build query
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"insert into `%@` ", table.tableName];
    [query appendFormat:@"(`%@`) values (%@?)",
     [fields componentsJoinedByString:@"`,`"],
     [@"" stringByPaddingToLength:((fields.count - 1) * 2) withString:@"?," startingAtIndex:0]
     ];

    [self executeInDatabase:database withAction:^(FMDatabase *targetDatabase) {
        [targetDatabase executeUpdate:query withArgumentsInArray:values];
        // Update primary key after insert.
        if (table.primaryKeyPropertyName) {
            NSError *error = nil;
            id primaryKeyValue = @([targetDatabase lastInsertRowId]);
            if ([self validateValue:&primaryKeyValue forKey:table.primaryKeyPropertyName error:&error]){
                [self setValue:primaryKeyValue forKey:table.primaryKeyPropertyName];
            }
        }

        [self setAsNewRecord:NO];
    }];
}

- (void)updateWithDatabase:(FMDatabase *)database
{
    if ([self isNewRecord]) {
        return;
    }


    PMTable *table = [[self class] tableInfo];
    id primaryKeyValue = [self valueForKey:table.primaryKeyPropertyName];
    if (!primaryKeyValue) {
        return;
    }

    NSMutableArray *fields = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (PMColumn *column in table.columnArray) {
        id columnValue = [self valueForKey:column.propertyName] ?: NSNull.null;
        if ([column.objectClass isSubclassOfClass:[HCObject class]]) {
            if ([columnValue isNewRecord]) {
                [columnValue saveWithDatabase:database];

                //todo:添加外键
                id referPrimaryValue = [columnValue objectForKey:[[columnValue class] primaryKeyPropertyName]];
                if (referPrimaryValue) {
                    [fields addObject:column.name];
                    [values addObject:referPrimaryValue];
                }
            }
        } else {
            if ([column.name isEqualToString:table.primaryKeyPropertyName]
                && columnValue == NSNull.null) {
                continue;
            }
            [fields addObject:column.name];
            [values addObject:columnValue];
        }
    }

    // The primary key value needs to be last value.
    [values addObject:primaryKeyValue ?: NSNull.null];

    // Build query
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"update `%@` set ", table.tableName];
    [query appendFormat:@"`%@` = ? ", [fields componentsJoinedByString:@"`=?,`"]];
    [query appendFormat:@"where `%@` = ?", table.primaryKeyPropertyName];

    [self executeInDatabase:database withAction:^(FMDatabase *targetDatabase) {
        [targetDatabase executeUpdate:query withArgumentsInArray:values];
    }];
}

- (void)deleteRecord
{
    [self deleteWithDatabase:nil];
}

- (void)deleteWithDatabase:(FMDatabase *)database
{
    if ([self isNewRecord]) {
        return;
    }

    PMTable *table = [[self class] tableInfo];
    id primaryKeyValue = [self valueForKey:table.primaryKeyPropertyName];
    if (!primaryKeyValue) {
        return;
    }

    // Build query
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"delete from `%@` ", table.tableName];
    [query appendFormat:@"where `%@` = ?", table.primaryKeyPropertyName];

    [self executeInDatabase:database withAction:^(FMDatabase *targetDatabase) {
        [targetDatabase executeUpdate:query, primaryKeyValue];
    }];
}

+ (HCObject *)objectByPrimaryKeyValue:(id)primaryKeyValue
{
    __block HCObject *object = nil;
    PMTable *table = [self tableInfo];
    PMDataBase *database = [[PMDataBaseManager sharedInstance] defaultDatabase];
    [database performDatabaseAction:^(FMDatabase *database) {
        [database beginTransaction];
        NSString *sql = [NSString stringWithFormat:@"select * from `%@` where `%@` = (?)",
                         table.tableName,
                         table.primaryKeyPropertyName];
        FMResultSet *rs = [database executeQuery:sql, primaryKeyValue];
        if ([rs next]) {
            object = [self objectWithResultSet:rs];
        }
        [database commit];
    }];

    return object;
}

- (HCObject *)objectWhere:(NSString *)conditions parameters:(NSDictionary *)parameters
{
    __block HCObject *object = nil;
    PMTable *table = [[self class] tableInfo];
    [self executeInDatabase:nil withAction:^(FMDatabase *targetDatabase) {
        NSString *sql = [NSString stringWithFormat:@"select * from `%@` where %@ limit 1",
                         table.tableName,
                         [self validatedConditionsString:conditions]];
        FMResultSet *rs = [targetDatabase executeQuery:sql withParameterDictionary:parameters];
        if ([rs next]) {
            object = [[self class] objectWithResultSet:rs];
        }
    }];
    return object;
}

- (HCObject *)objectWhere:(NSString *)conditions parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy
{
    if (orderBy == nil) {
        return [self objectWhere:conditions parameters:parameters];
    }
    __block HCObject *object = nil;
    PMTable *table = [[self class] tableInfo];
    [self executeInDatabase:nil withAction:^(FMDatabase *targetDatabase) {
        NSString *sql = [NSString stringWithFormat:@"select * from `%@` where %@ order by %@ limit 1",
                         table.tableName,
                         [self validatedConditionsString:conditions],
                         orderBy
                         ];
        FMResultSet *rs = [targetDatabase executeQuery:sql withParameterDictionary:parameters];
        if ([rs next]) {
            object = [[self class] objectWithResultSet:rs];
        }
    }];
    return object;
}

- (NSArray *)objectsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters
{
    NSMutableArray *objectArray = [NSMutableArray array];
    PMTable *table = [[self class] tableInfo];
    [self executeInDatabase:nil withAction:^(FMDatabase *targetDatabase) {
        NSString *sql = [NSString stringWithFormat:@"select * from `%@` where %@",
                         table.tableName,
                         [self validatedConditionsString:conditions]];
        FMResultSet *rs = [targetDatabase executeQuery:sql withParameterDictionary:parameters];
        while ([rs next]) {
            HCObject *object = [[self class] objectWithResultSet:rs];
            if (object) {
                [objectArray addObject:object];
            }
        }
    }];
    return objectArray;
}

- (NSArray *)objectsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy
{
    if (orderBy == nil) {
        return [self objectsWhere:conditions parameters:parameters];
    }

    NSMutableArray *objectArray = [NSMutableArray array];
    PMTable *table = [[self class] tableInfo];
    [self executeInDatabase:nil withAction:^(FMDatabase *targetDatabase) {
        NSString *sql = [NSString stringWithFormat:@"select * from `%@` where %@ order by %@",
                         table.tableName,
                         [self validatedConditionsString:conditions],
                         orderBy
                         ];
        FMResultSet *rs = [targetDatabase executeQuery:sql withParameterDictionary:parameters];
        while ([rs next]) {
            HCObject *object = [[self class] objectWithResultSet:rs];
            if (object) {
                [objectArray addObject:object];
            }
        }
    }];
    return objectArray;
}


- (NSArray *)objectsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy limit:(NSInteger)limit
{
    NSMutableArray *objectArray = [NSMutableArray array];
    PMTable *table = [[self class] tableInfo];
    [self executeInDatabase:nil withAction:^(FMDatabase *targetDatabase) {
        NSString *sql = [NSString stringWithFormat:@"select * from `%@` where %@ order by %@ limit %ld",
                         table.tableName,
                         [self validatedConditionsString:conditions],
                         orderBy,
                         (long)limit
                         ];
        FMResultSet *rs = [targetDatabase executeQuery:sql withParameterDictionary:parameters];
        while ([rs next]) {
            HCObject *object = [[self class] objectWithResultSet:rs];
            if (object) {
                [objectArray addObject:object];
            }
        }
    }];
    return objectArray;
}

- (NSInteger)countWhere:(NSString *)conditions parameters:(NSDictionary *)parameters
{
    __block NSInteger count = 0;
    PMTable *table = [[self class] tableInfo];
    [self executeInDatabase:nil withAction:^(FMDatabase *targetDatabase) {
        NSString *sql = [NSString stringWithFormat:@"select count(*) as count from `%@` where %@",
                         table.tableName,
                         [self validatedConditionsString:conditions]];
        FMResultSet *rs = [targetDatabase executeQuery:sql withParameterDictionary:parameters];

        if ([rs next]) {
            count = [rs intForColumn:@"count"];
        }
    }];
    return count;
}

- (NSString *)validatedConditionsString:(NSString *)conditions
{
    if (conditions == nil || [conditions isEqualToString:@""]) {
        conditions = [NSString stringWithFormat:@"1 = 1"];
    }

    return conditions;
}

+ (void)createDBTable
{
    PMTable *tableInfo = [self tableInfo];
    NSMutableArray *columnFieldArray = [NSMutableArray array];
    for (PMColumn *column in tableInfo.columnArray) {
        NSMutableArray *columnArray = [NSMutableArray array];
        [columnArray addObject:column.name];
        if ([column.objectClass isSubclassOfClass:[NSString class]]) {
            [columnArray addObject:ksqliteDataTypeText];
        } else if ([column.objectClass isSubclassOfClass:[NSNumber class]]) {
            [columnArray addObject:ksqliteDataTypeReal];
        } else if ([column.objectClass isSubclassOfClass:[HCObject class]]) {
            [columnArray addObject:ksqliteDataTypeText];
        } else if ([column.objectClass isSubclassOfClass:[NSArray class]]
                   || [column.objectClass isSubclassOfClass:[NSDictionary class]]) {
            [columnArray addObject:ksqliteDataTypeText];
        }

        if ([column.name isEqualToString:tableInfo.primaryKeyPropertyName]) {
            [columnArray addObject:ksqlitePrimaryKey];
        }
        [columnFieldArray addObject:[columnArray componentsJoinedByString:@" "]];
    }

    FMDatabase *targetDatabase = [[PMDataBaseManager sharedInstance] defaultDatabase].database;
    [targetDatabase open];
    [targetDatabase beginTransaction];

    NSString *sql = [NSString stringWithFormat:@"create table %@ (%@);", tableInfo.tableName,
                     [columnFieldArray componentsJoinedByString:ksqliteSeperateSymbol]];
    [targetDatabase executeUpdate:sql];
    [targetDatabase commit];
    [targetDatabase close];
}
@end







