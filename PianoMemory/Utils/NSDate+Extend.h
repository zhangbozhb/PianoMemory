//
//  NSDate+Extend.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-8.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extend)
- (NSInteger)zb_getDayTimestamp;
- (NSInteger)zb_getMonthTimestamp;
- (NSInteger)zb_getYearTimestamp;

//返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)zb_dateAfterDay:(NSInteger)day;
//month个月后的日期
- (NSDate *)zb_dateafterMonth:(NSInteger)month;
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


- (NSInteger)zb_numberOfDayOfCurrentMonth;

@end
