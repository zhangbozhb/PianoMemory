//
//  PMServerWrapper.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCErrorMessage.h"
#import "PMStudent.h"
#import "PMCourse.h"
#import "PMTimeSchedule.h"
#import "PMCourseSchedule.h"
#import "PMDayCourseSchedule.h"

@interface PMServerWrapper : NSObject
+ (instancetype)defaultServer;

- (void)createStudent:(PMStudent*)student success:(void(^)(PMStudent *student))success failure:(void(^)(HCErrorMessage *error))failure;
- (void)updateStudent:(PMStudent*)student success:(void(^)(PMStudent *student))success failure:(void(^)(HCErrorMessage *error))failure;
- (void)deleteStudent:(PMStudent*)student success:(void(^)(PMStudent *student))success failure:(void(^)(HCErrorMessage *error))failure;
//param 	phone,name,nameShortcut
- (void)queryStudents:(NSDictionary *)parameters success:(void(^)(NSArray *array))success failure:(void(^)(HCErrorMessage *error))failure;

#pragma course
- (void)createCourse:(PMCourse*)course success:(void(^)(PMCourse *course))success failure:(void(^)(HCErrorMessage *error))failure;
- (void)updateCourse:(PMCourse*)course success:(void(^)(PMCourse *course))success failure:(void(^)(HCErrorMessage *error))failure;
- (void)deleteCourse:(PMCourse*)course success:(void(^)(PMCourse *course))success failure:(void(^)(HCErrorMessage *error))failure;
- (NSArray*)queryCoursesWithAccurateName:(NSString*)name;
//param 	name
- (void)queryCourses:(NSDictionary *)parameters success:(void(^)(NSArray *array))success failure:(void(^)(HCErrorMessage *error))failure;

#pragma timeSchedule
- (void)createTimeSchedule:(PMTimeSchedule*)timeSchedule success:(void(^)(PMTimeSchedule *timeSchedule))success failure:(void(^)(HCErrorMessage *error))failure;
- (void)updateTimeSchedule:(PMTimeSchedule*)timeSchedule success:(void(^)(PMTimeSchedule *timeSchedule))success failure:(void(^)(HCErrorMessage *error))failure;
- (void)deleteTimeSchedule:(PMTimeSchedule*)timeSchedule success:(void(^)(PMTimeSchedule *timeSchedule))success failure:(void(^)(HCErrorMessage *error))failure;
- (void)queryAllTimeSchedules:(void(^)(NSArray *array))success failure:(void(^)(HCErrorMessage *error))failure;

#pragma courseSchedule
- (void)createCourseSchedule:(PMCourseSchedule*)courseSchedule success:(void(^)(PMCourseSchedule *courseSchedule))success failure:(void(^)(HCErrorMessage *error))failure;
- (void)updateCourseSchedule:(PMCourseSchedule*)courseSchedule success:(void(^)(PMCourseSchedule *courseSchedule))success failure:(void(^)(HCErrorMessage *error))failure;
- (void)deleteCourseSchedule:(PMCourseSchedule*)courseSchedule success:(void(^)(PMCourseSchedule *courseSchedule))success failure:(void(^)(HCErrorMessage *error))failure;
- (void)queryAllCourseSchedules:(void(^)(NSArray *array))success failure:(void(^)(HCErrorMessage *error))failure;
- (void)queryCourseScheduleOfDate:(NSDate*)date success:(void(^)(NSArray *array))success failure:(void(^)(HCErrorMessage *error))failure;

#pragma dayCourseSchedule
- (void)createDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule success:(void(^)(PMDayCourseSchedule *dayCourseSchedule))success failure:(void(^)(HCErrorMessage *error))failure;
- (void)updateDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule success:(void(^)(PMDayCourseSchedule *dayCourseSchedule))success failure:(void(^)(HCErrorMessage *error))failure;
- (void)deleteDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule success:(void(^)(PMDayCourseSchedule *dayCourseSchedule))success failure:(void(^)(HCErrorMessage *error))failure;
//param 	starttime, endtime, create
- (void)queryDayCourseSchedules:(NSDictionary *)parameters success:(void(^)(NSArray *array))success failure:(void(^)(HCErrorMessage *error))failure;
- (void)queryDayCourseScheduleOfDate:(NSDate*)date success:(void(^)(PMDayCourseSchedule *dayCourseSchedule))success failure:(void(^)(HCErrorMessage *error))failure;
@end
