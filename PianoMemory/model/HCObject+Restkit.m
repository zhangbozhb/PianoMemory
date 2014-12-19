//
//  HCObject+Restkit.m
//  PianoMemory
//
//  Created by 张 波 on 14/12/19.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "HCObject+Restkit.h"
#import <RestKit/RestKit.h>

@implementation HCObject (Restkit)

#pragma delegate HCRKProtocol
+ (NSDictionary*)rkSpecialPropertyNameRKNameMapping
{
    return nil;
}

+ (NSString *)rkNameForPropertyName:(NSString *)propertyName
{
    NSString *rkName = [[self rkSpecialPropertyNameRKNameMapping] objectForKey:propertyName];
    return (nil != rkName)? rkName:propertyName;
}

/* 获取列表中未转换前的 propertyName（如果对应的 propertyName 不存在，则不放回该 propertyName） */
+ (NSArray *)propertyNamesOfRKNames:(NSArray*)rkNames
{
    NSMutableDictionary *rkNameMapping = [NSMutableDictionary dictionary];
    NSArray *propertyNames = [self mutablePropertyNamesOfThisClass];
    [propertyNames enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        NSString *rkName = [self rkNameForPropertyName:propertyName];
        if (rkName) {
            [rkNameMapping setObject:propertyName forKey:rkName];
        }
    }];
    NSMutableArray *targetPropertyNames = [NSMutableArray arrayWithCapacity:[rkNames count]];
    [rkNames enumerateObjectsUsingBlock:^(NSString * rkName, NSUInteger idx, BOOL *stop) {
        NSString *propertyName = [rkNameMapping objectForKey:rkName];
        if (propertyName) {
            [targetPropertyNames addObject:propertyName];
        }
    }];
    return targetPropertyNames;
}

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
    if (!propertyNames) {
        propertyNames = [self mutablePropertyNamesOfThisClass];
    }
    for (NSString *propertyName in propertyNames) {
        NSString *rkName = [self rkNameForPropertyName:propertyName];
        if (rkName) {
            NSString *sourceKeyPath = nil;
            NSString *destinationKeyPath = nil;
            if (isResponse) {
                sourceKeyPath = rkName;
                destinationKeyPath = propertyName;
            } else {
                sourceKeyPath = propertyName;
                destinationKeyPath = rkName;
            }

            Class propertyClass = [self propertyClassOfPropertyName:propertyName];
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

+ (NSDictionary *)rkMappingDictionaryWithProperties:(NSArray *)properties isDecode:(BOOL)isDecode
{
    NSMutableDictionary *mappingDictionary = [NSMutableDictionary dictionary];
    if (!properties) {
        properties = [self mutablePropertyNamesOfThisClass];
    }
    [properties enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        NSString *rkName = [self rkNameForPropertyName:propertyName];
        if (rkName) {
            if (isDecode) {
                [mappingDictionary setObject:propertyName forKey:rkName];
            } else {
                [mappingDictionary setObject:rkName forKey:propertyName];
            }
        }
    }];
    return mappingDictionary;
}

+ (NSDictionary *)rkRequestMappingDictionaryWthRKNames:(NSArray *)rkNames
{
    NSArray *targetPropertyNames = nil;
    if (rkNames) {
        targetPropertyNames = [self propertyNamesOfRKNames:rkNames];
    }
    return [self rkMappingDictionaryWithProperties:targetPropertyNames isDecode:NO];
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

@end
