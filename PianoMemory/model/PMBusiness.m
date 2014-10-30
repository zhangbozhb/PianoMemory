//
//  PMBusiness.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-10.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMBusiness.h"

@implementation PMBusiness
+ (BOOL)isTimeScheduleValid:(NSArray*)timeSchedules
{
    NSArray *sortedTimeSchedules = [timeSchedules sortedArrayUsingDescriptors:[PMTimeSchedule sortDescriptors:YES]];
    BOOL isValid = YES;
    PMTimeSchedule *lastTimeSchedule = nil;
    for (PMTimeSchedule *timeSchedule in sortedTimeSchedules) {
        if (nil == lastTimeSchedule) {
            lastTimeSchedule = timeSchedule;
        } else {
            if (lastTimeSchedule.endTime > timeSchedule.startTime) {
                isValid = NO;
                break;
            }
        }
    }
    return isValid;
}

+ (PMDayCourseSchedule*)createDayCourseScheduleWithCourseSchedules:(NSArray*)courseSchedules atDate:(NSDate*)atDate
{
    PMDayCourseSchedule *dayCourseSchedule = [[PMDayCourseSchedule alloc] init];
    dayCourseSchedule.scheduleTimestamp = [atDate timeIntervalSince1970];
    dayCourseSchedule.courseSchedules = [NSMutableArray arrayWithArray:courseSchedules];
    dayCourseSchedule.created = [[NSDate date] timeIntervalSince1970];
    return dayCourseSchedule;
}
@end
