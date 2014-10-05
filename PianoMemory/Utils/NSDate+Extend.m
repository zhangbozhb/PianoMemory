//
//  NSDate+Extend.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-8.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "NSDate+Extend.h"

@implementation NSDate (Extend)

- (NSInteger)zb_getDayTimestamp
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [currentCalendar components:
                               NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                                 fromDate:self];
    return [[currentCalendar dateFromComponents:comps] timeIntervalSince1970];
}

- (NSInteger)zb_getMonthTimestamp
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [currentCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth
                                                  fromDate:self];
    return [[currentCalendar dateFromComponents:comps] timeIntervalSince1970];
}
- (NSInteger)zb_getYearTimestamp
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [currentCalendar components:NSCalendarUnitYear
                                                 fromDate:self];
    return [[currentCalendar dateFromComponents:comps] timeIntervalSince1970];
}

//返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)zb_dateAfterDay:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    // NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:day];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];

    return dateAfterDay;
}
//month个月后的日期
- (NSDate *)zb_dateafterMonth:(NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setMonth:month];
    NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];

    return dateAfterMonth;
}
//year个年后的日期
- (NSDate *)zb_dateAfterYear:(NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setYear:year];
    NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];

    return dateAfterMonth;
}
//获取日
- (NSInteger)zb_getDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:self];
    return [dayComponents day];
}
//获取月
- (NSInteger)zb_getMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:self];
    return [dayComponents month];
}
//获取年
- (NSInteger)zb_getYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:self];
    return [dayComponents year];
}
//获取小时
- (NSInteger)zb_getHour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    return [components hour];
}
//获取分钟
- (NSInteger)zb_getMinute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    return [components minute];
}

- (NSInteger)zb_numberOfDayOfCurrentMonth
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    return range.length;
}
@end
