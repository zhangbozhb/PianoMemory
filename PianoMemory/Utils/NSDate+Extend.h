//
//  NSDate+Extend.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-8.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extend)
//- (NSInteger)zb_getDayTimestamp;
//- (NSInteger)zb_getMonthTimestamp;
//- (NSInteger)zb_getYearTimestamp;
//- (NSInteger)zb_getWeekDay;


- (NSDateComponents*)zb_dateComponents;

- (NSInteger)zb_timestampOfDay;
- (NSInteger)zb_timestampOfMonth;
- (NSInteger)zb_timestampOfYear;

//返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)zb_dateAfterDay:(NSInteger)day;
//month个月后的日期
- (NSDate *)zb_dateAfterMonth:(NSInteger)month;
//year个年后的日期
- (NSDate *)zb_dateAfterYear:(NSInteger)year;

//获取日
- (NSInteger)zb_getDay;
//获取月
- (NSInteger)zb_getMonth;
//获取年
- (NSInteger)zb_getYear;
//获取小时
- (NSInteger)zb_getHour;
//获取分钟
- (NSInteger)zb_getMinute;

//获取在 week 中为第几天（周末1...周一2 ...  周六7）
- (NSInteger)zb_weekDay;
//本月第几周
- (NSInteger)zb_weekOfMonth;
//本年第几周
- (NSInteger)zb_weekOfYear;
//本月顺序在第几周，其实就是 日期除周+1（6号及以前为1）
- (NSInteger)zb_weekDayOrdinal;

//获取当前月的天数
- (NSInteger)zb_numberOfDayOfCurrentMonth;

//本周第一天
- (NSDate *)zb_firstDayOfCurrentWeek;
//本月的第一天
- (NSDate *)zb_firstDayOfCurrentMonth;
//本年的第一天
- (NSDate *)zb_firstDayOfCurrentYear;

@end
