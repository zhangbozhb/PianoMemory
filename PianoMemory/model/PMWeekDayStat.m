//
//  PMWeekDayStat.m
//  PianoMemory
//
//  Created by 张 波 on 14/11/3.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMWeekDayStat.h"

@implementation PMWeekDayStat
- (id)copyWithZone:(NSZone *)zone
{
    PMWeekDayStat *another = [[PMWeekDayStat alloc] init];
    another.repeatWeekday = self.repeatWeekday;
    another.courseCount = self.courseCount;
    another.durationInHour = self.durationInHour;
    return another;
}
+ (NSArray *)sortDescriptors:(BOOL)ascending
{
    NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                [NSSortDescriptor sortDescriptorWithKey:@"courseCount" ascending:ascending],
                                [NSSortDescriptor sortDescriptorWithKey:@"durationInHour" ascending:ascending], nil];
    return sortDescriptors;
}
@end
