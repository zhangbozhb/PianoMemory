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
    another.startDayTime = self.startDayTime;
    another.endDayTime = self.endDayTime;
    another.price = self.price;
    return another;
}
@end
