//
//  PMCourseScheduleRepeat.h
//  PianoMemory
//
//  Created by 张 波 on 14/11/4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    PMCourseScheduleRepeatTypeNone = 0,
    PMCourseScheduleRepeatTypeDay,
    PMCourseScheduleRepeatTypeWeek,
    PMCourseScheduleRepeatTypeMonth,
    PMCourseScheduleRepeatTypeYear,
} PMCourseScheduleRepeatType;

typedef enum {
    PMCourseScheduleRepeatDataWeekDayMonday = 1 ,
    PMCourseScheduleRepeatDataWeekDayTuesday = 1 << 1,
    PMCourseScheduleRepeatDataWeekDayWednesday  = 1 << 2,
    PMCourseScheduleRepeatDataWeekDayThursday  = 1 << 3,
    PMCourseScheduleRepeatDataWeekDayFriday  = 1 << 4,
    PMCourseScheduleRepeatDataWeekDayStaturday  = 1 << 5,
    PMCourseScheduleRepeatDataWeekDaySunday = 1 << 6,
}PMCourseScheduleRepeatDataWeekDay;

@interface PMCourseScheduleRepeat : NSObject
+ (NSInteger)dayIndexInWeekFromRepeatWeekDay:(PMCourseScheduleRepeatDataWeekDay)repeateWeekDay;
+ (PMCourseScheduleRepeatDataWeekDay)repeatWeekDayFromDayIndexInWeek:(NSInteger)dayIndexInWeeek;
+ (PMCourseScheduleRepeatDataWeekDay)repeatWeekDayFromDate:(NSDate*)date;
+ (NSString *)displayTextOfRepeatWeekDay:(PMCourseScheduleRepeatDataWeekDay)repeateWeekDay;
@end
