//
//  PMLocalServer.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMStudent.h"
#import "PMCourse.h"
#import "PMCourseSchedule.h"
#import "PMDayCourseSchedule.h"

@interface PMLocalServer : NSObject
+ (instancetype)defaultLocalServer;
// clear local db
- (void)clearData;

#pragma students
- (BOOL)isStudentExist:(PMStudent *)student;
- (BOOL)saveStudent:(PMStudent*)student;
- (BOOL)deleteStudent:(PMStudent*)student;
- (PMStudent*)queryStudentWithId:(NSString*)studentId;
- (NSArray*)queryStudents:(NSString*)name phone:(NSString*)phone nameShortcut:(NSString *)nameShortcut;

#pragma course
- (BOOL)saveCourse:(PMCourse*)course;
- (BOOL)deleteCourse:(PMCourse*)course;
- (PMCourse*)queryCourseWithId:(NSString*)courseId;
- (NSArray*)queryCourses:(NSString*)name;
- (NSArray*)queryCoursesWithAccurateName:(NSString*)name;

#pragma courseSchedule
- (BOOL)saveCourseSchedule:(PMCourseSchedule*)courseSchedule;
- (BOOL)deleteCourseSchedule:(PMCourseSchedule*)courseSchedule;
- (PMCourseSchedule*)queryCourseScheduleWithId:(NSString*)courseScheduleId;
- (NSArray*)queryAllCourseSchedule;

#pragma dayCourseSchedule
- (BOOL)saveDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule;
- (BOOL)deleteDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule;
- (PMDayCourseSchedule*)queryDayCourseScheduleWithId:(NSString*)dayCourseScheduleId;
- (NSArray*)queryAllDayCourseSchedule;
- (NSArray*)queryDayCourseSchedulesFrom:(NSInteger)startTime toEndTime:(NSInteger)endTime;
- (PMDayCourseSchedule *)queryDayCourseScheduleOfDate:(NSDate*)date;
@end