//
//  PMAppConfig.h
//  PianoMemory
//
//  Created by 张 波 on 14/12/5.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMAppConfig : NSObject


+ (void)registerDefautConfig;

+ (NSTimeInterval)lastAppCheckTimestamp;
+ (void)updateLastAppCheckTimestamp:(NSTimeInterval)timestamp;
@end
