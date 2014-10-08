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
#import "PMDayCourseSchedule.h"

/**
 *	@brief	数据持久话层
 *  student 和 course 作为基本数据
 *  courseSchedule， daycourseschedule 这里面都有大量的冗余数据

 *  courseSchedule: 作为一个单独item 存放（对于 student 和 course）数据是完全冗余的，
 *  存放：courseSchedule独立与 student和 course。student 和 course 的删除和它没有任何关系。只存在读取的关系
 *  读取:读取最新student 和 course 数据，这样避免studeent，和 course 的删除对其造成影响。
 *  删除:只删除本身，不会删除 student，course。依赖方面是单方面的，弱依赖
 *
 *  daycourseschedule：的处理和 courseSechdule类似，只是由于一般不直接操作 courseSchedule 所以有少许区别
 *  存放：本身就是一条完整的记录。（数据是冗余的）
 *  读取：每次读取最新的 courseSechdule
 *  删除：删除本身，当然同时也删除 courseSchedule(逐个删除)
 */
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
- (PMCourse*)getCourseWithId:(NSString*)courseId;
- (NSDictionary *)viewCourse;

#pragma course schedule
- (BOOL)storeCourseSchedule:(PMCourseSchedule*)courseSchedule;
- (BOOL)removeCourseSchedule:(PMCourseSchedule*)courseSchedule;
- (PMCourseSchedule*)getCourseScheduleWithId:(NSString*)courseScheduleId;
- (NSDictionary *)viewCourseSchedule;

#pragma day course schedule
- (BOOL)storeDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule;
- (BOOL)removeDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule;
- (PMDayCourseSchedule*)getDayCourseScheduleWithId:(NSString*)dayCourseScheduleId;
- (NSDictionary *)viewDayCourseSchedule;
@end
