//
//  NSDate+Extend.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-8.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "NSDate+Extend.h"

@implementation NSDate (Extend)

- (NSInteger)zb_timestampOfDay
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [currentCalendar components:
                               NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                                 fromDate:self];
    return [[currentCalendar dateFromComponents:comps] timeIntervalSince1970];
}

- (NSInteger)zb_timestampOfMonth
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [currentCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth
                                                  fromDate:self];
    return [[currentCalendar dateFromComponents:comps] timeIntervalSince1970];
}
- (NSInteger)zb_timestampOfYear
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
- (NSDate *)zb_dateAfterMonth:(NSInteger)month
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
    NSDateComponents *dayComponents = [calendar components:NSDayCalendarUnit fromDate:self];
    return [dayComponents day];
}
//获取月
- (NSInteger)zb_getMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:NSMonthCalendarUnit fromDate:self];
    return [dayComponents month];
}
//获取年
- (NSInteger)zb_getYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:NSYearCalendarUnit fromDate:self];
    return [dayComponents year];
}
//获取小时
- (NSInteger)zb_getHour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit;
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

//获取在 week 中为第几天（周末1...周一2 ...  周六7）
- (NSInteger)zb_weekDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    return [components weekday];
}

//本月第几周
- (NSInteger)zb_weekOfMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSWeekOfMonthCalendarUnit fromDate:self];
    return [components weekOfMonth];
}
//本年第几周
- (NSInteger)zb_weekOfYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSWeekOfYearCalendarUnit fromDate:self];
    return [components weekOfYear];
}
//本月顺序在第几周，其实就是 日期除周+1（6号及以前为1）
- (NSInteger)zb_weekDayOrdinal
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    return [components weekdayOrdinal];
}


//获取当前月的天数
- (NSInteger)zb_numberOfDayOfCurrentMonth
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    return range.length;
}


//本周第一天
- (NSDate *)zb_firstDayOfCurrentWeek
{
    NSDate *startDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSWeekdayCalendarUnit startDate:&startDate interval:NULL forDate:self];
    return startDate;
}
//本月的第一天
- (NSDate *)zb_firstDayOfCurrentMonth
{
    NSDate *startDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&startDate interval:NULL forDate:self];
    return startDate;
}
//本年的第一天
- (NSDate *)zb_firstDayOfCurrentYear
{
    NSDate *startDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSYearCalendarUnit startDate:&startDate interval:NULL forDate:self];
    return startDate;
}
@end
