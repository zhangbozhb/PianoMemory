//
//  PMCourseScheduleRepeat.m
//  PianoMemory
//
//  Created by 张 波 on 14/11/4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCourseScheduleRepeat.h"
#import "NSDate+Extend.h"

@implementation PMCourseScheduleRepeat

+ (NSInteger)dayIndexInWeekFromRepeatWeekDay:(PMCourseScheduleRepeatDataWeekDay)repeateWeekDay
{
    NSInteger dayIndexInWeeek = 0;
    switch (repeateWeekDay) {
        case PMCourseScheduleRepeatDataWeekDaySunday:
            dayIndexInWeeek = 0;
            break;
        case PMCourseScheduleRepeatDataWeekDayMonday:
            dayIndexInWeeek = 1;
            break;
        case PMCourseScheduleRepeatDataWeekDayTuesday:
            dayIndexInWeeek = 2;
            break;
        case PMCourseScheduleRepeatDataWeekDayWednesday:
            dayIndexInWeeek = 3;
            break;
        case PMCourseScheduleRepeatDataWeekDayThursday:
            dayIndexInWeeek = 4;
            break;
        case PMCourseScheduleRepeatDataWeekDayFriday:
            dayIndexInWeeek = 5;
            break;
        case PMCourseScheduleRepeatDataWeekDayStaturday:
            dayIndexInWeeek = 6;
            break;
        default:
            break;
    }
    return dayIndexInWeeek;
}

+ (PMCourseScheduleRepeatDataWeekDay)repeatWeekDayFromDayIndexInWeek:(NSInteger)dayIndexInWeeek
{
    PMCourseScheduleRepeatDataWeekDay repeateWeekDay = PMCourseScheduleRepeatDataWeekDaySunday;
    switch (dayIndexInWeeek) {
        case 0:
            repeateWeekDay = PMCourseScheduleRepeatDataWeekDaySunday;
            break;
        case 1:
            repeateWeekDay = PMCourseScheduleRepeatDataWeekDayMonday;
            break;
        case 2:
            repeateWeekDay = PMCourseScheduleRepeatDataWeekDayTuesday;
            break;
        case 3:
            repeateWeekDay = PMCourseScheduleRepeatDataWeekDayWednesday;
            break;
        case 4:
            repeateWeekDay = PMCourseScheduleRepeatDataWeekDayThursday;
            break;
        case 5:
            repeateWeekDay = PMCourseScheduleRepeatDataWeekDayFriday;
            break;
        case 6:
            repeateWeekDay = PMCourseScheduleRepeatDataWeekDayStaturday;
            break;
        default:
            break;
    }
    return repeateWeekDay;
}

+ (PMCourseScheduleRepeatDataWeekDay)repeatWeekDayFromDate:(NSDate *)date
{
    NSInteger dayIndexInWeek = [date zb_weekDay] - 1;
    return [self repeatWeekDayFromDayIndexInWeek:dayIndexInWeek];
}

+ (NSString *)displayTextOfRepeatWeekDay:(PMCourseScheduleRepeatDataWeekDay)repeateWeekDay
{
    NSString *displayText = @"未定义";
    switch (repeateWeekDay) {
        case PMCourseScheduleRepeatDataWeekDaySunday:
            displayText = @"周日";
            break;
        case PMCourseScheduleRepeatDataWeekDayMonday:
            displayText = @"周一";
            break;
        case PMCourseScheduleRepeatDataWeekDayTuesday:
            displayText = @"周二";
            break;
        case PMCourseScheduleRepeatDataWeekDayWednesday:
            displayText = @"周三";
            break;
        case PMCourseScheduleRepeatDataWeekDayThursday:
            displayText = @"周四";
            break;
        case PMCourseScheduleRepeatDataWeekDayFriday:
            displayText = @"周五";
            break;
        case PMCourseScheduleRepeatDataWeekDayStaturday:
            displayText = @"周六";
            break;
        default:
            displayText = @"周日";
            break;
    }
    return displayText;
}
@end
