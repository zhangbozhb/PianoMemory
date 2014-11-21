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
#import "PMTimeSchedule.h"
#import "PMCourseSchedule.h"
#import "PMDayCourseSchedule.h"

@interface PMLocalServer : NSObject
+ (instancetype)defaultLocalServer;
// clear local db
- (void)clearData;

#pragma students
- (BOOL)isStudentExist:(PMStudent *)student;
- (BOOL)isStudentWithPhoneExist:(NSString*)phone;
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

#pragma timeSchedule
- (BOOL)saveTimeSchedule:(PMTimeSchedule*)timeSchedule;
- (BOOL)deleteTimeSchedule:(PMTimeSchedule*)timeSchedule;
- (PMTimeSchedule*)queryTimeScheduleWithId:(NSString*)timeScheduleId;
- (NSArray*)queryAllTimeSchedule;

#pragma courseSchedule
- (BOOL)saveCourseSchedule:(PMCourseSchedule*)courseSchedule;
- (BOOL)deleteCourseSchedule:(PMCourseSchedule*)courseSchedule;
- (PMCourseSchedule*)queryCourseScheduleWithId:(NSString*)courseScheduleId;
- (NSArray*)queryAllCourseSchedule;
- (NSArray *)queryCourseScheduleOfDate:(NSDate*)date;       //查询逻辑上某一天的课程

#pragma dayCourseSchedule
- (BOOL)saveDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule;
- (BOOL)deleteDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule;
- (PMDayCourseSchedule*)queryDayCourseScheduleWithId:(NSString*)dayCourseScheduleId;
- (NSArray*)queryAllDayCourseSchedule;
/**
 *	@brief	获取指定时间段内的 每日排课信息
 *
 *	@param 	startTime 	开始时间
 *	@param 	endTime 	截至时间
 *	@param 	fillNotExist 	如果在指定时间段类的排课信息，没有创建，则自动填充
 *
 *	@return	排课信息
 */
- (NSArray*)queryDayCourseSchedulesFrom:(NSInteger)startTime toEndTime:(NSInteger)endTime fillNotExist:(BOOL)fillNotExist;

/**
 *	@brief	将课程安排添加到历史数据中
 *
 *	@param 	courseSchedule 	课程安排
 *
 *	@return	是否成功添加
 */
- (BOOL)updateHistoryDayCourseScheduleWithCourseSchedule:(PMCourseSchedule*)courseSchedule;

@end
