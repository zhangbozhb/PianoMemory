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
#import "PMCourseScheduleRepeat.h"



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
- (BOOL)availableForRepeatWeekDay:(PMCourseScheduleRepeatDataWeekDay)repeatWeekDay;
- (BOOL)availableFordDate:(NSDate*)date;
@end
