//
//  HCObject+DBWrapper.m
//  PianoMemory
//
//  Created by 张 波 on 14/12/19.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "HCObject+DBWrapper.h"

@implementation PMColumn

@end

@implementation PMTable
- (instancetype)initWithClassType:(Class<HCDBTableProtocol>)objectClass
{
    self = [super init];
    if (self) {
        self.tableName = [objectClass tableName];
        self.primaryKeyName = [objectClass primaryKeyName];

        NSArray *tablePropertyNames = [objectClass tablePropertyNames];
        NSMutableArray *columnArray = [NSMutableArray arrayWithCapacity:[tablePropertyNames count]];
        [tablePropertyNames enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
            PMColumn *column = [[PMColumn alloc] init];
            column.name = [objectClass columnNameForPropertyName:propertyName];
            column.propertyName = propertyName;
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
    if (!tableInfo) return tableInfo;

    tableInfo = [[PMTable alloc] initWithClassType:objectClass];
    dispatch_barrier_async(self.queue, ^{
        [self.tableCache setObject:tableInfo forKey:(id<NSCopying>)objectClass];
    });
    return tableInfo;
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

+ (NSString *)primaryKeyName
{
    return nil;
}

+ (NSArray*)tablePropertyNames
{
    return [self mutablePropertyNamesOfThisClass];
}

+ (NSString *)columnNameForPropertyName:(NSString *)propertyName
{
    return [self snakeCaseFromCamelCase:propertyName];
}
@end







