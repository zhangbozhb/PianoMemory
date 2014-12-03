//
//  PMSpecialDay.h
//  PianoMemory
//
//  Created by 张 波 on 14/12/2.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PMSpecialDayType_None = 0,
    PMSpecialDayType_Birthday,
    PMSpecialDayType_ForegatherDay,
    PMSpecialDayType_ForegatherDay100,
    PMSpecialDayType_ForegatherDay1000,
    PMSpecialDayType_LoveDay,
    PMSpecialDayType_LoveDay100,
    PMSpecialDayType_LoveDay1000,
} PMSpecialDayType;

@interface PMSpecialDay : NSObject

+ (PMSpecialDayType)specialDayTypeOfToday;


//生日
+ (NSDate*)birthdayDate;
//相识的日期
+ (NSDate*)firstMeetDate;
//相爱的日期
+ (NSDate*)failInLoveDate;
//特殊日期
+ (NSDate*)specialDateOfType:(PMSpecialDayType)specialDayType;
@end
