//
//  PMBusiness.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-10.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMTimeSchedule.h"
#import "PMCourseSchedule.h"
#import "PMDayCourseSchedule.h"

@interface PMBusiness : NSObject
+ (BOOL)isTimeScheduleValid:(NSArray*)timeSchedules;
+ (PMDayCourseSchedule*)createDayCourseScheduleWithCourseSchedules:(NSArray*)courseSchedules atDate:(NSDate*)atDate;
@end
