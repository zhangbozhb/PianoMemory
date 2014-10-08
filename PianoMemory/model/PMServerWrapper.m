//
//  PMServerWrapper.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMServerWrapper.h"
#import "PMLocalServer.h"
#import "PMDateUpdte.h"
#import "NSDate+Extend.h"

@interface PMServerWrapper ()
@property (nonatomic) PMLocalServer *localServer;
@property (nonatomic) dispatch_queue_t localServerQueue;
@end

@implementation PMServerWrapper
+ (instancetype)defaultServer
{
    static PMServerWrapper *server = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        server = [[PMServerWrapper alloc] init];
        server.localServer = [PMLocalServer defaultLocalServer];
        server.localServerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    });
    return server;
}

- (void)asyncProcessing:(void (^)(void))block
{
    dispatch_async(self.localServerQueue, ^{
        dispatch_async(dispatch_get_main_queue(), block);
    });
}

- (HCErrorMessage *)errorUnknown
{
    HCErrorMessage *error = [[HCErrorMessage alloc] initWithErrorMessage:@"未知错误"];
    return error;
}

- (void)createStudent:(PMStudent*)student success:(void(^)(PMStudent *student))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        BOOL isExist = [self.localServer isStudentExist:student];
        if (isExist) {
            if (failure) {
                HCErrorMessage *error = [[HCErrorMessage alloc] initWithErrorMessage:@"该学生已存在，无法创建"];
                failure(error);
            }
        } else {
            if ([self.localServer saveStudent:student]) {
                if (success) {
                    success(student);
                }
                [PMDateUpdte notificationDataUpated:[PMDateUpdte dateUpdateTypeToString:PMLocalServer_DateUpateType_Student]];
            } else {
                if (failure) {
                    failure([self errorUnknown]);
                }
            }
        }
    }];
}
- (void)updateStudent:(PMStudent*)student success:(void(^)(PMStudent *student))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        BOOL isExist = [self.localServer isStudentExist:student];
        if (!isExist) {
            if (failure) {
                HCErrorMessage *error = [[HCErrorMessage alloc] initWithErrorMessage:@"该学生不存在，无法更新"];
                failure(error);
            }
        } else {
            if ([self.localServer saveStudent:student]) {
                if (success) {
                    success(student);
                }
                [PMDateUpdte notificationDataUpated:[PMDateUpdte dateUpdateTypeToString:PMLocalServer_DateUpateType_Student]];
            } else {
                if (failure) {
                    failure([self errorUnknown]);
                }
            }
        }
    }];
}
- (void)deleteStudent:(PMStudent*)student success:(void(^)(PMStudent *student))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        BOOL isExist = [self.localServer isStudentExist:student];
        if (!isExist) {
            if (failure) {
                HCErrorMessage *error = [[HCErrorMessage alloc] initWithErrorMessage:@"该学生不存在，无法删除"];
                failure(error);
            }
        } else {
            if ([self.localServer deleteStudent:student]) {
                if (success) {
                    success(student);
                }
                [PMDateUpdte notificationDataUpated:[PMDateUpdte dateUpdateTypeToString:PMLocalServer_DateUpateType_Student]];
            } else {
                if (failure) {
                    failure([self errorUnknown]);
                }
            }
        }
    }];
}

- (void)queryStudents:(NSDictionary *)parameters success:(void(^)(NSArray *array))success failure:(void(^)(HCErrorMessage *error))failure
{
    NSString *phone = [parameters objectForKey:@"phone"];
    NSString *name = [parameters objectForKey:@"name"];
    NSString *nameShortcut = [parameters objectForKey:@"nameShortcut"];
    [self asyncProcessing:^{
        NSArray *array = [self.localServer queryStudents:name phone:phone nameShortcut:nameShortcut];
        if (success) {
            success(array);
        }
    }];
}

#pragma course
- (void)createCourse:(PMCourse*)course success:(void(^)(PMCourse *course))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        if ([self.localServer saveCourse:course]) {
            if (success) {
                success(course);
            }
            [PMDateUpdte notificationDataUpated:[PMDateUpdte dateUpdateTypeToString:PMLocalServer_DateUpateType_Course]];
        } else {
            if (failure) {
                failure([self errorUnknown]);
            }
        }
    }];
}

- (void)updateCourse:(PMCourse*)course success:(void(^)(PMCourse *course))success failure:(void(^)(HCErrorMessage *error))failure
{
    if ([self.localServer saveCourse:course]) {
        if (success) {
            success(course);
        }
        [PMDateUpdte notificationDataUpated:[PMDateUpdte dateUpdateTypeToString:PMLocalServer_DateUpateType_Course]];
    } else {
        if (failure) {
            failure([self errorUnknown]);
        }
    }
}

- (void)deleteCourse:(PMCourse*)course success:(void(^)(PMCourse *course))success failure:(void(^)(HCErrorMessage *error))failure
{
    if ([self.localServer deleteCourse:course]) {
        if (success) {
            success(course);
        }
        [PMDateUpdte notificationDataUpated:[PMDateUpdte dateUpdateTypeToString:PMLocalServer_DateUpateType_Course]];
    } else {
        if (failure) {
            failure([self errorUnknown]);
        }
    }
}

- (void)queryCourses:(NSDictionary *)parameters success:(void(^)(NSArray *array))success failure:(void(^)(HCErrorMessage *error))failure
{
    NSString *name = [parameters objectForKey:@"name"];
    [self asyncProcessing:^{
        NSArray *array = [self.localServer queryCourses:name];
        if (success) {
            success(array);
        }
    }];
}

- (NSArray*)queryCoursesWithAccurateName:(NSString*)name
{
    return [self.localServer queryCoursesWithAccurateName:name];
}

#pragma dayCourseSchedule
- (void)createDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule success:(void(^)(PMDayCourseSchedule *dayCourseSchedule))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        if ([self.localServer saveDayCourseSchedule:dayCourseSchedule]) {
            if (success) {
                success(dayCourseSchedule);
            }
            [PMDateUpdte notificationDataUpated:[PMDateUpdte dateUpdateTypeToString:PMLocalServer_DateUpateType_DayCourseSchedule]];
        } else {
            if (failure) {
                failure([self errorUnknown]);
            }
        }
    }];
}

- (void)updateDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule success:(void(^)(PMDayCourseSchedule *dayCourseSchedule))success failure:(void(^)(HCErrorMessage *error))failure
{
    if ([self.localServer deleteDayCourseSchedule:dayCourseSchedule]) {
        if (success) {
            success(dayCourseSchedule);
        }
        [PMDateUpdte notificationDataUpated:[PMDateUpdte dateUpdateTypeToString:PMLocalServer_DateUpateType_DayCourseSchedule]];
    } else {
        if (failure) {
            failure([self errorUnknown]);
        }
    }
}
- (void)deleteDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule success:(void(^)(PMDayCourseSchedule *dayCourseSchedule))success failure:(void(^)(HCErrorMessage *error))failure
{
    if ([self.localServer deleteDayCourseSchedule:dayCourseSchedule]) {
        if (success) {
            success(dayCourseSchedule);
        }
        [PMDateUpdte notificationDataUpated:[PMDateUpdte dateUpdateTypeToString:PMLocalServer_DateUpateType_DayCourseSchedule]];
    } else {
        if (failure) {
            failure([self errorUnknown]);
        }
    }
}
//param 	starttime, endtime
- (void)queryDayCourseSchedules:(NSDictionary *)parameters success:(void(^)(NSArray *array))success failure:(void(^)(HCErrorMessage *error))failure
{
    NSString *starttimeString = [parameters objectForKey:@"starttime"];
    NSString *endtimeString = [parameters objectForKey:@"endtime"];

    NSInteger starttime = 0;
    NSInteger endtime = NSIntegerMax;
    if (starttimeString) {
        starttime = [starttimeString integerValue];
    }
    if (endtimeString) {
        endtime = [endtimeString integerValue];
    }
    if (starttime >= endtime) {
        endtime = [[[NSDate dateWithTimeIntervalSince1970:starttime] zb_dateAfterDay:1] zb_getDayTimestamp]-1;
    }
    [self asyncProcessing:^{
        NSArray *array = [self.localServer queryDayCourseSchedulesFrom:starttime toEndTime:endtime];
        if (success) {
            success(array);
        }
    }];
}
- (void)queryDayCourseScheduleOfDate:(NSDate*)date success:(void(^)(PMDayCourseSchedule *dayCourseSchedule))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        NSDate *targetDate = date;
        if (!targetDate) {
            targetDate = [NSDate date];
        }
        PMDayCourseSchedule *dayCourseSchedule = [self.localServer queryDayCourseScheduleOfDate:targetDate];
        if (success) {
            success(dayCourseSchedule);
        }
    }];
}
@end
