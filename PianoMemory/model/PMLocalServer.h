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


@interface PMLocalServer : NSObject
+ (instancetype)defaultLocalServer;
// clear local db
- (void)clearData;

#pragma students
- (BOOL)isStudentExist:(PMStudent *)student;
- (BOOL)saveStudent:(PMStudent*)student;
- (BOOL)deleteStudent:(PMStudent*)student;
- (PMStudent*)queryStudentWithId:(NSString*)studentId;
- (NSArray*)queryStudents:(NSString*)name phone:(NSString*)phone;
@end
