//
//  NSDate+Extend.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-8.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "NSDate+Extend.h"

@implementation NSDate (Extend)
- (NSDateComponents*)zb_dateComponents
{
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    return [[NSCalendar currentCalendar] components:unitFlags fromDate:self];
}

- (NSInteger)zb_timestampOfBeginDay
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [currentCalendar components:
                               NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                                 fromDate:self];
    return [[currentCalendar dateFromComponents:comps] timeIntervalSince1970];
}

- (NSInteger)zb_timestampOfBeginMonth
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [currentCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth
                                                  fromDate:self];
    return [[currentCalendar dateFromComponents:comps] timeIntervalSince1970];
}
- (NSInteger)zb_timestampOfBeginYear
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
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
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
    NSDateComponents *dayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self];
    return [dayComponents day];
}
//获取月
- (NSInteger)zb_getMonth
{
    NSDateComponents *dayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self];
    return [dayComponents month];
}
//获取年
- (NSInteger)zb_getYear
{
    NSDateComponents *dayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    return [dayComponents year];
}
//获取小时
- (NSInteger)zb_getHour
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self];
    return [components hour];
}
//获取分钟
- (NSInteger)zb_getMinute
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self];
    return [components minute];
}
//获取农历日
- (NSInteger)zb_getLunaDay
{
    NSDateComponents *dayComponents = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese] components:NSCalendarUnitDay fromDate:self];
    return [dayComponents day];
}
//获取农历月
- (NSInteger)zb_getLunaMonth
{
    NSDateComponents *dayComponents = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese] components:NSCalendarUnitMonth fromDate:self];
    return [dayComponents month];
}

//获取在 week 中为第几天（周末1...周一2 ...  周六7）
- (NSInteger)zb_weekDay
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    return [components weekday];
}

//本月第几周
- (NSInteger)zb_weekOfMonth
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self];
    return [components weekOfMonth];
}
//本年第几周
- (NSInteger)zb_weekOfYear
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self];
    return [components weekOfYear];
}
//本月顺序在第几周，其实就是 日期除周+1（6号及以前为1）
- (NSInteger)zb_weekDayOrdinal
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    return [components weekdayOrdinal];
}


//获取当前月的天数
- (NSInteger)zb_numberOfDayOfCurrentMonth
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}


//本周第一天
- (NSDate *)zb_firstDayOfCurrentWeek
{
    NSDate *startDate = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitWeekday startDate:&startDate interval:NULL forDate:self];
    return startDate;
}
//本月的第一天
- (NSDate *)zb_firstDayOfCurrentMonth
{
    NSDate *startDate = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:self];
    return startDate;
}
//本年的第一天
- (NSDate *)zb_firstDayOfCurrentYear
{
    NSDate *startDate = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitYear startDate:&startDate interval:NULL forDate:self];
    return startDate;
}
@end
