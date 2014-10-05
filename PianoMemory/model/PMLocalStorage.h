//
//  PMLocalStorage.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "FMSyncStorage.h"
#import "PMStudent.h"
#import "PMCourse.h"
#import "PMCourseSchedule.h"

@interface PMLocalStorage : FMSyncStorage
+ (instancetype)defaultLocalStorage;

#pragma students
- (BOOL)isStudentExist:(PMStudent *)student;
- (BOOL)saveStudent:(PMStudent*)student;
- (BOOL)updateStudent:(PMStudent*)student;
- (BOOL)deleteStudent:(PMStudent*)student;

#pragma course
- (BOOL)saveCourse:(PMCourse*)course;
- (BOOL)updateCourse:(PMCourse*)course;
- (BOOL)deleteCourse:(PMCourse*)course;

#pragma course schedule
- (BOOL)saveCourseSchedule:(PMCourseSchedule*)courseSchedule;
- (BOOL)updateCourseSchedule:(PMCourseSchedule*)courseSchedule;
- (BOOL)deleteCourseSchedule:(PMCourseSchedule*)courseSchedule;
@end
