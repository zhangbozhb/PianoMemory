//
//  PMDataManager.m
//  PianoMemory
//
//  Created by 张 波 on 14/11/21.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMDataManager.h"
#import "PMLocalServer.h"
#import "NSDate+Extend.h"

static NSInteger kdefaultFillDayCourseScheduleTimeInterval = 60;

@interface PMDataManager ()
@property (nonatomic) PMLocalServer *localServer;
@property (nonatomic) dispatch_queue_t localServerQueue;
@end

@implementation PMDataManager
+ (instancetype)defaultDataMananger
{
    static PMDataManager *dataManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager =  [[PMDataManager alloc] init];
        dataManager.localServer = [PMLocalServer defaultLocalServer];
        dataManager.localServerQueue = dispatch_queue_create("com.traveljoin.localserver-queue", DISPATCH_QUEUE_SERIAL);
    });
    return dataManager;
}

- (void)initDataManager
{
    //后台补充排课信息
    [self startFillDayCourseSchedule];
}

- (void)fillNotExsitDayCourseSchedule
{
    dispatch_async(self.localServerQueue, ^{
        NSInteger endTimestamp = [[[NSDate date] zb_dateAfterDay:1] zb_timestampOfDay];
        [self.localServer fillNotExsitDayCourseSchedulesFrom:endTimestamp];
    });
}

- (void)startFillDayCourseSchedule
{
    NSTimer *fillTimer = [NSTimer scheduledTimerWithTimeInterval:kdefaultFillDayCourseScheduleTimeInterval
                                                          target:self
                                                        selector:@selector(fillNotExsitDayCourseSchedule)
                                                        userInfo:nil
                                                         repeats:YES];
    [fillTimer fire];
}
@end
