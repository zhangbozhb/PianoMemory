//
//  PMDayCourseSchedule+Wrapper.h
//  PianoMemory
//
//  Created by 张 波 on 14/10/28.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMDayCourseSchedule.h"
#import "PMCourseSchedule.h"

@interface PMDayCourseSchedule (Wrapper)
- (void)addCourseSchedule:(PMCourseSchedule*)coureseSchedule;
@end
