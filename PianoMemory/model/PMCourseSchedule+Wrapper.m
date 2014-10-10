//
//  PMCourseSchedule+Wrapper.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-9.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCourseSchedule+Wrapper.h"
#import "PMCourse+Wrapper.h"
#import "PMStudent+Wrapper.h"

@implementation PMCourseSchedule (Wrapper)

- (NSString *)getNotNilCourseName
{
    NSString *name = @"";
    if (self.course && self.course.name) {
        name = [self.course getNotNilName];
    }
    return name;
}
- (NSString*)getNotNilStudentNameWith:(NSString*)divisionString
{
    NSMutableArray *studentNames = [NSMutableArray array];
    for (PMStudent *student in self.students) {
        [studentNames addObject:[student getNotNilName]];
    }
    if (!divisionString) {
        divisionString = @";";
    }
    return [studentNames componentsJoinedByString:divisionString];
}
@end
