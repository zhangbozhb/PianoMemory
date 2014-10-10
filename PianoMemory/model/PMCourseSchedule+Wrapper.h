//
//  PMCourseSchedule+Wrapper.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-9.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCourseSchedule.h"

@interface PMCourseSchedule (Wrapper)
- (NSString *)getNotNilCourseName;
- (NSString*)getNotNilStudentNameWith:(NSString*)divisionString;
@end
