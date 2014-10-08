//
//  PMDayCourseSchedule.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-7.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMDayCourseSchedule.h"

@implementation PMDayCourseSchedule
- (id)copyWithZone:(NSZone *)zone
{
    PMDayCourseSchedule *another = [super copyWithZone:zone];
    another.scheduleTimestamp = self.scheduleTimestamp;
    if (nil != self.courseSchedules) {
        another.courseSchedules = [NSMutableArray arrayWithCapacity:[self.courseSchedules count]];
        for (NSObject *courseSchedule in self.courseSchedules) {
            [another.courseSchedules addObject:[courseSchedule copy]];
        }
    }
    return another;
}
@end
