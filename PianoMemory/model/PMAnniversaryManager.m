//
//  PMAnniversaryManager.m
//  PianoMemory
//
//  Created by 张 波 on 14/12/2.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMAnniversaryManager.h"
#import "NSDate+Extend.h"
#import "PMSpecialDay.h"

@implementation PMAnniversaryManager
+ (instancetype)defaultMananger
{
    static PMAnniversaryManager *anniversaryManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        anniversaryManager =  [[PMAnniversaryManager alloc] init];
    });
    return anniversaryManager;
}

- (void)startNotification
{
    //取消原来的所有通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    [self startForegatherNotification];

    [self startLoveNotification];
}

//相识通知
- (void)startForegatherNotification
{
    NSArray *timeTrigerDayArray = [NSArray arrayWithObjects:
                                   [PMSpecialDay specialDateOfType:PMSpecialDayType_ForegatherDay100],
                                   [PMSpecialDay specialDateOfType:PMSpecialDayType_ForegatherDay1000],
                                   nil];
    NSArray *timeTrigerBriefArray = [NSArray arrayWithObjects:
                                     NSLocalizedString(@"foregatherDay100Brief", @"foregatherDay100Brief"),
                                     NSLocalizedString(@"foregatherDay1000Brief", @"foregatherDay1000Brief"),
                                     nil];
    NSArray *timeTrigerDayTypeArray = [NSArray arrayWithObjects:
                                   [NSNumber numberWithInteger:PMSpecialDayType_ForegatherDay100],
                                   [NSNumber numberWithInteger:PMSpecialDayType_ForegatherDay1000],
                                   nil];
    NSArray *timeTrigerDetailArray = [NSArray arrayWithObjects:
                                      NSLocalizedString(@"foregatherDay100Detail", @"foregatherDay100Detail"),
                                      NSLocalizedString(@"foregatherDay1000Detail", @"foregatherDay1000Detail"),
                                      nil];
    NSDate *currentDate = [NSDate date];
    for (NSInteger index = 0, count = [timeTrigerDayArray count]; index < count; ++index) {
        NSDate *trigerDate = [timeTrigerDayArray objectAtIndex:index];
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = trigerDate; //触发通知的时间
        notification.repeatInterval = 0; //循环次数，kCFCalendarUnitWeekday一周一次

        notification.alertBody = [timeTrigerBriefArray objectAtIndex:index];

        notification.soundName = UILocalNotificationDefaultSoundName;   //通知提示音 使用默认的
        notification.alertAction = NSLocalizedString(@"foregatherDayAction", @"foregatherDayAction");
        notification.applicationIconBadgeNumber = 1; //设置app图标右上角的数字

        //下面设置本地通知发送的消息，这个消息可以接受
        NSDictionary* infoDic = @{@"type":[timeTrigerDayTypeArray objectAtIndex:index],
                                  @"message":[timeTrigerDetailArray objectAtIndex:index]};
        notification.userInfo = infoDic;
        //发送通知
        if ([currentDate earlierDate:trigerDate]) {
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }

    //周年提醒
    NSDate *foregatherDay = [PMSpecialDay specialDateOfType:PMSpecialDayType_ForegatherDay100];
    while (NSOrderedAscending == [foregatherDay compare:currentDate]) {
        foregatherDay = [foregatherDay zb_dateAfterYear:1];
    }
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = foregatherDay; //触发通知的时间
    notification.repeatInterval = NSCalendarUnitYear; //循环次数
    notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"foregatherDayBrief", @"foregatherDayBrief"), (long)([currentDate zb_getYear]-[foregatherDay zb_getYear])];
    notification.soundName = UILocalNotificationDefaultSoundName;   //通知提示音 使用默认的
    notification.alertAction = NSLocalizedString(@"foregatherDayAction", @"foregatherDayAction");
    notification.applicationIconBadgeNumber = 1; //设置app图标右上角的数字
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

//相爱通知
- (void)startLoveNotification
{
    NSArray *timeTrigerDayArray = [NSArray arrayWithObjects:
                                   [PMSpecialDay specialDateOfType:PMSpecialDayType_LoveDay100],
                                   [PMSpecialDay specialDateOfType:PMSpecialDayType_LoveDay1000],
                                   nil];
    NSArray *timeTrigerBriefArray = [NSArray arrayWithObjects:
                                     NSLocalizedString(@"loveDay100Brief", @"loveDay100Brief"),
                                     NSLocalizedString(@"loveDay1000Brief", @"loveDay1000Brief"),
                                     nil];
    NSArray *timeTrigerDayTypeArray = [NSArray arrayWithObjects:
                                       [NSNumber numberWithInteger:PMSpecialDayType_LoveDay100],
                                       [NSNumber numberWithInteger:PMSpecialDayType_LoveDay1000],
                                       nil];
    NSArray *timeTrigerDetailArray = [NSArray arrayWithObjects:
                                      NSLocalizedString(@"loveDay100Detail", @"loveDay100Detail"),
                                      NSLocalizedString(@"loveDay1000Detail", @"loveDay1000Detail"),
                                      nil];
    NSDate *currentDate = [NSDate date];
    for (NSInteger index = 0, count = [timeTrigerDayArray count]; index < count; ++index) {
        NSDate *trigerDate = [timeTrigerDayArray objectAtIndex:index];
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = trigerDate; //触发通知的时间
        notification.repeatInterval = 0; //循环次数，kCFCalendarUnitWeekday一周一次

        notification.alertBody = [timeTrigerBriefArray objectAtIndex:index];

        notification.soundName = UILocalNotificationDefaultSoundName;   //通知提示音 使用默认的
        notification.alertAction = NSLocalizedString(@"loveDayAction", @"loveDayAction");
        notification.applicationIconBadgeNumber = 1; //设置app图标右上角的数字

        //下面设置本地通知发送的消息，这个消息可以接受
        //下面设置本地通知发送的消息，这个消息可以接受
        NSDictionary* infoDic = @{@"type":[timeTrigerDayTypeArray objectAtIndex:index],
                                  @"message":[timeTrigerDetailArray objectAtIndex:index]};
        notification.userInfo = infoDic;
        //发送通知
        if ([currentDate earlierDate:trigerDate]) {
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }

    //周年提醒
    NSDate *foregatherDay = [PMSpecialDay specialDateOfType:PMSpecialDayType_LoveDay];
    while (NSOrderedAscending ==  [foregatherDay compare:currentDate]) {
        foregatherDay = [foregatherDay zb_dateAfterYear:1];
    }
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = foregatherDay; //触发通知的时间
    notification.repeatInterval = NSCalendarUnitYear; //循环次数
    notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"loveDayBrief", @"loveDayBrief"), (long)([currentDate zb_getYear]-[foregatherDay zb_getYear])];
    notification.soundName = UILocalNotificationDefaultSoundName;   //通知提示音 使用默认的
    notification.alertAction = NSLocalizedString(@"loveDayAction", @"loveDayAction");
    notification.applicationIconBadgeNumber = 1; //设置app图标右上角的数字
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}



@end
