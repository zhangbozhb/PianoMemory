//
//  FMSyncStorage.h
//  FM1017
//
//  Created by 张 波 on 14-9-11.
//  Copyright (c) 2014年 palm4fun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCObject.h"

@protocol FMSyncStorageDelate <NSObject>
@required
- (NSString*)mappingKeyOfClass:(Class)objectClass;
- (NSString*)viewKeyOfClass:(Class)objectClass;
@optional
- (NSObject*)viewValueInViewOfHCObject:(HCObject*)object;
@end

@interface FMSyncStorage : NSObject
@property (nonatomic) id<FMSyncStorageDelate> storeDelgate;

- (instancetype)initWithDBName:(NSString*)dbName;

#pragma encapsulate level db api
- (void)clearData;
- (NSObject *)objectForKey:(NSString *)localId;
- (BOOL)storeObject:(NSObject*)object forKey:(NSString*)key;
- (BOOL)removeObjectForKey:(NSString*)key;
- (BOOL)removeObjectsForKeys:(NSArray*)keys;

#pragma encapsulate mapping methods
- (NSString*)mappingKeyOfClass:(Class)objectClass;      //be carefull to override
- (NSMutableDictionary*)mappingOfClass:(Class)objectClass;
//- (NSString *)mappingKeyOfHCObject:(HCObject *)object;
//- (NSMutableDictionary*)mappingOfHCObject:(HCObject*)object;
//- (NSString *)mappingKeyInMappingOfHCObject:(HCObject *)object;
//- (NSObject *)mappingValueInMappingOfHCObject:(HCObject *)object;
//- (NSString *)localIdInMappingOfHCObject:(HCObject *)object;
//- (NSString *)remoteIdInMappingOfHCObject:(HCObject *)object;
//- (void)mappingStoreForHCObject:(HCObject *)object;
//- (void)mappingRemoveForHCObject:(HCObject *)object;

#pragma update sync info(remoteId , localId)
- (void)updateSyncInfo:(HCObject *)object withLocal:(BOOL)withLocal;
- (BOOL)isExistHCObject:(HCObject *)object;

#pragma encapsulate view methods
- (NSString*)viewKeyOfClass:(Class)objectClass;     //be carefull to override
- (NSMutableDictionary*)viewOfClass:(Class)objectClass;
//- (NSString*)viewKeyOfHCObject:(HCObject*)object;
//- (NSMutableDictionary*)viewOfHCObject:(HCObject*)object;
//- (NSString*)viewKeyInViewOfHCObject:(HCObject*)object;
//- (NSObject*)viewValueInViewOfHCObject:(HCObject*)object;
//- (void)viewStoreForHCObject:(HCObject*)object;
//- (void)viewRemoveForHCObject:(HCObject*)object;

#pragma encapsulate HCObject storage
- (NSString*)createLocalId:(HCObject *)object;
- (BOOL)storeHCObject:(HCObject *)object;
- (BOOL)removeHCObject:(HCObject *)object;
- (BOOL)removeAllObjectsOfClass:(Class)objectClass;   //只有在 mapping 或者 view 的 key 函数 override 才有用
@end
