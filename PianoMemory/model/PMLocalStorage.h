//
//  PMLocalStorage.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "PMStudent.h"
#import "PMCourse.h"
#import "PMCourseSchedule.h"

@interface PMLocalStorage : NSObject
+ (instancetype)defaultLocalStorage;

- (void)clearData;

#pragma students
- (BOOL)isStudentExist:(PMStudent *)student;
- (BOOL)storeStudent:(PMStudent*)student;
- (BOOL)removeStudent:(PMStudent*)student;
- (PMStudent*)getStudentWithId:(NSString*)studentId;
- (NSDictionary *)viewStudent;

#pragma course
- (BOOL)storeCourse:(PMCourse*)course;
- (BOOL)removeCourse:(PMCourse*)course;

#pragma course schedule
- (BOOL)storeCourseSchedule:(PMCourseSchedule*)courseSchedule;
- (BOOL)removeCourseSchedule:(PMCourseSchedule*)courseSchedule;
@end
