//
//  HCErrorMessage.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-5-4.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "HCErrorMessage.h"
#import <RestKit/RestKit.h>

static NSString *kCustomerDefineError = @"com.palm4fum.customerDefineError";

@implementation HCErrorMessage

- (id)copyWithZone:(NSZone *)zone
{
    HCErrorMessage *another = [super copyWithZone:zone];
    another.errors = [NSMutableDictionary dictionary];
    [self.errors enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [another.errors setObject:[obj copy] forKey:[key copy]];
    }];
    return another;
}

+ (id)rkObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{@"detail": @"errors"}];
    return mapping;
}

+ (NSArray *)rkResponseDescriptors
{
    RKObjectMapping *mapping = [self rkObjectMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    return [NSArray arrayWithObject:responseDescriptor];
}

- (instancetype)initWithErrorMessage:(NSString *)message
{
    self = [super init];
    if (self) {
        self.errors = [NSMutableDictionary dictionary];
        [self.errors setObject:message forKey:kCustomerDefineError];
    }
    return self;
}

- (NSString *)errorMessage
{
    __block NSString *message = [self.errors objectForKey:kCustomerDefineError];
    if (message) {
        return message;
    }

    NSArray *non_field_errors = [self.errors objectForKey:@"non_field_errors"];
    if (nil != non_field_errors && [non_field_errors isKindOfClass:[NSArray class]]) {
        message = [non_field_errors firstObject];
        if (![message isKindOfClass:[NSString class]]) {
            message = nil;
        }
    } else {
        [self.errors enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSDictionary *keyValue = (NSDictionary *)obj;
            if ([key isKindOfClass:[NSString class]] &&
                [obj isKindOfClass:[NSDictionary class]] &&
                0 == [keyValue count]) {
                message = key;
                *stop = YES;
            }
        }];
    }
    return message;
}
@end
