//
//  NSDictionary+Extend.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-9-23.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "NSDictionary+Extend.h"

@implementation NSDictionary (Extend)

- (id)zb_objectForKeyNotNull:(id)key
{
    id object = [self objectForKey:key];
    if ([object isEqual:[NSNull null]]) {
        return nil;
    } else {
        return object;
    }
}
@end
