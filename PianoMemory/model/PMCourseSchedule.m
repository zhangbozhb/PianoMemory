//
//  PMCourseSchedule.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCourseSchedule.h"

@implementation PMCourseSchedule
- (id)copyWithZone:(NSZone *)zone
{
    PMCourseSchedule *another = [super copyWithZone:zone];
    another.course = [self.course copy];
    if (nil != self.students) {
        another.students = [NSMutableArray arrayWithCapacity:[self.students count]];
        for (NSObject *student in self.students) {
            [another.students addObject:[student copy]];
        }
    }
    another.timeSchedule = [self.timeSchedule copy];
    another.effectiveDateTimestamp = self.effectiveDateTimestamp;
    another.expireDateTimestamp = self.expireDateTimestamp;
    another.repeatType = self.repeatType;
    another.repeateData = self.repeateData;
    another.briefDescription = [self.briefDescription copy];
    return another;
}

+ (NSArray *)sortDescriptors:(BOOL)ascending
{
    NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                [NSSortDescriptor sortDescriptorWithKey:@"timeSchedule" ascending:ascending], nil];
    return sortDescriptors;
}

- (NSArray*)getRepeatWeekDays
{
    NSMutableArray *repeatWeekDays = [NSMutableArray array];
    if (PMCourseScheduleRepeatTypeWeek == self.repeatType) {
        if (PMCourseScheduleRepeatDataWeekDaySunday & self.repeateData) {
            [repeatWeekDays addObject:[NSNumber numberWithLong:PMCourseScheduleRepeatDataWeekDaySunday]];
        }

        if (PMCourseScheduleRepeatDataWeekDayMonday & self.repeateData) {
            [repeatWeekDays addObject:[NSNumber numberWithLong:PMCourseScheduleRepeatDataWeekDayMonday]];
        }

        if (PMCourseScheduleRepeatDataWeekDayTuesday & self.repeateData) {
            [repeatWeekDays addObject:[NSNumber numberWithLong:PMCourseScheduleRepeatDataWeekDayTuesday]];
        }

        if (PMCourseScheduleRepeatDataWeekDayWednesday & self.repeateData) {
            [repeatWeekDays addObject:[NSNumber numberWithLong:PMCourseScheduleRepeatDataWeekDayWednesday]];
        }

        if (PMCourseScheduleRepeatDataWeekDayThursday & self.repeateData) {
            [repeatWeekDays addObject:[NSNumber numberWithLong:PMCourseScheduleRepeatDataWeekDayThursday]];
        }

        if (PMCourseScheduleRepeatDataWeekDayFriday & self.repeateData) {
            [repeatWeekDays addObject:[NSNumber numberWithLong:PMCourseScheduleRepeatDataWeekDayFriday]];
        }

        if (PMCourseScheduleRepeatDataWeekDayStaturday & self.repeateData) {
            [repeatWeekDays addObject:[NSNumber numberWithLong:PMCourseScheduleRepeatDataWeekDayStaturday]];
        }
    }
    return repeatWeekDays;
}

- (void)setRepeatWeekDay:(PMCourseScheduleRepeatDataWeekDay)repeatWeekDay
{
    self.repeatType = PMCourseScheduleRepeatTypeWeek;
    self.repeateData = repeatWeekDay;
}

- (void)addRepeatWeekDay:(PMCourseScheduleRepeatDataWeekDay)repeatWeekDay
{
    self.repeatType = PMCourseScheduleRepeatTypeWeek;
    self.repeateData |= repeatWeekDay;
}

- (void)removeRepeatWeekDay:(PMCourseScheduleRepeatDataWeekDay)repeatWeekDay
{
    self.repeateData &= ~repeatWeekDay;
}

- (BOOL)availableForRepeatWeekDay:(PMCourseScheduleRepeatDataWeekDay)repeatWeekDay
{
    if (PMCourseScheduleRepeatTypeWeek == self.repeatType &&
        self.repeateData&repeatWeekDay) {
        return YES;
    }
    return NO;
}

- (BOOL)availableFordDate:(NSDate*)date
{
    long timestamp  = [date timeIntervalSince1970];
    if (PMCourseScheduleRepeatTypeWeek == self.repeatType &&
        self.effectiveDateTimestamp <= timestamp &&
        timestamp < self.expireDateTimestamp) {
        PMCourseScheduleRepeatDataWeekDay repeatWeekDay = [PMCourseScheduleRepeat repeatWeekDayFromDate:date];
        return [self availableForRepeatWeekDay:repeatWeekDay];
    }
    return NO;
}


@end
