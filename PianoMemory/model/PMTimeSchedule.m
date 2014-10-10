//
//  PMTimeSchedule.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-10.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMTimeSchedule.h"

@implementation PMTimeSchedule
- (id)copyWithZone:(NSZone *)zone
{
    PMTimeSchedule *another = [super copyWithZone:zone];
    another.name = [self.name copy];
    another.startTime = self.startTime;
    another.endTime = self.endTime;
    return another;
}

- (BOOL)isValid
{
    return (0 <= self.startTime && self.startTime < self.endTime)?YES:NO;
}

+ (NSArray *)sortDescriptors:(BOOL)ascending
{
    NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:ascending],
                                [NSSortDescriptor sortDescriptorWithKey:@"endTime" ascending:ascending], nil];
    return sortDescriptors;
}
@end
