//
//  HCObject.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-8.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "HCObject.h"
#import <objc/runtime.h>


#import "RKPropertyInspector.h"
#import "RKObjectUtilities.h"

@implementation HCObject

@end


#pragma extend inspect
static NSString * const HCRKPropertyInspectionReadOnlyKey = @"isReadOnly";

//拷贝自RKPropertyInspector.h
static NSString * const HCRKPropertyInspectionNameKey = @"name";
static NSString * const HCRKPropertyInspectionKeyValueCodingClassKey = @"keyValueCodingClass";
static NSString * const HCRKPropertyInspectionIsPrimitiveKey = @"isPrimitive";

//该类是为了 加快对类的 inspect 速度，借用了 restkit 中的方法
@interface HCClassInspectorCache : NSObject
@property (nonatomic) dispatch_queue_t queue;
@property (nonatomic) NSMutableDictionary *inspectionCache;
@property (nonatomic) NSMutableDictionary *mutableInspectionCache;

- (NSDictionary *)propertyInspectionForClass:(Class)objectClass;
- (NSDictionary *)mutablePropertyInspectionForClass:(Class)objectClass;
@end

@implementation HCClassInspectorCache

+ (HCClassInspectorCache *)sharedInspector
{
    static HCClassInspectorCache *sharedInspector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInspector = [HCClassInspectorCache new];
    });

    return sharedInspector;
}

- (id)init
{
    self = [super init];
    if (self) {
        // NOTE: We use an `NSMutableDictionary` because it is *much* faster than `NSCache` on lookup
        self.inspectionCache = [NSMutableDictionary dictionary];
        self.queue = dispatch_queue_create("org.plam4fun.haircut.hcobjectclass.property-inspection-queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

//  Property Type String
//R       The property is read-only (readonly).
//C       The property is a copy of the value last assigned (copy).
//&       The property is a reference to the value last assigned (retain).
//N       The property is non-atomic (nonatomic).
//G<name> The property defines a custom getter selector name. The name follows the G (for example, GcustomGetter,).
//S<name> The property defines a custom setter selector name. The name follows the S (for example, ScustomSetter:,).
//D       The property is dynamic (@dynamic).
//W       The property is a weak reference (__weak).
//P       The property is eligible for garbage collection.
//t<encoding>     Specifies the type using old-style encoding.
- (NSDictionary *)propertyInspectionForClass:(Class)objectClass
{
    __block NSMutableDictionary *inspection;
    dispatch_sync(self.queue, ^{
        inspection = [self.inspectionCache objectForKey:objectClass];
    });
    if (inspection) return inspection;

    inspection = [NSMutableDictionary dictionary];

    //include superclass properties
    Class currentClass = objectClass;
    while (currentClass != nil) {
        // Get the raw list of properties
        unsigned int outCount = 0;
        objc_property_t *propList = class_copyPropertyList(currentClass, &outCount);

        // Collect the property names
        for (typeof(outCount) i = 0; i < outCount; i++) {
            objc_property_t *prop = propList + i;
            const char *propName = property_getName(*prop);

            if (strcmp(propName, "_mapkit_hasPanoramaID") != 0) {
                const char *attr = property_getAttributes(*prop);
                if (attr) {
                    Class aClass = RKKeyValueCodingClassFromPropertyAttributes(attr);
                    if (aClass) {
                        NSString *propNameString = [[NSString alloc] initWithCString:propName encoding:NSUTF8StringEncoding];
                        if (propNameString) {
                            BOOL isPrimitive = NO;
                            if (attr) {
                                const char *typeIdentifierLoc = strchr(attr, 'T');
                                if (typeIdentifierLoc) {
                                    isPrimitive = (typeIdentifierLoc[1] != '@');
                                }
                            }

                            NSDictionary *propertyInspection = @{ HCRKPropertyInspectionNameKey: propNameString,
                                                                  HCRKPropertyInspectionKeyValueCodingClassKey: aClass,
                                                                  HCRKPropertyInspectionIsPrimitiveKey: @(isPrimitive) };
                            [inspection setObject:propertyInspection forKey:propNameString];
                        }
                    }
                }
            }
        }

        free(propList);
        Class superclass = [currentClass superclass];
        Class nsManagedObject = NSClassFromString(@"NSManagedObject");
        currentClass = (superclass == [NSObject class] || (nsManagedObject && superclass == nsManagedObject)) ? nil : superclass;
    }

    dispatch_barrier_async(self.queue, ^{
        [self.inspectionCache setObject:inspection forKey:(id<NSCopying>)objectClass];
    });
    return inspection;
}

- (NSDictionary *)mutablePropertyInspectionForClass:(Class)objectClass
{
    __block NSMutableDictionary *inspection;
    dispatch_sync(self.queue, ^{
        inspection = [self.mutableInspectionCache objectForKey:objectClass];
    });
    if (inspection) return inspection;

    inspection = [NSMutableDictionary dictionary];

    //include superclass properties
    Class currentClass = objectClass;
    while (currentClass != nil) {
        // Get the raw list of properties
        unsigned int outCount = 0;
        objc_property_t *propList = class_copyPropertyList(currentClass, &outCount);

        // Collect the property names
        for (typeof(outCount) i = 0; i < outCount; i++) {
            objc_property_t *prop = propList + i;
            const char *propName = property_getName(*prop);

            if (strcmp(propName, "_mapkit_hasPanoramaID") != 0) {
                const char *attr = property_getAttributes(*prop);
                if (attr) {
                    Class aClass = RKKeyValueCodingClassFromPropertyAttributes(attr);
                    if (aClass) {
                        NSString *propNameString = [[NSString alloc] initWithCString:propName encoding:NSUTF8StringEncoding];
                        if (propNameString) {
                            BOOL isPrimitive = NO;
                            if (attr) {
                                const char *typeIdentifierLoc = strchr(attr, 'T');
                                if (typeIdentifierLoc) {
                                    isPrimitive = (typeIdentifierLoc[1] != '@');
                                }
                            }
                            BOOL isReadOnly = NO;
                            if (attr) {
                                const char *typeIdentifierLoc = strstr(attr, ",R");
                                if (typeIdentifierLoc) {
                                    isReadOnly = (typeIdentifierLoc[2] == '\0' || typeIdentifierLoc[2] == ',');
                                }
                            }
                            if (!isReadOnly) {
                                NSDictionary *propertyInspection = @{ HCRKPropertyInspectionNameKey: propNameString,
                                                                      HCRKPropertyInspectionKeyValueCodingClassKey: aClass,
                                                                      HCRKPropertyInspectionIsPrimitiveKey: @(isPrimitive) ,
                                                                      HCRKPropertyInspectionReadOnlyKey: @(isReadOnly)};
                                [inspection setObject:propertyInspection forKey:propNameString];
                            }
                        }
                    }
                }
            }
        }

        free(propList);
        Class superclass = [currentClass superclass];
        Class nsManagedObject = NSClassFromString(@"NSManagedObject");
        currentClass = (superclass == [NSObject class] || (nsManagedObject && superclass == nsManagedObject)) ? nil : superclass;
    }

    dispatch_barrier_async(self.queue, ^{
        [self.mutableInspectionCache setObject:inspection forKey:(id<NSCopying>)objectClass];
    });
    return inspection;
}
@end


@implementation HCObject (Inspect)
/**
 * 获取对象inspection 结果
 * 返回 propertyName:  inspection(dictionary)
 **/
+ (NSDictionary*)classPropertyInspections
{
    NSDictionary *inspection = [[HCClassInspectorCache sharedInspector] propertyInspectionForClass:[self class]];
    return inspection;
}
+ (NSDictionary*)classMutablePropertyInspections
{
    NSDictionary *inspection = [[HCClassInspectorCache sharedInspector] mutablePropertyInspectionForClass:[self class]];
    return inspection;
}

#pragma HCInspectProtocol
+ (NSArray*)propertyNamesOfThisClass
{
    return [[self classPropertyInspections] allKeys];
}

+ (NSArray*)mutablePropertyNamesOfThisClass
{
    return [[self classMutablePropertyInspections] allKeys];
}

+ (Class)propertyClassOfPropertyName:(NSString*)propertyName
{
    NSDictionary *propertyInspection = [[self classPropertyInspections] objectForKey:propertyName];
    Class propertyClass = [propertyInspection objectForKey:HCRKPropertyInspectionKeyValueCodingClassKey];
    return propertyClass;

}
@end



#pragma extend coding
@implementation HCObject (Coding)
+ (NSArray *)encodePropertyNames
{
    return [self mutablePropertyNamesOfThisClass];
}

+ (NSArray *)dencodePropertyNames
{
    return [self mutablePropertyNamesOfThisClass];
}

// 这两个函数：是完成对象的序列化的反序列化。继承该对象的类可以不需要实现该函数
//不过性能方面不是太好
//关于性能的几点总结：
//1,使用 setValue 和直接 property 赋值性能是一样的，没有区别
//2,如果实现classMutableProperties，返回固定的数组，性能比默认的会好很多。与1比较会多花费20%的时间
//3，initWithCoder，encodeWithCoder中直接使用数组性能比2好一些。可以认为没啥区别，不到3%左右的差距
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        NSArray *properties = [[self class] encodePropertyNames];
        for (NSString *propertyName in properties) {
            id propertyValue = [aDecoder decodeObjectForKey:propertyName];
            if (propertyValue &&
                ![propertyValue isEqual:[NSNull null]]) {
                NSError *error = nil;
                if ([self validateValue:&propertyValue forKey:propertyName error:&error]){
                    [self setValue:propertyValue forKey:propertyName];
                }
            }
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray *properties = [[self class] dencodePropertyNames];
    for (NSString *propertyName in properties) {
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue &&
            ![propertyValue isEqual:[NSNull null]]) {
            [aCoder encodeObject:propertyValue forKey:propertyName];
        }
    }
}
@end





#pragma extend copying
@implementation HCObject (Copying)
- (id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    return [[[self class] allocWithZone:zone] init];
}

+ (NSArray *)copyingPropertyNames
{
    return [self mutablePropertyNamesOfThisClass];
}

- (void)shallowCopyValue:(NSObject *)obj
{
    if (obj
        && [obj isKindOfClass:[HCObject class]]
        && ([self isKindOfClass:[obj class]] || [obj isKindOfClass:[self class]])
        ) {
        NSArray *inspection = nil;
        if ([self isKindOfClass:[obj class]]) {
            inspection = [[obj class] copyingPropertyNames];
        } else if ([obj isKindOfClass:[self class]]) {
            inspection = [[self class] copyingPropertyNames];
        }

        if (!inspection) {
            return;
        }
        for (NSString *propertyName in inspection) {
            id propertyValue = [obj valueForKey:propertyName];
            if (propertyValue &&
                ![propertyValue isEqual:[NSNull null]]) {
                id propertyValue = [obj valueForKey:propertyName];
                NSError *error = nil;
                if ([self validateValue:&propertyValue forKey:propertyName error:&error]){
                    if ([propertyValue conformsToProtocol:@protocol(NSCopying)]) {
                        [self setValue:[propertyValue copy] forKey:propertyName];
                    } else {
                        [self setValue:propertyValue forKey:propertyName];
                    }
                }
            }
        }
    }
}

- (void)shallowCopyValue:(NSObject *)obj copyClass:(Class)copyClass
{
    if (obj
        && [obj isKindOfClass:copyClass]
        && [obj isKindOfClass:[HCObject class]]
        && ([self isKindOfClass:[obj class]] || [obj isKindOfClass:[self class]])
        ) {
        NSArray *inspection = nil;
        if ([self isKindOfClass:[obj class]]) {
            inspection = [copyClass copyingPropertyNames];
        } else if ([obj isKindOfClass:[self class]]) {
            inspection = [[self class] copyingPropertyNames];
        }

        if (!inspection) {
            return;
        }
        for (NSString *propertyName in inspection) {
            id propertyValue = [obj valueForKey:propertyName];
            if (propertyValue &&
                ![propertyValue isEqual:[NSNull null]]) {
                id propertyValue = [obj valueForKey:propertyName];
                NSError *error = nil;
                if ([self validateValue:&propertyValue forKey:propertyName error:&error]){
                    if ([propertyValue conformsToProtocol:@protocol(NSCopying)]) {
                        [self setValue:[propertyValue copy] forKey:propertyName];
                    } else {
                        [self setValue:propertyValue forKey:propertyName];
                    }
                }
            }
        }
    }
}
@end

#pragma extend sync
@implementation HCObject (Sync)

- (NSString *)syncLocalId
{
    return nil;
}

- (NSString *)syncRemoteId
{
    return nil;
}

- (NSInteger)syncVersion
{
    return 0;
}

- (void)setSyncLocalId:(NSString *)localId
{

}
- (void)setSyncRemoteId:(NSString *)remoteId
{

}
- (void)setSyncVersion:(NSInteger)version
{

}

- (void)updateSyncedInfo:(NSObject*)obj
{
    if (obj
        && [obj conformsToProtocol:@protocol(HCSyncProtocol)]) {
        id <HCSyncProtocol> syncObject = (id <HCSyncProtocol>)obj;
        if ([syncObject syncLocalId]) {
            [self setSyncLocalId:[syncObject syncLocalId]];
        }

        if ([syncObject syncRemoteId]) {
            [self setSyncRemoteId:[syncObject syncRemoteId ]];
        }

        if ([syncObject syncVersion]) {
            [self setSyncVersion:[syncObject syncVersion ]];
        }
    }
}

- (NSString *)generateUUID
{
    return [[[NSUUID alloc] init] UUIDString];
}

@end


