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
@end
