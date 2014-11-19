//
//  PMDataUpdate.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMDataUpdate.h"

NSString * const kPianoMemoryLocalDataUpdatedNotification = @"kPianoMemoryLocalDataUpdatedNotification";

@implementation PMDataUpdate

+ (NSString *)dataUpdateTypeToString:(PMLocalServer_DateUpateType)dateType
{
    NSString *typeString = @"";
    switch (dateType) {
        case PMLocalServer_DataUpateType_Student:
            typeString = @"PMLocalServer_DateUpateType_Student";
            break;
        case PMLocalServer_DataUpateType_ALL:
            typeString = @"PMLocalServer_DateUpateType_ALL";
            break;
        case PMLocalServer_DataUpateType_Course:
            typeString = @"PMLocalServer_DateUpateType_Course";
            break;
        case PMLocalServer_DataUpateType_TimeSchedule:
            typeString = @"PMLocalServer_DateUpateType_TimeSchedule";
            break;
        case PMLocalServer_DataUpateType_CourseSchedule:
            typeString = @"PMLocalServer_DateUpateType_CourseSchedule";
            break;
        case PMLocalServer_DataUpateType_DayCourseSchedule:
            typeString = @"PMLocalServer_DateUpateType_DayCourseSchedule";
            break;
        case PMLocalServer_DataUpateType_Undefined:
        default:
            typeString = @"PMLocalServer_DateUpateType_Undefined";
            break;
    }
    return typeString;
}

+ (PMLocalServer_DateUpateType)dataUpdateType:(NSString *)typeString
{
    PMLocalServer_DateUpateType dateType = PMLocalServer_DataUpateType_Undefined;
    if (typeString && [typeString isKindOfClass:[NSString class]]) {
        NSArray *dateTypes = @[[NSNumber numberWithLong:PMLocalServer_DataUpateType_Undefined],
                               [NSNumber numberWithLong:PMLocalServer_DataUpateType_Student],
                               [NSNumber numberWithLong:PMLocalServer_DataUpateType_Course],
                               [NSNumber numberWithLong:PMLocalServer_DataUpateType_TimeSchedule],
                               [NSNumber numberWithLong:PMLocalServer_DataUpateType_CourseSchedule],
                               [NSNumber numberWithLong:PMLocalServer_DataUpateType_DayCourseSchedule],
                               [NSNumber numberWithLong:PMLocalServer_DataUpateType_ALL],
                               ];

        for (NSNumber *dateTypeValue in dateTypes) {
            dateType = (PMLocalServer_DateUpateType)[dateTypeValue longValue];
            if ([[self dataUpdateTypeToString:dateType] isEqualToString:typeString]) {
                break;
            }
        }
    }

    return dateType;
}


+ (void)notificationDataUpated:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPianoMemoryLocalDataUpdatedNotification object:object];
}

@end
