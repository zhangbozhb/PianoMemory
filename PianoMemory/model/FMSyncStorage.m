//
//  FMSyncStorage.m
//  FM1017
//
//  Created by 张 波 on 14-9-11.
//  Copyright (c) 2014年 palm4fun. All rights reserved.
//

#import "FMSyncStorage.h"
#import <Objective-LevelDB/LevelDB.h>

@interface FMSyncStorage ()
@property LevelDB *localLevelDB;
@property (nonatomic) dispatch_queue_t queue;
@end

@implementation FMSyncStorage

- (instancetype)initWithDBName:(NSString*)dbName
{
    self = [super init];
    if (self) {
        LevelDBOptions options = [LevelDB makeOptions];
        options.createIfMissing = true;
        options.errorIfExists   = false;
        options.paranoidCheck   = false;
        options.compression     = true;
        options.filterPolicy    = 0;      // Size in bits per key, allocated for a bloom filter, used in testing presence of key
        options.cacheSize       = 1024 * 1024 * 5;      // Size in bytes, allocated for a LRU cache used for speeding up lookups
        self.localLevelDB =  [LevelDB databaseInLibraryWithName:dbName andOptions:options];
        self.queue = dispatch_queue_create("org.plam4fun.fm1017.localstorage-queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

#pragma encapsulate level db api
- (void)clearData
{
    dispatch_sync(self.queue, ^{
        [self.localLevelDB removeAllObjects];
    });
}

- (NSObject *)objectForKey:(NSString *)localId
{
    __block NSObject *object = nil;
    if (localId) {
        dispatch_sync(self.queue, ^{
            object = [self.localLevelDB objectForKey:localId];
        });
    }
    return object;
}

- (BOOL)storeObject:(NSObject*)object forKey:(NSString*)key
{
    dispatch_sync(self.queue, ^{
        [self.localLevelDB setObject:object forKey:key];
    });
    return YES;
}

- (BOOL)removeObjectForKey:(NSString*)key
{
    dispatch_sync(self.queue, ^{
        [self.localLevelDB removeObjectForKey:key];
    });
    return YES;
}

- (BOOL)removeObjectsForKeys:(NSArray*)keys
{
    dispatch_sync(self.queue, ^{
        [self.localLevelDB removeObjectsForKeys:keys];
    });
    return YES;
}

#pragma encapsulate mapping methods
- (NSString*)mappingKeyOfClass:(Class)objectClass
{
    if (self.storeDelgate &&
        [self.storeDelgate respondsToSelector:@selector(mappingKeyOfClass:)]) {
        return [self.storeDelgate mappingKeyOfClass:objectClass];
    }
    return nil;
}

- (NSMutableDictionary*)mappingOfClass:(Class)objectClass
{
    NSMutableDictionary *targetMapping = nil;
    NSString *mappingKey = [self mappingKeyOfClass:objectClass];
    if (mappingKey) {
        targetMapping = (NSMutableDictionary*)[self objectForKey:mappingKey];
    }
    return targetMapping;
}

- (NSString *)mappingKeyOfHCObject:(HCObject *)object
{
    return [self mappingKeyOfClass:[object class]];
}

- (NSMutableDictionary*)mappingOfHCObject:(HCObject*)object
{
    return [self mappingOfClass:[object class]];
}

- (NSString *)mappingKeyInMappingOfHCObject:(HCObject *)object
{
    return object.syncLocalId;
}

- (NSObject *)mappingValueInMappingOfHCObject:(HCObject *)object
{
    if (object.syncRemoteId) {
        return object.syncRemoteId;
    }
    return @"";
}

- (NSString *)localIdInMappingOfHCObject:(HCObject *)object
{
    __block NSString *localId = nil;
    if (object.syncRemoteId) {
        NSMutableDictionary *mapping = [self mappingOfHCObject:object];
        if (mapping) {
            [mapping enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL *stop) {
                if ([obj isEqualToString:object.syncRemoteId]) {
                    localId = key;
                }
            }];
        }
    }
    return localId;
}

- (NSString *)remoteIdInMappingOfHCObject:(HCObject *)object
{
    NSString *remoteId = nil;
    if (object.syncRemoteId) {
        NSMutableDictionary *mapping = [self mappingOfHCObject:object];
        if (mapping) {
            remoteId = [mapping objectForKey:object.syncLocalId];
            if (0 == [remoteId length]) {
                remoteId = nil;
            }
        }
    }
    return remoteId;
}

- (void)mappingStoreForHCObject:(HCObject *)object
{
    NSString *keyInMapping = [self mappingKeyInMappingOfHCObject:object];
    if (nil == keyInMapping) {
        return;
    }

    BOOL shouldUpdate = NO;
    NSString *mappingKey = [self mappingKeyOfHCObject:object];
    if (mappingKey) {
        NSObject *mappingValue = [self mappingValueInMappingOfHCObject:object];
        NSMutableDictionary *mapping = (NSMutableDictionary *)[self objectForKey:mappingKey];
        if (mapping) {
            NSObject *oldMappingValue = [mapping objectForKey:keyInMapping];
            if ( (!oldMappingValue ||
                  [oldMappingValue isKindOfClass:[NSString class]]) &&
                [mappingValue isKindOfClass:[NSString class]]) {
                NSString *mappingValueString =  (NSString*)mappingValue;
                NSString *oldMappingValueString = (NSString*)oldMappingValue;
                if (mappingValueString &&
                    ![mappingValueString isEqualToString:oldMappingValueString]) {
                    shouldUpdate = YES;
                }
            }
        } else {
            mapping = [NSMutableDictionary dictionary];
            shouldUpdate = YES;
        }

        if (shouldUpdate) {
            [mapping setObject:mappingValue forKey:keyInMapping];
            [self storeObject:mapping forKey:mappingKey];
        }
    }
}

- (void)mappingRemoveForHCObject:(HCObject *)object
{
    NSString *keyInMapping = [self mappingKeyInMappingOfHCObject:object];
    if (nil == keyInMapping) {
        return;
    }

    NSString *mappingKey = [self mappingKeyOfHCObject:object];
    if (mappingKey) {
        NSMutableDictionary *mapping = (NSMutableDictionary *)[self objectForKey:mappingKey];
        if (mapping) {
            if ([mapping objectForKey:keyInMapping]) {
                [mapping removeObjectForKey:keyInMapping];
                [self storeObject:mapping forKey:mappingKey];
            }
        }
    }
}

#pragma update sync info(remoteId , localId)
- (void)updateSyncInfo:(HCObject *)object withLocal:(BOOL)withLocal
{
    if (0 == [object.syncRemoteId length]) {
        NSString *remoteId = [self remoteIdInMappingOfHCObject:object];
        if (remoteId) {
            object.syncRemoteId = remoteId;
        }
    }

    if (withLocal) {
        NSString *localId = [self localIdInMappingOfHCObject:object];
        if (localId) {
            object.syncLocalId = localId;
        }
    }
}

- (BOOL)isExistHCObject:(HCObject *)object
{
    [self updateSyncInfo:object withLocal:YES];
    if ([object syncLocalId] &&
        [self objectForKey:[object syncLocalId]]) {
        return YES;
    }
    return NO;

}

#pragma encapsulate view methods
- (NSString*)viewKeyOfClass:(Class)objectClass
{
    if (self.storeDelgate &&
        [self.storeDelgate respondsToSelector:@selector(viewKeyOfClass:)]) {
        return [self.storeDelgate viewKeyOfClass:objectClass];
    }
    return nil;
}

- (NSMutableDictionary*)viewOfClass:(Class)objectClass
{
    NSMutableDictionary *targetView = nil;
    NSString *viewKey = [self viewKeyOfClass:objectClass];
    if (viewKey) {
        targetView = (NSMutableDictionary*)[self objectForKey:viewKey];
    }
    return targetView;
}

- (NSString*)viewKeyOfHCObject:(HCObject*)object
{
    return [self viewKeyOfClass:[object class]];
}

- (NSMutableDictionary*)viewOfHCObject:(HCObject*)object
{
    return [self viewOfClass:[object class]];
}

- (NSString*)viewKeyInViewOfHCObject:(HCObject*)object
{
    return object.syncLocalId;
}

- (NSObject*)viewValueInViewOfHCObject:(HCObject*)object
{
    if (self.storeDelgate &&
        [self.storeDelgate respondsToSelector:@selector(viewValueInViewOfHCObject:)]) {
        return [self.storeDelgate viewValueInViewOfHCObject:object];
    }
    return @"";
}

- (void)viewStoreForHCObject:(HCObject*)object
{
    NSString *viewKey = [self viewKeyOfHCObject:object];
    if (nil == viewKey) {
        return;
    }
    NSString *keyInView = [self viewKeyInViewOfHCObject:object];
    NSObject *valueInView = [self viewValueInViewOfHCObject:object];
    if (nil == keyInView ||
        nil == valueInView) {
        return;
    }

    NSMutableDictionary *viewMapping = [self viewOfHCObject:object];
    if (nil == viewMapping) {
        viewMapping = [NSMutableDictionary dictionary];
        [viewMapping setObject:valueInView forKey:keyInView];
        [self storeObject:viewMapping forKey:viewKey];
    } else {
        if ([valueInView isKindOfClass:[NSString class]]) {
            NSString *stringValueInView = (NSString*)valueInView;
            if (![stringValueInView isEqualToString:[viewMapping objectForKey:keyInView]]) {
                [viewMapping setObject:valueInView forKey:keyInView];
                [self storeObject:viewMapping forKey:viewKey];
            }
        } else {
            [viewMapping setObject:valueInView forKey:keyInView];
            [self storeObject:viewMapping forKey:viewKey];
        }
    }
}

- (void)viewRemoveForHCObject:(HCObject*)object
{
    NSString *viewKey = [self viewKeyOfHCObject:object];
    if (nil == viewKey) {
        return;
    }
    NSString *keyInView = [self viewKeyInViewOfHCObject:object];
    NSObject *valueInView = [self viewValueInViewOfHCObject:object];
    if (nil == keyInView ||
        nil == valueInView) {
        return;
    }

    NSMutableDictionary *viewMapping = [self viewOfHCObject:object];
    if (nil != viewMapping &&
        [viewMapping objectForKey:keyInView]) {
        [viewMapping removeObjectForKey:keyInView];
        [self storeObject:viewMapping forKey:viewKey];
    }
}

#pragma encapsulate HCObject storage
- (NSString*)createLocalId:(HCObject *)object
{
    return [object syncCreateLocalId];
}

- (BOOL)storeHCObject:(HCObject *)object
{
    if (!object) {
        return NO;
    }
    [self updateSyncInfo:object withLocal:YES];

    if (nil == object.syncLocalId) {
        object.syncLocalId = [self createLocalId:object];
    }
    [self storeObject:object forKey:object.syncLocalId];

    //更新 mapping
    [self mappingStoreForHCObject:object];

    //更新 view
    [self viewStoreForHCObject:object];

    return YES;
}

- (BOOL)removeHCObject:(HCObject *)object
{
    if (!object) {
        return NO;
    }
    [self updateSyncInfo:object withLocal:YES];

    if (nil != object.syncLocalId) {
        [self removeObjectForKey:object.syncLocalId];
    }

    //更新 mapping
    [self mappingRemoveForHCObject:object];

    //更新 view
    [self viewRemoveForHCObject:object];

    return YES;
}


- (BOOL)removeAllObjectsOfClass:(Class)objectClass
{
    //删除 mapping
    NSString *mappingKey = [self mappingKeyOfClass:objectClass];
    NSMutableDictionary *mapping = [self mappingOfClass:objectClass];
    if (mappingKey) {
        [self removeObjectForKey:mappingKey];
    }
    if (mapping) {
        [self removeObjectsForKeys:[mapping allKeys]];
    }

    //删除 view
    NSString *viewgKey = [self viewKeyOfClass:objectClass];
    NSMutableDictionary *view = [self viewOfClass:objectClass];
    if (viewgKey) {
        [self removeObjectForKey:viewgKey];
    }
    if (view) {
        [self removeObjectsForKeys:[view allKeys]];
    }
    return YES;
}


@end
