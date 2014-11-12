//
//  NSBundle+Extend.m
//  Utils
//
//  Created by 张 波 on 14-9-15.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "NSBundle+Extend.h"

@implementation NSBundle (Extend)
+ (NSString *)zb_appName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)zb_appReleaseVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)zb_appBuildVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}
@end
