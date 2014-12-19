//
//  HCObject+DBWrapper.h
//  PianoMemory
//
//  Created by 张 波 on 14/12/19.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "HCObject.h"

@protocol HCDBTableProtocol <NSObject>
@required
+ (NSString *)tableName;
+ (NSString *)primaryKeyName;
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
@property (nonatomic) NSString *primaryKeyName;
@property (nonatomic) NSMutableArray *columnArray;

- (instancetype)initWithClassType:(Class<HCDBTableProtocol>)objectClass;
@end

@interface PMDataTableCache : NSObject
@property (nonatomic) dispatch_queue_t queue;
@property (nonatomic) NSMutableDictionary *tableCache;

- (PMTable*)tableForForClass:(Class)objectClass;
@end

@interface HCObject (DBWrapper) <HCDBTableProtocol>

@end
