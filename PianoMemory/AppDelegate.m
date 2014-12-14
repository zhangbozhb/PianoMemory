//
//  AppDelegate.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "AppDelegate.h"
#import "PMDataManager.h"
#import "PMAnniversaryManager.h"
#import "PMSpecialDay.h"
#import "PMAppConfig.h"

#import "PMBirthDayViewController.h"

@interface AppDelegate ()
@property (nonatomic) UIViewController *mainViewController;
@property (nonatomic) UIViewController *birthDayViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //初始化配置
    [PMAppConfig registerDefautConfig];

    //初始化数据
    [[PMDataManager defaultDataMananger] initDataManager];

    //初始化本地通知
    [[PMAnniversaryManager defaultMananger] startNotification];

    //加载root viewcontroller
    [self updateRootViewController];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)testNotification
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    NSDate *now = [NSDate new];
    notification.fireDate = [now dateByAddingTimeInterval:6]; //触发通知的时间
    notification.repeatInterval = kCFCalendarUnitMinute; //循环次数，kCFCalendarUnitWeekday一周一次

    notification.alertBody=@"顶部提示内容，通知时间到啦";
    //通知提示音 使用默认的
    notification.soundName= UILocalNotificationDefaultSoundName;
    notification.alertAction=NSLocalizedString(@"你锁屏啦，通知时间到啦", nil);

    notification.applicationIconBadgeNumber = 10; //设置app图标右上角的数字

    //下面设置本地通知发送的消息，这个消息可以接受
    NSDictionary* infoDic = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
    notification.userInfo = infoDic;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LocalNotification" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];

    NSDictionary* dic = [[NSDictionary alloc]init];
    //这里可以接受到本地通知中心发送的消息
    dic = notification.userInfo;
    NSLog(@"user info = %@",[dic objectForKey:@"key"]);

    // 图标上的数字减1
    application.applicationIconBadgeNumber -= 1;
}

#pragma view controllers
- (UIViewController *)mainViewController
{
    if (!_mainViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        _mainViewController = [storyboard instantiateInitialViewController];
    }
    return _mainViewController;
}

- (UIViewController *)birthDayViewController
{
    if (!_birthDayViewController) {
        _birthDayViewController = [[PMBirthDayViewController alloc] init];
    }
    return _birthDayViewController;
}

- (void)updateRootViewController
{
    UIViewController *targetViewController = nil;
    PMSpecialDayType specialDay = [PMSpecialDay specialDayTypeOfToday];
    if (PMSpecialDayType_Birthday == specialDay) {
        targetViewController = self.birthDayViewController;
    } else  {
        targetViewController = self.mainViewController;
    }
    if (targetViewController != self.window.rootViewController) {
        [self.window setRootViewController:targetViewController];
    }
}

- (void)switchRootViewControllerToMain
{
    UIViewController *targetViewController = self.mainViewController;
    if (targetViewController != self.window.rootViewController) {
        [self.window setRootViewController:targetViewController];
    }
}
@end
