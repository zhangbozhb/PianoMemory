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

typedef enum {
    PMCourseScheduleRepeatDataWeekDayMonday = 1 ,
    PMCourseScheduleRepeatDataWeekDayTuesday = 1 << 1,
    PMCourseScheduleRepeatDataWeekDayWednesday  = 1 << 2,
    PMCourseScheduleRepeatDataWeekDayThursday  = 1 << 3,
    PMCourseScheduleRepeatDataWeekDayFriday  = 1 << 4,
    PMCourseScheduleRepeatDataWeekDayStaturday  = 1 << 5,
    PMCourseScheduleRepeatDataWeekDaySunday = 1 << 6,
}PMCourseScheduleRepeatDataWeekDay;

@interface PMCourseSchedule : PMObject
@property (nonatomic) PMCourse *course;
@property (nonatomic) NSMutableArray *students;
@property (nonatomic) PMTimeSchedule *timeSchedule;
@property (nonatomic) NSTimeInterval effectiveDateTimestamp;
@property (nonatomic) NSTimeInterval expireDateTimestamp;
@property (nonatomic) NSInteger repeatType;
@property (nonatomic) NSInteger repeateData;
@property (nonatomic) NSString *briefDescription;

+ (NSArray *)sortDescriptors:(BOOL)ascending;

- (NSArray*)getRepeatWeekDays;
- (void)setRepeatWeekDay:(PMCourseScheduleRepeatDataWeekDay)repeatWeekDay;
- (void)addRepeatWeekDay:(PMCourseScheduleRepeatDataWeekDay)repeatWeekDay;
- (void)removeRepeatWeekDay:(PMCourseScheduleRepeatDataWeekDay)repeatWeekDay;

+ (NSInteger)getWeekDayIndexFromRepeatWeekDay:(PMCourseScheduleRepeatDataWeekDay)repeateWeekDay;
+ (PMCourseScheduleRepeatDataWeekDay)getRepeatWeekDayFromWeekDayIndex:(NSInteger)weekDayIndex;
@end
