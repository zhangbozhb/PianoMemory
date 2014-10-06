//
//  PMLocalServer.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMLocalServer.h"
#import "PMLocalStorage.h"
#import "PMDateUpdte.h"

@interface PMLocalServer ()
@property (nonatomic) PMLocalStorage *localStorage;
@end

@implementation PMLocalServer

+ (instancetype)defaultLocalServer
{
    static PMLocalServer *localServer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localServer = [[PMLocalServer alloc] init];
        localServer.localStorage = [PMLocalStorage defaultLocalStorage];
    });
    return localServer;
}

#pragma clear local db
- (void)clearData
{
    [self.localStorage clearData];
}


#pragma students
- (BOOL)isStudentExist:(PMStudent *)student
{
    return [self.localStorage isStudentExist:student];
}
- (BOOL)saveStudent:(PMStudent*)student
{
    return [self.localStorage storeStudent:student];
}
- (BOOL)deleteStudent:(PMStudent*)student
{
    return [self.localStorage removeStudent:student];
}
- (PMStudent*)queryStudentWithId:(NSString*)studentId
{
    return [self.localStorage getStudentWithId:studentId];
}

- (NSArray *)queryStudents:(NSString*)name phone:(NSString*)phone
{
    NSMutableArray *students = [NSMutableArray array];
    NSDictionary *viewStudent = [self.localStorage viewStudent];
    for (NSString *studentId in viewStudent) {
        PMStudent *student = [self.localStorage getStudentWithId:studentId];
        BOOL isMatch = NO;
        if (studentId) {
            if (0 != [name length] &&
                student.name &&
                NSNotFound != [student.name rangeOfString:name].location) {
                isMatch = YES;
            } else if (0 != [phone length] &&
                student.phone &&
                NSNotFound != [student.phone rangeOfString:phone].location) {
                isMatch = YES;
            } else if (0 ==  [name length]
                       && 0 == [phone length]){
                isMatch = YES;
            }
            if (isMatch) {
                [students addObject:student];
            }
        }
    }
    return students;
}
@end
