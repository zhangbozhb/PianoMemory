//
//  PMDayCourseSchedule+Wrapper.m
//  PianoMemory
//
//  Created by 张 波 on 14/10/28.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMDayCourseSchedule+Wrapper.h"

@implementation PMDayCourseSchedule (Wrapper)
- (void)addCourseSchedule:(PMCourseSchedule*)coureseSchedule
{
    if (nil != self.courseSchedules) {
        [self.courseSchedules addObject:coureseSchedule];
    } else {
        self.courseSchedules = [NSMutableArray arrayWithObject:coureseSchedule];
    }
}
@end
