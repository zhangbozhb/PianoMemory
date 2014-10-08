//
//  PMCourseSchedule.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCourseSchedule.h"

@implementation PMCourseSchedule
- (id)copyWithZone:(NSZone *)zone
{
    PMCourseSchedule *another = [super copyWithZone:zone];
    another.course = [self.course copy];
    if (nil != self.students) {
        another.students = [NSMutableArray arrayWithCapacity:[self.students count]];
        for (NSObject *student in self.students) {
            [another.students addObject:[student copy]];
        }
    }
    another.startTime = self.startTime;
    another.endTime = self.endTime;
    another.briefDescription = [self.briefDescription copy];
    return another;
}

+ (NSArray *)sortDescriptors:(BOOL)ascending
{
    NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:ascending],
                                [NSSortDescriptor sortDescriptorWithKey:@"endTime" ascending:ascending], nil];
    return sortDescriptors;
}
@end
