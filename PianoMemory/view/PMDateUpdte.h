//
//  PMDateUpdte.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kPianoMemoryLocalDataUpdatedNotification;

typedef enum {
    PMLocalServer_DateUpateType_Undefined = 1,
    PMLocalServer_DateUpateType_Student,
    PMLocalServer_DateUpateType_ALL,
} PMLocalServer_DateUpateType;

@interface PMDateUpdte : NSObject
+ (NSString *)dateUpdateTypeToString:(PMLocalServer_DateUpateType)dateType;
+ (PMLocalServer_DateUpateType)dateUpdateType:(NSString *)typeString;
+ (void)notificationDataUpated:(id)object;
@end
