//
//  PMDataUpdate.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kPianoMemoryLocalDataUpdatedNotification;

typedef enum {
    PMLocalServer_DataUpateType_Undefined = 1,
    PMLocalServer_DataUpateType_Student,
    PMLocalServer_DataUpateType_Course,
    PMLocalServer_DataUpateType_TimeSchedule,
    PMLocalServer_DataUpateType_CourseSchedule,
    PMLocalServer_DataUpateType_DayCourseSchedule,
    PMLocalServer_DataUpateType_ALL,
} PMLocalServer_DateUpateType;

@interface PMDataUpdate : NSObject
+ (NSString *)dataUpdateTypeToString:(PMLocalServer_DateUpateType)dateType;
+ (PMLocalServer_DateUpateType)dataUpdateType:(NSString *)typeString;
+ (void)notificationDataUpated:(id)object;
@end
