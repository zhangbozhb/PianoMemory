//
//  PMCalendarDayModel.m
//  PianoMemory
//
//  Created by 张 波 on 14/11/18.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCalendarDayModel.h"
#import "NSDate+Extend.h"

@implementation PMCalendarDayModel
- (instancetype)initWithDate:(NSDate*)date
{
    self = [super init];
    if (self) {
        self.date = date;
    }
    return self;
}

- (instancetype)initWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    self = [super init];
    if (self) {

        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.year = year;
        components.month = month;
        components.day = day;
        self.date = [[NSCalendar currentCalendar] dateFromComponents:components];
    }
    return self;
}

- (void)setDate:(NSDate *)date
{
    NSDateComponents *components = [date zb_dateComponents];
    _year = components.year;
    _month = components.month;
    _day = components.day;
    _date = date;
}
@end
