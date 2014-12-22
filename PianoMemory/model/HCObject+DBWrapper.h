//
//  HCObject+DBWrapper.h
//  PianoMemory
//
//  Created by 张 波 on 14/12/19.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "HCObject.h"
#import <FMDB/FMDatabase.h>

@protocol HCDBTableProtocol <NSObject>
@required
+ (NSString *)tableName;
+ (NSString *)primaryKeyPropertyName;
+ (NSArray*)tablePropertyNames;
+ (NSString *)columnNameForPropertyName:(NSString *)propertyName;

@end

@interface PMColumn : NSObject
@property (nonatomic) NSString *name;

@property (nonatomic) NSString *propertyName;
@property (nonatomic) Class objectClass;
@end

@interface PMTable : NSObject
@property (nonatomic) NSString *tableName;
@property (nonatomic) NSString *primaryKeyPropertyName;
@property (nonatomic) NSMutableArray *columnArray;

- (instancetype)initWithClassType:(Class<HCDBTableProtocol,HCInspectProtocol>)objectClass;
@end

@interface PMDataTableCache : NSObject
@property (nonatomic) dispatch_queue_t queue;
@property (nonatomic) NSMutableDictionary *tableCache;

+ (PMDataTableCache *)sharedTableCache;
- (PMTable*)tableForForClass:(Class)objectClass;
@end

@interface PMDataBaseConfiguration : NSObject
@property (nonatomic, readonly) NSString *databasePath;
@property (nonatomic, readonly) NSString *databasePathInDocuments;

- (instancetype)initWithDatabasePath:(NSString *)databasePath;
@end

@interface PMDataBase : NSObject
@property (nonatomic, readonly) PMDataBaseConfiguration *configuration;
@property (nonatomic, readonly) FMDatabase *database;
- (instancetype)initWithConfiguration:(PMDataBaseConfiguration *)configuration;
@end

@interface PMDataBaseManager : NSObject
+ (instancetype)sharedInstance;

- (void)destroyDatabase:(NSString *)database;
- (void)destroyDefaultDatabase;

- (PMDataBase *)database:(NSString *)database;
- (PMDataBase *)defaultDatabase;
@end

@interface PMDatabaseMigration : NSObject

@property (nonatomic, readonly) NSString *versionTable;
@property (nonatomic, readonly) PMDataBaseConfiguration *configuration;
@property (nonatomic, readonly) PMDataBase *database;
@property (nonatomic, readonly) int currentVersion;

- (id)initWithVersionTable:(NSString *)versionTable configuration:(PMDataBaseConfiguration *)configuration;
- (void)prepareMigration;
- (void)migrate;
- (void)upToVersion:(int)version action:(void (^)(FMDatabase *db))action;

@end


@protocol HCDBProtocol <NSObject>
@required
+ (HCObject *)objectWithResultSet:(FMResultSet *)rs;

- (BOOL)isNewRecord;
- (void)setAsNewRecord:(BOOL)isNewRecord;
- (void)saveRecord;
- (void)saveWithDatabase:(FMDatabase *)db;

- (void)deleteRecord;
- (void)deleteWithDatabase:(FMDatabase *)db;

+ (HCObject *)objectByPrimaryKeyValue:(id)primaryKeyValue;
- (HCObject *)objectWhere:(NSString *)conditions parameters:(NSDictionary *)parameters;
- (HCObject *)objectWhere:(NSString *)conditions parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy;
- (NSArray *)objectsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters;
- (NSArray *)objectsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy;
- (NSArray *)objectsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy limit:(NSInteger)limit;
- (NSInteger)countWhere:(NSString *)conditions parameters:(NSDictionary *)parameters;

@optional
+ (void)createDBTable;
@end

@interface HCObject (DBWrapper) <HCDBTableProtocol, HCDBProtocol>

@end
