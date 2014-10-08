//
//  PMCourse.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCourse.h"

@implementation PMCourse
- (id)copyWithZone:(NSZone *)zone
{
    PMCourse *another = [super copyWithZone:zone];
    another.name = [self.name copy];
    another.briefDescription = [self.briefDescription copy];
    another.type = self.type;
    another.startTime = self.startTime;
    another.endTime = self.endTime;
    another.price = self.price;
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
