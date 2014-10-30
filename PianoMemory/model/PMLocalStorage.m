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

static NSString *const klocal_timeschedule_mapping_key = @"org.plam4fun.fm1017.localTimeScheduleyMappingKey";
static NSString *const klocal_timeschedule_view_key = @"org.plam4fun.fm1017.localTimeScheduleViewKey";

static NSString *const klocal_courseschedule_mapping_key = @"org.plam4fun.fm1017.localCourseScheduleyMappingKey";
static NSString *const klocal_courseschedule_view_key = @"org.plam4fun.fm1017.localCourseScheduleViewKey";


static NSString *const klocal_daycourseschedule_mapping_key = @"org.plam4fun.fm1017.localDayCourseScheduleyMappingKey";
static NSString *const klocal_daycourseschedule_view_key = @"org.plam4fun.fm1017.localDayCourseScheduleViewKey";

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
    } else if ([objectClass isSubclassOfClass:[PMTimeSchedule class]]) {
        return klocal_timeschedule_mapping_key;
    } else if ([objectClass isSubclassOfClass:[PMCourseSchedule class]]) {
        return klocal_courseschedule_mapping_key;
    } else if ([objectClass isSubclassOfClass:[PMDayCourseSchedule class]]) {
        return klocal_daycourseschedule_mapping_key;
    }
    return nil;
}
- (NSString*)viewKeyOfClass:(Class)objectClass;
{
    if ([objectClass isSubclassOfClass:[PMStudent class]]) {
        return klocal_student_view_key;
    } else if ([objectClass isSubclassOfClass:[PMCourse class]]) {
        return klocal_course_view_key;
    } else if ([objectClass isSubclassOfClass:[PMTimeSchedule class]]) {
        return klocal_timeschedule_view_key;
    } else if ([objectClass isSubclassOfClass:[PMCourseSchedule class]]) {
        return klocal_courseschedule_view_key;
    } else if ([objectClass isSubclassOfClass:[PMDayCourseSchedule class]]) {
        return klocal_daycourseschedule_view_key;
    }
    return nil;
}
- (NSObject *)viewValueInViewOfHCObject:(HCObject *)object
{
    if ([object isKindOfClass:[PMStudent class]]) {
        PMStudent *student = (PMStudent*)object;
        NSString *name = student.name?student.name:@"";
        NSString *phone = student.phone?student.phone:@"";
        NSString *shortCut = student.nameShortcut?student.nameShortcut:@"";
        return [NSString stringWithFormat:@"%@|%@|%@", name, phone, shortCut];
    } else if ([object isKindOfClass:[PMDayCourseSchedule class]]) {
        PMDayCourseSchedule *dayCourseSchedule = (PMDayCourseSchedule*)object;
        return [[NSNumber numberWithLong:dayCourseSchedule.scheduleTimestamp] stringValue];
    }
    return @"";
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
- (PMCourse*)getCourseWithId:(NSString*)courseId
{
    return (PMCourse*)[self.syncStorage objectForKey:courseId];
}
- (NSDictionary *)viewCourse
{
    return [self.syncStorage viewOfClass:[PMCourse class]];
}

#pragma time schedule
- (BOOL)storeTimeSchedule:(PMTimeSchedule*)timeSchedule
{
    return [self.syncStorage storeHCObject:timeSchedule];
}
- (BOOL)removeTimeSchedule:(PMTimeSchedule*)timeSchedule
{
    return [self.syncStorage removeHCObject:timeSchedule];
}
- (PMTimeSchedule*)getTimeScheduleeWithId:(NSString*)timeScheduleId
{
    return (PMTimeSchedule*)[self.syncStorage objectForKey:timeScheduleId];
}
- (NSDictionary *)viewTimeSchedule
{
    return [self.syncStorage viewOfClass:[PMTimeSchedule class]];
}

#pragma course schedule
- (BOOL)storeCourseSchedule:(PMCourseSchedule*)courseSchedule
{
    //直接存放，这里存放的是冗余信息，所以在读取的时候，需要更新最新信息
    //好处在于:外部依赖的东东可是随时删除，不影响已经的东东
    return [self.syncStorage storeHCObject:courseSchedule];
}
- (BOOL)removeCourseSchedule:(PMCourseSchedule*)courseSchedule
{
    return [self.syncStorage removeHCObject:courseSchedule];
}
- (PMCourseSchedule*)getCourseScheduleWithId:(NSString*)courseScheduleId
{
    PMCourseSchedule *courseSchedule = (PMCourseSchedule*)[self.syncStorage objectForKey:courseScheduleId];
    //获取最新的 course 信息
    if (courseSchedule.course) {
        PMCourse *latestCourse = [self getCourseWithId:courseSchedule.course.localDBId];
        if (latestCourse) {
            courseSchedule.course = latestCourse;
        }
    }
    //获取 student 最新消息
    NSMutableArray *latestStudents = [NSMutableArray array];
    for (PMStudent *student in courseSchedule.students) {
        PMStudent *latestStudent = [self getStudentWithId:student.localDBId];
        if (latestStudent) {
            [latestStudents addObject:latestStudent];
        } else {
            [latestStudents addObject:student];
        }
    }
    courseSchedule.students = latestStudents;
    return courseSchedule;
}
- (NSDictionary *)viewCourseSchedule
{
    return [self.syncStorage viewOfClass:[PMCourseSchedule class]];
}


#pragma day course schedule
- (BOOL)storeDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule
{
    if (!dayCourseSchedule) {
        return NO;
    }
    for (PMCourseSchedule *courseSchedule in dayCourseSchedule.courseSchedules) {
        [self storeCourseSchedule:courseSchedule];
    }
    return [self.syncStorage storeHCObject:dayCourseSchedule];
}
- (BOOL)removeDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule
{
    for (PMCourseSchedule *courseSchedule in dayCourseSchedule.courseSchedules) {
        [self removeCourseSchedule:courseSchedule];
    }
    return [self.syncStorage removeHCObject:dayCourseSchedule];
}
- (PMDayCourseSchedule*)getDayCourseScheduleWithId:(NSString*)dayCourseScheduleId
{
    PMDayCourseSchedule *dayCourseSchedule = (PMDayCourseSchedule*)[self.syncStorage objectForKey:dayCourseScheduleId];
    if (dayCourseSchedule) {
        NSMutableArray *latestCourseSchedules = [NSMutableArray array];
        //加载最新的课程信息
        for (PMCourseSchedule *courseSchedule in dayCourseSchedule.courseSchedules) {
            PMCourseSchedule *latestCourseSchedule = [self getCourseScheduleWithId:courseSchedule.localDBId];
            if (latestCourseSchedule) {
                [latestCourseSchedules addObject:latestCourseSchedule];
            } else {
                [latestCourseSchedules addObject:courseSchedule];
            }
        }
        dayCourseSchedule.courseSchedules = latestCourseSchedules;
    }
    return dayCourseSchedule;
}
- (NSDictionary *)viewDayCourseSchedule
{
    return [self.syncStorage viewOfClass:[PMDayCourseSchedule class]];
}
@end
