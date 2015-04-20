//
//  PMServerWrapper.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMServerWrapper.h"
#import "PMLocalServer.h"
#import "PMDataUpdate.h"
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
        server.localServerQueue = dispatch_queue_create("com.zhangbo.pianomemory", DISPATCH_QUEUE_CONCURRENT);
    });
    return server;
}

- (void)asyncProcessing:(void (^)(void))block
{
    dispatch_async(self.localServerQueue, ^{
        block();
    });
}
//
//- (void)asynProcessingOnMainQueue:(void (^)(void))block
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        block();
//    });
//}

- (HCErrorMessage *)errorUnknown
{
    HCErrorMessage *error = [[HCErrorMessage alloc] initWithErrorMessage:@"未知错误"];
    return error;
}

- (void)createStudent:(PMStudent*)student success:(void(^)(PMStudent *student))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        BOOL isExist = [self.localServer isStudentExist:student] || [self.localServer isStudentWithPhoneExist:student.phone];
        if (isExist) {
            if (failure) {
                HCErrorMessage *error = [[HCErrorMessage alloc] initWithErrorMessage:@"该学生已存在，无法创建"];
                failure(error);
            }
        } else {
            BOOL isSucceed = [self.localServer saveStudent:student];
            if (isSucceed) {
                if (success) {
                    success(student);
                }
                [PMDataUpdate notificationDataUpated:[PMDataUpdate dataUpdateTypeToString:PMLocalServer_DataUpateType_Student]];
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
            BOOL isSucceed = [self.localServer saveStudent:student];
            if (isSucceed) {
                if (success) {
                    success(student);
                }
                [PMDataUpdate notificationDataUpated:[PMDataUpdate dataUpdateTypeToString:PMLocalServer_DataUpateType_Student]];
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
            BOOL isSucceed = [self.localServer deleteStudent:student];
            if (isSucceed) {
                if (success) {
                    success(student);
                }
                [PMDataUpdate notificationDataUpated:[PMDataUpdate dataUpdateTypeToString:PMLocalServer_DataUpateType_Student]];
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
        BOOL isSucceed = [self.localServer saveCourse:course];
        if (isSucceed) {
            if (success) {
                success(course);
            }
            [PMDataUpdate notificationDataUpated:[PMDataUpdate dataUpdateTypeToString:PMLocalServer_DataUpateType_Course]];
        } else {
            if (failure) {
                failure([self errorUnknown]);
            }
        }
    }];
}

- (void)updateCourse:(PMCourse*)course success:(void(^)(PMCourse *course))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        BOOL isSucceed = [self.localServer saveCourse:course];
        if (isSucceed) {
            if (success) {
                success(course);
            }
            [PMDataUpdate notificationDataUpated:[PMDataUpdate dataUpdateTypeToString:PMLocalServer_DataUpateType_Course]];
        } else {
            if (failure) {
                failure([self errorUnknown]);
            }
        }
    }];
}
- (void)deleteCourse:(PMCourse*)course success:(void(^)(PMCourse *course))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        BOOL isSucceed = [self.localServer deleteCourse:course];
        if (isSucceed) {
            if (success) {
                success(course);
            }
            [PMDataUpdate notificationDataUpated:[PMDataUpdate dataUpdateTypeToString:PMLocalServer_DataUpateType_Course]];
        } else {
            if (failure) {
                failure([self errorUnknown]);
            }
        }
    }];
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

#pragma timeSchedule
- (void)createTimeSchedule:(PMTimeSchedule*)timeSchedule success:(void(^)(PMTimeSchedule *timeSchedule))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        BOOL isSucceed = [self.localServer saveTimeSchedule:timeSchedule];
        if (isSucceed) {
            if (success) {
                success(timeSchedule);
            }
            [PMDataUpdate notificationDataUpated:[PMDataUpdate dataUpdateTypeToString:PMLocalServer_DataUpateType_TimeSchedule]];
        } else {
            if (failure) {
                failure([self errorUnknown]);
            }
        }
    }];
}
- (void)updateTimeSchedule:(PMTimeSchedule*)timeSchedule success:(void(^)(PMTimeSchedule *timeSchedule))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        BOOL isSucceed = [self.localServer saveTimeSchedule:timeSchedule];
        if (isSucceed) {
            if (success) {
                success(timeSchedule);
            }
            [PMDataUpdate notificationDataUpated:[PMDataUpdate dataUpdateTypeToString:PMLocalServer_DataUpateType_TimeSchedule]];
        } else {
            if (failure) {
                failure([self errorUnknown]);
            }
        }
    }];
}
- (void)deleteTimeSchedule:(PMTimeSchedule*)timeSchedule success:(void(^)(PMTimeSchedule *timeSchedule))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        BOOL isSucceed = [self.localServer deleteTimeSchedule:timeSchedule];
        if (isSucceed) {
            if (success) {
                success(timeSchedule);
            }
            [PMDataUpdate notificationDataUpated:[PMDataUpdate dataUpdateTypeToString:PMLocalServer_DataUpateType_TimeSchedule]];
        } else {
            if (failure) {
                failure([self errorUnknown]);
            }
        }
    }];
}
- (void)queryAllTimeSchedules:(void(^)(NSArray *array))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        NSArray *array = [self.localServer queryAllTimeSchedule];
        if (success) {
            success(array);
        }    }];
}


#pragma courseSchedule
- (void)createCourseSchedule:(PMCourseSchedule*)courseSchedule success:(void(^)(PMCourseSchedule *courseSchedule))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        BOOL isSucceed = [self.localServer saveCourseSchedule:courseSchedule];
        if (isSucceed) {
            if (success) {
                success(courseSchedule);
            }
            [PMDataUpdate notificationDataUpated:[PMDataUpdate dataUpdateTypeToString:PMLocalServer_DataUpateType_CourseSchedule]];
        } else {
            if (failure) {
                failure([self errorUnknown]);
            }
        }
    }];
}
- (void)updateCourseSchedule:(PMCourseSchedule*)courseSchedule success:(void(^)(PMCourseSchedule *courseSchedule))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        BOOL isSucceed = [self.localServer saveCourseSchedule:courseSchedule];
        if (isSucceed) {
            if (success) {
                success(courseSchedule);
            }
            [PMDataUpdate notificationDataUpated:[PMDataUpdate dataUpdateTypeToString:PMLocalServer_DataUpateType_CourseSchedule]];
        } else {
            if (failure) {
                failure([self errorUnknown]);
            }
        }
    }];
}
- (void)deleteCourseSchedule:(PMCourseSchedule*)courseSchedule success:(void(^)(PMCourseSchedule *courseSchedule))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        BOOL isSucceed = [self.localServer deleteCourseSchedule:courseSchedule];
        if (isSucceed) {
            if (success) {
                success(courseSchedule);
            }
            [PMDataUpdate notificationDataUpated:[PMDataUpdate dataUpdateTypeToString:PMLocalServer_DataUpateType_CourseSchedule]];
        } else {
            if (failure) {
                failure([self errorUnknown]);
            }
        }
    }];
}
- (void)queryAllCourseSchedules:(void(^)(NSArray *array))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        NSArray *array = [self.localServer queryAllCourseSchedule];
        if (success) {
            success(array);
        }
    }];
}
- (void)queryCourseScheduleOfDate:(NSDate*)date success:(void(^)(NSArray *array))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        NSArray *array = [self.localServer queryCourseScheduleOfDate:date];
        if (success) {
            success(array);
        }
    }];
}

#pragma dayCourseSchedule
- (void)createDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule success:(void(^)(PMDayCourseSchedule *dayCourseSchedule))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        BOOL isSucceed = [self.localServer saveDayCourseSchedule:dayCourseSchedule];
        if (isSucceed) {
            if (success) {
                success(dayCourseSchedule);
            }
            [PMDataUpdate notificationDataUpated:[PMDataUpdate dataUpdateTypeToString:PMLocalServer_DataUpateType_DayCourseSchedule]];
        } else {
            if (failure) {
                failure([self errorUnknown]);
            }
        }
    }];
}
- (void)updateDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule success:(void(^)(PMDayCourseSchedule *dayCourseSchedule))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        BOOL isSucceed = [self.localServer saveDayCourseSchedule:dayCourseSchedule];
        if (isSucceed) {
            if (success) {
                success(dayCourseSchedule);
            }
            [PMDataUpdate notificationDataUpated:[PMDataUpdate dataUpdateTypeToString:PMLocalServer_DataUpateType_DayCourseSchedule]];
        } else {
            if (failure) {
                failure([self errorUnknown]);
            }
        }
    }];
}
- (void)deleteDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule success:(void(^)(PMDayCourseSchedule *dayCourseSchedule))success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        BOOL isSucceed = [self.localServer deleteDayCourseSchedule:dayCourseSchedule];
        if (isSucceed) {
            if (success) {
                success(dayCourseSchedule);
            }
            [PMDataUpdate notificationDataUpated:[PMDataUpdate dataUpdateTypeToString:PMLocalServer_DataUpateType_DayCourseSchedule]];
        } else {
            if (failure) {
                failure([self errorUnknown]);
            }
        }
    }];
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
        endtime = [[[NSDate dateWithTimeIntervalSince1970:starttime] zb_dateAfterDay:1] zb_timestampOfBeginDay];
    }

    [self asyncProcessing:^{
        NSArray *array = [self.localServer queryDayCourseSchedulesFrom:starttime toEndTime:endtime fillNotExist:YES];
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

        NSInteger startTime = [targetDate zb_timestampOfBeginDay];
        NSInteger endTime = [[targetDate zb_dateAfterDay:1] zb_timestampOfBeginDay];
        NSArray *dayCourseScheduleArray = [self.localServer queryDayCourseSchedulesFrom:startTime toEndTime:endTime fillNotExist:YES];
        if (success) {
            success([dayCourseScheduleArray firstObject]);
        }
    }];
}

- (void)updateHistoryDayCourseScheduleWithCourseSchedule:(PMCourseSchedule*)courseSchedule success:(void(^)())success failure:(void(^)(HCErrorMessage *error))failure
{
    [self asyncProcessing:^{
        BOOL isSucceed = [self.localServer updateHistoryDayCourseScheduleWithCourseSchedule:courseSchedule];
        if (isSucceed) {
            if (success) {
                success();
            }
        } else {
            if (failure) {
                failure([self errorUnknown]);
            }
        }
    }];
}
@end
