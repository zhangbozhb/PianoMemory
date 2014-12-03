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

- (void)setDate:(NSDate *)date
{

    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    NSDateComponents* lunaComponents = [[[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    _year = components.year;
    _month = components.month;
    _day = components.day;
    _week = components.weekday;
    _lunaDay = lunaComponents.day;
    _lunaMonth = lunaComponents.month;
    _lunaYear = lunaComponents.year;
    _date = date;

    //设置农历年，月，日
    NSArray *lunaYearArray = [NSArray arrayWithObjects:
                              @"甲子", @"乙丑", @"丙寅", @"丁卯", @"戊辰", @"己巳",
                              @"庚午", @"辛未", @"壬申", @"癸酉", @"甲戌", @"乙亥",
                              @"丙子", @"丁丑", @"戊寅", @"己卯", @"庚辰", @"辛己",
                              @"壬午", @"癸未", @"甲申", @"乙酉", @"丙戌", @"丁亥",
                              @"戊子", @"己丑", @"庚寅", @"辛卯", @"壬辰", @"癸巳",

                              @"甲午", @"乙未", @"丙申", @"丁酉", @"戊戌", @"己亥",
                              @"庚子", @"辛丑", @"壬寅", @"癸丑", @"甲辰", @"乙巳",
                              @"丙午", @"丁未", @"戊申", @"己酉", @"庚戌", @"辛亥",
                              @"壬子", @"癸丑", @"甲寅", @"乙卯", @"丙辰", @"丁巳",
                              @"戊午", @"己未", @"庚申", @"辛酉", @"壬戌", @"癸亥", nil];
    _lunaYearString = [lunaYearArray objectAtIndex:_lunaYear-1];

    NSArray *lunaMonthArray = [NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"冬月", @"腊月", nil];
    _lunaMonthString = [lunaMonthArray objectAtIndex:_lunaMonth-1];

    NSArray *lunaDayArray = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一", nil];
    _lunaDayString = [lunaDayArray objectAtIndex:_lunaDay-1];

    //设置节假日
    NSString *holiday = nil;
    if (1 ==  _lunaMonth &&
        1 == _lunaDay) {            //正月初一：春节
        holiday = @"春节";
    } else if (1 ==  _lunaMonth &&
               15 == _lunaDay) {    //正月十五：元宵节
        holiday = @"元宵";
    } else if (2 == _lunaMonth &&
               2 == _lunaDay) {     //二月初二：春龙节(龙抬头)
        holiday = @"龙抬头";
    } else if (5 == _lunaMonth &&
               5 == _lunaDay) {     //五月初五：端午节
        holiday = @"端午";
    } else if (7 == _lunaMonth &&
               7 == _lunaDay) {     //七月初七：七夕情人节
        holiday = @"七夕";
    } else if (8 == _lunaMonth &&
               15 == _lunaDay) {    //八月十五：中秋节
        holiday = @"中秋";
    } else if (9 == _lunaMonth &&
               9 == _lunaDay) {     //九月初九：重阳节
        holiday = @"重阳";
    } else if (12 == _lunaMonth &&
               8 == _lunaDay) {     //腊月初八：腊八节
        holiday = @"腊八";
    } else if (12 == _lunaMonth &&
               24 == _lunaDay) {    //腊月二十四 小年
        holiday = @"小年";
    } else if (12 == _lunaMonth &&
               (30 == _lunaDay || 29 == _lunaDay)) {    //腊月三十（小月二十九）：除夕
        if (30 == _lunaDay) {
            holiday = @"除夕";
        } else {
            lunaComponents = [[[NSCalendar alloc]initWithCalendarIdentifier:NSChineseCalendar]
                              components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                              fromDate:[date zb_dateAfterDay:1]];
            if (1 == lunaComponents.month &&
                1 == lunaComponents.day) {
                holiday = @"除夕";
            }
        }
    }

    //公历节日
    if (1 ==  _month &&
        1 == _day) { //元旦
        holiday = @"元旦";
    } else if (2 ==  _month &&
               14 == _day) { //情人节
        holiday = @"情人节";
    } else if (3 ==  _month &&
               8 == _day) { //妇女节
        holiday = @"妇女节";
    } else if (5 ==  _month &&
               1 == _day) { //劳动节
        holiday = @"劳动节";
    } else if (6 ==  _month &&
               1 == _day) { //儿童节
        holiday = @"儿童节";
    } else if (8 ==  _month &&
               1 == _day) { //建军节
        holiday = @"建军节";
    } else if (9 ==  _month &&
               10 == _day) { //教师节
        holiday = @"教师节";
    } else if (10 ==  _month &&
               1 == _day) { //国庆节
        holiday = @"国庆节";
    } else if (11 ==  _month &&
               11 == _day) { //光棍节
        holiday = @"光棍节";
    }
    if (holiday) {
        _holiday = holiday;
    }
}
@end
