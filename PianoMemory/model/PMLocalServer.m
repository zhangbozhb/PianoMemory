//
//  PMLocalServer.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMLocalServer.h"
#import "PMLocalStorage.h"
#import "NSDate+Extend.h"

@interface PMLocalServer ()
@property (nonatomic) PMLocalStorage *localStorage;
@end

@implementation PMLocalServer

+ (instancetype)defaultLocalServer
{
    static PMLocalServer *localServer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localServer = [[PMLocalServer alloc] init];
        localServer.localStorage = [PMLocalStorage defaultLocalStorage];
    });
    return localServer;
}

#pragma clear local db
- (void)clearData
{
    [self.localStorage clearData];
}


#pragma students
- (BOOL)isStudentExist:(PMStudent *)student
{
    BOOL isExist = [self.localStorage isStudentExist:student];
    if (!isExist) {
        isExist = (nil != [self.localStorage getStudentWithId:[student syncCreateLocalId]])?YES:NO;
    }
    return isExist;
}
- (BOOL)saveStudent:(PMStudent*)student
{
    return [self.localStorage storeStudent:student];
}
- (BOOL)deleteStudent:(PMStudent*)student
{
    return [self.localStorage removeStudent:student];
}
- (PMStudent*)queryStudentWithId:(NSString*)studentId
{
    return [self.localStorage getStudentWithId:studentId];
}

- (NSArray *)queryStudents:(NSString*)name phone:(NSString*)phone nameShortcut:(NSString *)nameShortcut
{
    NSMutableArray *students = [NSMutableArray array];
    NSDictionary *viewStudent = [self.localStorage viewStudent];
    for (NSString *studentId in viewStudent) {
        PMStudent *student = [self.localStorage getStudentWithId:studentId];
        BOOL isMatch = NO;
        if (student) {
            if (0 != [name length] &&
                student.name &&
                NSNotFound != [student.name rangeOfString:name].location) {
                isMatch = YES;
            } else if (0 != [phone length] &&
                student.phone &&
                NSNotFound != [student.phone rangeOfString:phone].location) {
                isMatch = YES;
            } else if (0 != [nameShortcut length] &&
                        student.nameShortcut &&
                        NSNotFound != [student.nameShortcut rangeOfString:nameShortcut].location) {
                isMatch = YES;
            } else if (0 ==  [name length]
                       && 0 == [phone length] &&
                       0 == [nameShortcut length]){
                isMatch = YES;
            }
            if (isMatch) {
                [students addObject:student];
            }
        }
    }
    return students;
}

#pragma course
- (BOOL)saveCourse:(PMCourse*)course
{
    return [self.localStorage storeCourse:course];
}
- (BOOL)deleteCourse:(PMCourse*)course
{
    return [self.localStorage removeCourse:course];
}
- (PMCourse*)queryCourseWithId:(NSString*)courseId
{
    return [self.localStorage getCourseWithId:courseId];
}
- (NSArray*)queryCourses:(NSString*)name
{
    NSMutableArray *courses = [NSMutableArray array];
    NSDictionary *viewCourse = [self.localStorage viewCourse];
    for (NSString *courseId in viewCourse) {
        PMCourse *course = [self.localStorage getCourseWithId:courseId];
        if (course) {
            if (0 == [name length] ||
                NSNotFound != [course.name rangeOfString:name].location) {
                [courses addObject:course];
            }
        }
    }
    return courses;
}
- (NSArray*)queryCoursesWithAccurateName:(NSString*)name
{
    NSMutableArray *courses = [NSMutableArray array];
    NSDictionary *viewCourse = [self.localStorage viewCourse];
    for (NSString *courseId in viewCourse) {
        PMCourse *course = [self.localStorage getCourseWithId:courseId];
        if (course) {
            if (0 != [name length] ||
                [name isEqualToString:course.name]) {
                [courses addObject:course];
            }
        }
    }
    return courses;
}

#pragma timeSchedule
- (BOOL)saveTimeSchedule:(PMTimeSchedule*)timeSchedule
{
    return [self.localStorage storeTimeSchedule:timeSchedule];
}
- (BOOL)deleteTimeSchedule:(PMTimeSchedule*)timeSchedule
{
    return [self.localStorage removeTimeSchedule:timeSchedule];
}
- (PMTimeSchedule*)queryTimeScheduleWithId:(NSString*)timeScheduleId
{
    return [self.localStorage getTimeScheduleeWithId:timeScheduleId];
}
- (NSArray*)queryAllTimeSchedule
{
    NSMutableArray *timeSchedules = [NSMutableArray array];
    NSDictionary *viewTimeSchedule = [self.localStorage viewTimeSchedule];
    for (NSString *timeScheudleId in viewTimeSchedule) {
        PMTimeSchedule *timeSchedule = [self.localStorage getTimeScheduleeWithId:timeScheudleId];
        [timeSchedules addObject:timeSchedule];
    }
    return timeSchedules;
}

#pragma courseSchedule
- (BOOL)saveCourseSchedule:(PMCourseSchedule*)courseSchedule
{
    return [self.localStorage storeCourseSchedule:courseSchedule];
}
- (BOOL)deleteCourseSchedule:(PMCourseSchedule*)courseSchedule
{
    return [self.localStorage removeCourseSchedule:courseSchedule];
}
- (PMCourseSchedule*)queryCourseScheduleWithId:(NSString*)courseScheduleId
{
    return [self.localStorage getCourseScheduleWithId:courseScheduleId];
}
- (NSArray*)queryAllCourseSchedule
{
    NSMutableArray *courseSchedules = [NSMutableArray array];
    NSDictionary *viewCourseSchedule = [self.localStorage viewCourseSchedule];
    for (NSString *courseScheduleId in viewCourseSchedule) {
        PMCourseSchedule *courseSchedule = [self.localStorage getCourseScheduleWithId:courseScheduleId];
        if (courseSchedule) {
            [courseSchedules addObject:courseSchedule];
        }
    }
    return courseSchedules;
}

#pragma dayCourseSchedule
- (BOOL)saveDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule
{
    return [self.localStorage storeDayCourseSchedule:dayCourseSchedule];
}
- (BOOL)deleteDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule
{
    return [self.localStorage removeDayCourseSchedule:dayCourseSchedule];
}
- (PMDayCourseSchedule*)queryDayCourseScheduleWithId:(NSString*)dayCourseScheduleId
{
    return [self.localStorage getDayCourseScheduleWithId:dayCourseScheduleId];
}
- (NSArray*)queryAllDayCourseSchedule
{
    NSMutableArray *dayCourseSchedules = [NSMutableArray array];
    NSDictionary *viewDayCourseSchedule = [self.localStorage viewDayCourseSchedule];
    for (NSString *dayCourseScheduleId in viewDayCourseSchedule) {
        PMDayCourseSchedule *dayCourseSchedule = [self.localStorage getDayCourseScheduleWithId:dayCourseScheduleId];
        if (dayCourseSchedule) {
            [dayCourseSchedules addObject:dayCourseSchedule];
        }
    }
    return dayCourseSchedules;
}
- (NSArray*)queryDayCourseSchedulesFrom:(NSInteger)startTime toEndTime:(NSInteger)endTime
{
    NSMutableArray *dayCourseSchedules = [NSMutableArray array];
    NSDictionary *viewDayCourseSchedule = [self.localStorage viewDayCourseSchedule];
    for (NSString *dayCourseScheduleId in viewDayCourseSchedule) {
        NSString *scheduleTimestampString = [viewDayCourseSchedule objectForKey:dayCourseScheduleId];
        NSInteger scheduleTimestamp = [scheduleTimestampString integerValue];
        if (startTime <= scheduleTimestamp &&
            scheduleTimestamp <= endTime) {
            PMDayCourseSchedule *dayCourseSchedule = [self.localStorage getDayCourseScheduleWithId:dayCourseScheduleId];
            if (dayCourseSchedule) {
                [dayCourseSchedules addObject:dayCourseSchedule];
            }
        }
    }
    return dayCourseSchedules;
}
- (PMDayCourseSchedule *)queryDayCourseScheduleOfDate:(NSDate*)date
{
    NSInteger startTime = [date zb_getDayTimestamp];
    NSInteger endTime = [[date zb_dateAfterDay:1] zb_getDayTimestamp] - 1;
    NSArray *dayCourseSchedules = [self queryDayCourseSchedulesFrom:startTime toEndTime:endTime];
    return [dayCourseSchedules firstObject];
}
@end
