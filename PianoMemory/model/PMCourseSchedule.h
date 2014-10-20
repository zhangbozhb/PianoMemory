//
//  PMCourseSchedule.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMObject.h"
#import "PMCourse.h"
#import "PMTimeSchedule.h"
#import "PMStudent.h"

typedef enum {
    PMCourseScheduleRepeatTypeNone = 0,
    PMCourseScheduleRepeatTypeDay,
    PMCourseScheduleRepeatTypeWeek,
    PMCourseScheduleRepeatTypeMonth,
    PMCourseScheduleRepeatTypeYear,
}PMCourseScheduleRepeatType;

@interface PMCourseSchedule : PMObject
@property (nonatomic) PMCourse *course;
@property (nonatomic) NSMutableArray *students;
@property (nonatomic) PMTimeSchedule *timeSchedule;
@property (nonatomic) NSTimeInterval effectiveDateTimestamp;
@property (nonatomic) NSTimeInterval expireDateTimestamp;
@property (nonatomic) NSInteger repeatType;
@property (nonatomic) NSString *briefDescription;

+ (NSArray *)sortDescriptors:(BOOL)ascending;
@end
