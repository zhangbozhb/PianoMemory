//
//  PMDayReportPieElement.m
//  PianoMemory
//
//  Created by 张 波 on 14/11/4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMDayReportPieElement.h"

@implementation PMDayReportPieElement
- (id)copyWithZone:(NSZone *)zone
{
    PMDayReportPieElement *another = [super copyWithZone:zone];
    another.dayStatistics = [self.dayStatistics copy];
    return another;
}
@end
