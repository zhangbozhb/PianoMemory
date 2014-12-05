//
//  PMAppConfig.m
//  PianoMemory
//
//  Created by 张 波 on 14/12/5.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMAppConfig.h"

static NSString *const kLastAppCheckTimestamp = @"com.zhangbo.piaonomemory.kLastAppCheckTimestamp";

@implementation PMAppConfig
+ (void)registerDefautConfig
{
    NSDictionary *appDefaults = @{kLastAppCheckTimestamp: @0};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}

+ (NSTimeInterval)lastAppCheckTimestamp
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kLastAppCheckTimestamp];
}

+ (void)updateLastAppCheckTimestamp:(NSTimeInterval)timestamp
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:timestamp] forKey:kLastAppCheckTimestamp];
}
@end
