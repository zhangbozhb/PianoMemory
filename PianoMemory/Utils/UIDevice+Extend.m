//
//  UIDevice+Extend.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-29.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "UIDevice+Extend.h"

@implementation UIDevice (Extend)

+ (CGFloat)zb_systemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (BOOL)zb_systemVersion5Before
{
    if ([self zb_systemVersion] <= 5.0f) {
        return YES;
    }
    return NO;
}

+ (BOOL)zb_systemVersion5Latter
{
    if ([self zb_systemVersion] >= 5.0f) {
        return YES;
    }
    return NO;
}

+ (BOOL)zb_systemVersion6Latter
{
    if ([self zb_systemVersion] >= 6.0f) {
        return YES;
    }
    return NO;
}

+ (BOOL)zb_systemVersion7Latter
{
    if ([self zb_systemVersion] >= 7.0f) {
        return YES;
    }
    return NO;
}
+ (BOOL)zb_systemVersion8Latter
{
    if ([self zb_systemVersion] >= 8.0f) {
        return YES;
    }
    return NO;
}
@end
