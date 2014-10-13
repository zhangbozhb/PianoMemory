//
//  HCObject.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-8.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "HCObject.h"
#import <objc/runtime.h>
#import <RestKit/RestKit.h>


#import "RKPropertyInspector.h"
#import "RKObjectUtilities.h"

static NSString * const HCRKPropertyInspectionReadOnlyKey = @"isReadOnly";

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

                            NSDictionary *propertyInspection = @{ RKPropertyInspectionNameKey: propNameString,
                                                                  RKPropertyInspectionKeyValueCodingClassKey: aClass,
                                                                  RKPropertyInspectionIsPrimitiveKey: @(isPrimitive) };
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
                                NSDictionary *propertyInspection = @{ RKPropertyInspectionNameKey: propNameString,
                                                                      RKPropertyInspectionKeyValueCodingClassKey: aClass,
                                                                      RKPropertyInspectionIsPrimitiveKey: @(isPrimitive) ,
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

+ (BOOL)getPropertyIsReadOnly:(NSString*)propertyName inspection:(NSDictionary *)inspection
{
    NSDictionary *propertyInspection = [inspection objectForKey:propertyName];
    NSNumber *readOnlyNumber = [propertyInspection objectForKey:HCRKPropertyInspectionReadOnlyKey];
    return [readOnlyNumber boolValue];
}

+ (Class)getPropertyClass:(NSString*)propertyName inspection:(NSDictionary *)inspection
{
    NSDictionary *propertyInspection = [inspection objectForKey:propertyName];
    Class propertyClass = [propertyInspection objectForKey:RKPropertyInspectionKeyValueCodingClassKey];
    return propertyClass;
}
@end



@implementation HCObject
/* 获取 property inspect 结果*/
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
/*自 propertyInpection 获取 property 类型*/
+ (Class)getPropertyClass:(NSString*)propertyName propertyInspections:(NSDictionary *)propertyInspections
{
    return [HCClassInspectorCache getPropertyClass:propertyName inspection:propertyInspections];
}

+ (NSArray*)classPropertyNames
{
    return [[self classPropertyInspections] allKeys];
}

+ (NSArray*)classMutablePropertyNames
{
    return [[self classMutablePropertyInspections] allKeys];
}

+ (NSString *)convertPropertyName:(NSString *)string
{
    return string;
}

/* 获取列表中未转换前的 propertyName（如果对应的 propertyName 不存在，则不放回该 propertyName） */
+ (NSArray *)propertyNamesBeforeConvert:(NSArray*)convertedPropetyNames
{
    NSMutableDictionary *convertedPropetyNameMapping = [NSMutableDictionary dictionary];
    [convertedPropetyNames enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        [convertedPropetyNameMapping setObject:propertyName forKey:propertyName];
    }];

    NSMutableArray *propertyNames = [NSMutableArray array];
    NSDictionary *inspection = [self classMutablePropertyInspections];
    [inspection enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, id obj, BOOL *stop) {
        NSString *convertedPropertyName = [self convertPropertyName:propertyName];
        if ([convertedPropetyNameMapping objectForKey:convertedPropertyName]) {
            [propertyNames addObject:propertyName];
        }
    }];
    return propertyNames;
}

/*将 property 转化为 restkit 使用的 mapping dict*/
+ (NSDictionary *)convertToRestKitMappingDictionary:(NSArray *)properties isRequest:(BOOL)isRequest
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    [properties enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        NSString *convertedPropertyName = [self convertPropertyName:propertyName];
        if (isRequest) {
            [props setObject:convertedPropertyName forKey:propertyName];
        } else {
            [props setObject:propertyName forKey:convertedPropertyName];
        }
    }];
    return props;
}

+ (NSDictionary *)restkitMappingDictionaryForRequestFromRequestParams:(NSArray *)params
{
    NSArray *propertyNames = [self classMutablePropertyNames];
    NSMutableArray *targetPropertyName = [NSMutableArray array];

    if (nil == params || 0 == [params count]) {
        [targetPropertyName addObjectsFromArray:propertyNames];
    } else {
        NSMutableDictionary *reversePropertyNameMapping = [NSMutableDictionary dictionary];
        [propertyNames enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
            NSString *convertedPropertyName = [self convertPropertyName:propertyName];
            [reversePropertyNameMapping setObject:propertyName forKey:convertedPropertyName];
        }];

        [params enumerateObjectsUsingBlock:^(NSString *convertedPropertyName, NSUInteger idx, BOOL *stop) {
            NSString *propertyName = [reversePropertyNameMapping valueForKey:convertedPropertyName];
            if (propertyName) {
                [targetPropertyName addObject:propertyName];
            }
        }];
    }

    NSDictionary *mappingDictnary = [self convertToRestKitMappingDictionary:targetPropertyName
                                                                  isRequest:YES];
    return mappingDictnary;
}

#pragma delegate HCRKProtocol
/*restkit object mapping*/
+ (id)rkObjectMapping
{
    return [self rkObjectMapping:YES propertyNames:nil];
}

+ (id)rkObjectMappingWithPropertyNames:(NSArray *)propertyNames
{
    return [self rkObjectMapping:YES propertyNames:propertyNames];
}

/*
 * reskt 默认是处理 response 的
 * 处理 request更简单的是使用 inverseMapping 来做(inverseMapping只能对 response 做才有意义)
 */
+ (id)rkObjectMapping:(BOOL)isResponse propertyNames:(NSArray *)propertyNames
{
    RKObjectMapping *mapping = nil;
    if (isResponse) {
        mapping = [RKObjectMapping mappingForClass:[self class]];
    } else {
         mapping = [RKObjectMapping requestMapping];
    }

    NSDictionary *inspection = [self classMutablePropertyInspections];
    if (propertyNames) {
        NSMutableDictionary *matchedInspection = [NSMutableDictionary dictionary];
        [propertyNames enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
            id inspectionValue = [inspection objectForKey:propertyName];
            if(inspectionValue) {
                [matchedInspection setObject:inspectionValue forKey:propertyName];
            }
        }];
        inspection = matchedInspection;
    }
    for (NSString *propertyName in inspection) {
        NSString *sourceKeyPath = nil;
        NSString *destinationKeyPath = nil;
        if (isResponse) {
            sourceKeyPath = [self convertPropertyName:propertyName];
            destinationKeyPath = propertyName;
        } else {
            sourceKeyPath = propertyName;
            destinationKeyPath = [self convertPropertyName:propertyName];
        }

        Class propertyClass = [HCClassInspectorCache getPropertyClass:propertyName inspection:inspection];
        RKPropertyMapping *propertyMapping = nil;
        if (propertyClass != [HCObject class] &&
            [propertyClass isSubclassOfClass:[HCObject class]]) {
            propertyMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:sourceKeyPath
                                                                          toKeyPath:destinationKeyPath
                                                                        withMapping:[propertyClass rkObjectMapping:isResponse propertyNames:nil]];
        } else {
            propertyMapping = [RKAttributeMapping attributeMappingFromKeyPath:sourceKeyPath
                                                                    toKeyPath:destinationKeyPath];
        }
        [mapping addPropertyMapping:propertyMapping];
    }
    return mapping;
}

+ (NSArray *)rkResponseDescriptors
{
    return [NSArray array];
}

+ (NSArray *)rkRequestDescriptors
{
    return [NSArray array];
}

+ (id)rkParseJsonData:(NSData *)jsonData
{
    NSString* MIMEType =RKMIMETypeJSON;
    NSError* error;
    id parsedData = [RKMIMETypeSerialization objectFromData:jsonData MIMEType:MIMEType error:&error];
    if (parsedData && !error) {
        NSDictionary *mappingsDictionary = @{ [NSNull null]: [self rkObjectMapping] };
        RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:parsedData mappingsDictionary:mappingsDictionary];
        NSError *mappingError = nil;
        BOOL isMapped = [mapper execute:&mappingError];
        if (isMapped && !mappingError) {
            id parseObject = [mapper.mappingResult.array firstObject];
            if (parseObject && [parseObject isKindOfClass:[self class]]) {
                return parsedData;
            }
        }
    }
    return nil;
}

- (NSData *)rkToJsonData
{
    NSData *jsonData = nil;
    RKObjectMapping *mapping = [[self class] rkObjectMapping];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:mapping.inverseMapping objectClass:[self class] rootKeyPath:nil method:RKRequestMethodAny];
    NSError* error = nil;
    NSDictionary *parameters = [RKObjectParameterization parametersWithObject:self requestDescriptor:requestDescriptor error:&error];
    if (!error) {
        // Serialize the object to JSON
        jsonData = [RKMIMETypeSerialization dataFromObject:parameters MIMEType:RKMIMETypeJSON error:&error];
        if (error) {
            jsonData = nil;
        }
    }
    return jsonData;
}


#pragma coding
- (NSArray*)classProperties
{
    return [[[self class] classPropertyInspections] allKeys];
}

- (NSArray *)classMutableProperties
{
    return [[[self class] classMutablePropertyInspections] allKeys];
}
// 这两个函数：是完成对象的序列化的反序列化。继承该对象的类可以不需要实现该函数
//不过性能方面不是太好
//关于性能的几点总结：
//1,使用 setValue 和直接 property 赋值性能是一样的，没有区别
//2,如果实现classMutableProperties，返回固定的数组，性能比默认的会号很多。与1比较会多花费20%的时间
//3，initWithCoder，encodeWithCoder中直接使用数组性能比2好一些。可以认为没啥区别，不到3%左右的差距
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        NSArray *properties = [self classMutableProperties];
        for (NSString *propertyName in properties) {
            id propertyValue = [aDecoder decodeObjectForKey:propertyName];
            if (propertyValue &&
                ![propertyValue isEqual:[NSNull null]]) {
                [self setValue:propertyValue forKey:propertyName];
            }
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray *properties = [self classMutableProperties];
    for (NSString *propertyName in properties) {
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue &&
            ![propertyValue isEqual:[NSNull null]]) {
            [aCoder encodeObject:propertyValue forKey:propertyName];
        }
    }
}

#pragma copy
- (id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    return [[[self class] allocWithZone:zone] init];
}

- (void)shallowCopyValue:(HCObject *)obj
{
    if (obj) {
        NSArray *inspection = nil;
        if ([self isKindOfClass:[obj class]]) {
            inspection = [[obj class] classMutablePropertyNames];
        } else if ([obj isKindOfClass:[self class]]) {
            inspection = [[self class] classMutablePropertyNames];
        }
        if (inspection) {
            for (NSString *propertyName in inspection) {
                id propertyValue = [obj valueForKey:propertyName];
                if (propertyValue &&
                    ![propertyValue isEqual:[NSNull null]]) {
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

- (void)shallowCopyValue:(HCObject *)obj copyClass:(Class)copyClass
{
    if (obj &&
        [obj isKindOfClass:copyClass] &&
        [copyClass isSubclassOfClass:[HCObject class]]) {
        NSArray *inspection = nil;
        if ([self isKindOfClass:[obj class]]) {
            inspection = [copyClass classMutablePropertyNames];
        } else if ([obj isKindOfClass:[self class]]) {
            inspection = [[self class] classMutablePropertyNames];
        }
        if (inspection) {
            for (NSString *propertyName in inspection) {
                id propertyValue = [obj valueForKey:propertyName];
                if ([propertyValue conformsToProtocol:@protocol(NSCopying)]) {
                    [self setValue:[propertyValue copy] forKey:propertyName];
                } else {
                    [self setValue:propertyValue forKey:propertyName];
                }
            }
        }
    }
}


#pragma HCSyncProtocol
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

- (void )setSyncLocalId:(NSString *)localId
{

}
- (void )setSyncRemoteId:(NSString *)remoteId
{

}
- (void)setSyncVersion:(NSInteger)version
{

}

- (NSString *)syncCreateLocalId
{
    return [[[NSUUID alloc] init] UUIDString];
}
@end
