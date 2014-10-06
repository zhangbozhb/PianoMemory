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
#import "PMCourseSchedule.h"

@interface PMServerWrapper : NSObject
+ (instancetype)defaultServer;

- (void)createStudent:(PMStudent*)student success:(void(^)(PMStudent *student))success failure:(void(^)(HCErrorMessage *error))failure;
- (void)updateStudent:(PMStudent*)student success:(void(^)(PMStudent *student))success failure:(void(^)(HCErrorMessage *error))failure;
- (void)deleteStudent:(PMStudent*)student success:(void(^)(PMStudent *student))success failure:(void(^)(HCErrorMessage *error))failure;
//param 	phone,name,nameShortcut
- (void)queryStudents:(NSDictionary *)parameters success:(void(^)(NSArray *array))success failure:(void(^)(HCErrorMessage *error))failure;
@end
