//
//  PMSpecialDay.m
//  PianoMemory
//
//  Created by 张 波 on 14/12/2.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMSpecialDay.h"
#import "NSDate+Extend.h"

@implementation PMSpecialDay

+ (PMSpecialDayType)specialDayTypeOfToday
{
    PMSpecialDayType dayType = PMSpecialDayType_None;
    NSDate *todayDate = [NSDate date];
    NSInteger todayTimestamp = [todayDate zb_timestampOfBeginDay];

    NSDate *birthDay = [self birthdayDate];
    if ([todayDate zb_getLunaDay] == [birthDay zb_getLunaDay]
        && [todayDate zb_getLunaMonth] == [birthDay zb_getLunaMonth]) {
        dayType = PMSpecialDayType_Birthday;
    }

    NSDate *meetDate = [self firstMeetDate];
    if ([[meetDate zb_dateAfterDay:100] zb_timestampOfBeginDay] == todayTimestamp) {
        dayType = PMSpecialDayType_MeetDay100;
    } else if ([[meetDate zb_dateAfterDay:1000] zb_timestampOfBeginDay] == todayTimestamp) {
        dayType = PMSpecialDayType_MeetDay1000;
    } else if ([meetDate zb_getMonth] ==  [todayDate zb_getMonth]
               && [meetDate zb_getDay] ==  [todayDate zb_getDay]) {
        dayType = PMSpecialDayType_MeetDay;
    }

    NSDate *loveDate = [self failInLoveDate];
    if ([[loveDate zb_dateAfterDay:100] zb_timestampOfBeginDay] == todayTimestamp) {
        dayType = PMSpecialDayType_LoveDay100;
    } else if ([[loveDate zb_dateAfterDay:1000] zb_timestampOfBeginDay] == todayTimestamp) {
        dayType = PMSpecialDayType_LoveDay1000;
    } else if ([loveDate zb_getMonth] ==  [todayDate zb_getMonth]
               && [loveDate zb_getDay] ==  [todayDate zb_getDay]) {
        dayType = PMSpecialDayType_LoveDay;
    }

    return dayType;
}

+ (NSDate*)birthdayDate
{
    //农历为：1987，11，25
    NSDateComponents *birthDayComponents = [[NSDateComponents alloc] init];
    birthDayComponents.year = 1988;
    birthDayComponents.month = 1;
    birthDayComponents.day = 14;
    return [[NSCalendar currentCalendar] dateFromComponents:birthDayComponents];
}

+ (NSDate*)firstMeetDate
{
    NSDateComponents *birthDayComponents = [[NSDateComponents alloc] init];
    birthDayComponents.year = 2014;
    birthDayComponents.month = 10;
    birthDayComponents.day = 1;
    return [[NSCalendar currentCalendar] dateFromComponents:birthDayComponents];
}

+ (NSDate*)failInLoveDate
{
    NSDateComponents *birthDayComponents = [[NSDateComponents alloc] init];
    birthDayComponents.year = 2014;
    birthDayComponents.month = 11;
    birthDayComponents.day = 23;
    return [[NSCalendar currentCalendar] dateFromComponents:birthDayComponents];
}

+ (NSDate*)specialDateOfType:(PMSpecialDayType)specialDayType
{
    NSDate *specailDate = nil;
    switch (specialDayType) {
        case PMSpecialDayType_Birthday:
            specailDate = [self birthdayDate];
            break;
        case PMSpecialDayType_MeetDay:
            specailDate = [self firstMeetDate];
            break;
        case PMSpecialDayType_MeetDay100:
            specailDate = [[self firstMeetDate] zb_dateAfterDay:100];
            break;
        case PMSpecialDayType_MeetDay1000:
            specailDate = [[self firstMeetDate] zb_dateAfterDay:1000];
            break;
        case PMSpecialDayType_LoveDay:
            specailDate = [self failInLoveDate];
            break;
        case PMSpecialDayType_LoveDay100:
            specailDate = [[self failInLoveDate] zb_dateAfterDay:100];
            break;
        case PMSpecialDayType_LoveDay1000:
            specailDate = [[self failInLoveDate] zb_dateAfterDay:1000];
            break;
        default:
            break;
    }
    return specailDate;
}
@end
