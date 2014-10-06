//
//  PMLocalStorage.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "FMSyncStorage.h"
#import "PMLocalStorage.h"

static NSString *const klocal_student_mapping_key = @"org.plam4fun.fm1017.localStudentMappingKey";
static NSString *const klocal_student_view_key = @"org.plam4fun.fm1017.localStudentViewKey";

static NSString *const klocal_course_mapping_key = @"org.plam4fun.fm1017.localCourseMappingKey";
static NSString *const klocal_course_view_key = @"org.plam4fun.fm1017.localCourseViewKey";

static NSString *const klocal_courseschedule_mapping_key = @"org.plam4fun.fm1017.localCourseScheduleyMappingKey";
static NSString *const klocal_courseschedule_view_key = @"org.plam4fun.fm1017.localCourseScheduleViewKey";


@interface PMLocalStorage () <FMSyncStorageDelate>
@property (nonatomic) FMSyncStorage *syncStorage;
@end

@implementation PMLocalStorage

+ (instancetype)defaultLocalStorage
{
    static PMLocalStorage *localStorage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localStorage =  [[PMLocalStorage alloc] init];
        localStorage.syncStorage = [[FMSyncStorage alloc] initWithDBName:@"local.ldb"];
        [localStorage.syncStorage setStoreDelgate:localStorage];
    });
    return localStorage;
}

#pragma delegate FMSyncStorageDelate
- (NSString *)mappingKeyOfClass:(Class)objectClass;
{
    if ([objectClass isSubclassOfClass:[PMStudent class]]) {
        return klocal_student_mapping_key;
    } else if ([objectClass isSubclassOfClass:[PMCourse class]]) {
        return klocal_course_mapping_key;
    } else if ([objectClass isSubclassOfClass:[PMCourseSchedule class]]) {
        return klocal_courseschedule_mapping_key;
    }
    return nil;
}
- (NSString*)viewKeyOfClass:(Class)objectClass;
{
    if ([objectClass isSubclassOfClass:[PMStudent class]]) {
        return klocal_student_view_key;
    } else if ([objectClass isSubclassOfClass:[PMCourse class]]) {
        return klocal_course_view_key;
    } else if ([objectClass isSubclassOfClass:[PMCourseSchedule class]]) {
        return klocal_courseschedule_view_key;
    }
    return nil;
}

- (void)clearData
{
    [self.syncStorage clearData];
}

#pragma conveniece method
- (BOOL)isStudentExist:(PMStudent *)student
{
    return [self.syncStorage isExistHCObject:student];
}
- (BOOL)storeStudent:(PMStudent*)student
{
    return [self.syncStorage storeHCObject:student];
}
- (BOOL)removeStudent:(PMStudent*)student
{
    return [self.syncStorage removeHCObject:student];
}
- (PMStudent*)getStudentWithId:(NSString*)studentId
{
    return (PMStudent *)[self.syncStorage objectForKey:studentId];
}
- (NSDictionary *)viewStudent
{
    return [self.syncStorage viewOfClass:[PMStudent class]];
}

#pragma course
- (BOOL)storeCourse:(PMCourse *)course
{
    return [self.syncStorage storeHCObject:course];
}
- (BOOL)removeCourse:(PMCourse *)course
{
    return [self.syncStorage removeHCObject:course];
}

#pragma course schedule
- (BOOL)storeCourseSchedule:(PMCourseSchedule*)courseSchedule
{
    return [self.syncStorage storeHCObject:courseSchedule];
}
- (BOOL)removeCourseSchedule:(PMCourseSchedule*)courseSchedule
{
    return [self.syncStorage removeHCObject:courseSchedule];
}
@end
