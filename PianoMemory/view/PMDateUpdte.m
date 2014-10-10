//
//  PMDateUpdte.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMDateUpdte.h"

NSString * const kPianoMemoryLocalDataUpdatedNotification = @"kPianoMemoryLocalDataUpdatedNotification";

@implementation PMDateUpdte

+ (NSString *)dateUpdateTypeToString:(PMLocalServer_DateUpateType)dateType
{
    NSString *typeString = @"";
    switch (dateType) {
        case PMLocalServer_DateUpateType_Student:
            typeString = @"PMLocalServer_DateUpateType_Student";
            break;
        case PMLocalServer_DateUpateType_ALL:
            typeString = @"PMLocalServer_DateUpateType_ALL";
            break;
        case PMLocalServer_DateUpateType_Course:
            typeString = @"PMLocalServer_DateUpateType_Course";
            break;
        case PMLocalServer_DateUpateType_TimeSchedule:
            typeString = @"PMLocalServer_DateUpateType_TimeSchedule";
            break;
        case PMLocalServer_DateUpateType_CourseSchedule:
            typeString = @"PMLocalServer_DateUpateType_CourseSchedule";
            break;
        case PMLocalServer_DateUpateType_DayCourseSchedule:
            typeString = @"PMLocalServer_DateUpateType_DayCourseSchedule";
            break;
        case PMLocalServer_DateUpateType_Undefined:
        default:
            typeString = @"PMLocalServer_DateUpateType_Undefined";
            break;
    }
    return typeString;
}

+ (PMLocalServer_DateUpateType)dateUpdateType:(NSString *)typeString
{
    PMLocalServer_DateUpateType dateType = PMLocalServer_DateUpateType_Undefined;
    if (typeString && [typeString isKindOfClass:[NSString class]]) {
        NSArray *dateTypes = @[[NSNumber numberWithLong:PMLocalServer_DateUpateType_Undefined],
                               [NSNumber numberWithLong:PMLocalServer_DateUpateType_Student],
                               [NSNumber numberWithLong:PMLocalServer_DateUpateType_Course],
                               [NSNumber numberWithLong:PMLocalServer_DateUpateType_TimeSchedule],
                               [NSNumber numberWithLong:PMLocalServer_DateUpateType_CourseSchedule],
                               [NSNumber numberWithLong:PMLocalServer_DateUpateType_DayCourseSchedule],
                               [NSNumber numberWithLong:PMLocalServer_DateUpateType_ALL],
                               ];

        for (NSNumber *dateTypeValue in dateTypes) {
            dateType = (PMLocalServer_DateUpateType)[dateTypeValue longValue];
            if ([[self dateUpdateTypeToString:dateType] isEqualToString:typeString]) {
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
