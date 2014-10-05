//
//  PMLocalStorage.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMLocalStorage.h"

static NSString *const klocal_course_mapping_key = @"org.plam4fun.fm1017.localActivityMappingKey";
static NSString *const klocal_course_view_key = @"org.plam4fun.fm1017.localActivityViewKey";

static NSString *const klocal_article_mapping_key = @"org.plam4fun.fm1017.localArticleMappingKey";
static NSString *const klocal_article_view_key = @"org.plam4fun.fm1017.localArticleViewKey";
static NSString *const klocal_article_etag_key = @"org.plam4fun.fmPMLocalStorage1017.localArticleEtagKey";

@implementation PMLocalStorage

+ (instancetype)defaultLocalStorage
{
    static PMLocalStorage *localStorage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localStorage = [[PMLocalStorage alloc] initWithDBName:@"local.ldb"];
    });
    return localStorage;
}

#pragma encapsulate mapping methods(override)
- (NSString *)mappingKeyOfClass:(Class)objectClass;
{
    if ([objectClass isSubclassOfClass:[PMCourse class]]) {
        return klocal_course_mapping_key;
    }
    return nil;
}

#pragma encapsulate view methods(override)
- (NSString*)viewKeyOfClass:(Class)objectClass;
{
    if ([objectClass isSubclassOfClass:[PMCourse class]]) {
        return klocal_course_view_key;
    }
    return nil;
}

- (BOOL)isStudentExist:(PMStudent *)student
{
    return [self isExistHCObject:student];
}
- (BOOL)saveStudent:(PMStudent*)student
{
    if (!student ||
        [self isStudentExist:student]) {
        return NO;
    }
    return [self storeHCObject:student];
}
- (BOOL)updateStudent:(PMStudent*)student
{
    return [self storeHCObject:student];
}
- (BOOL)deleteStudent:(PMStudent*)student
{
    return [self removeHCObject:student];
}

#pragma course
- (BOOL)saveCourse:(PMCourse *)course
{
    if (!course ||
        [self isExistHCObject:course]) {
        return NO;
    }
    return [self storeHCObject:course];
}
- (BOOL)updateCourse:(PMCourse *)course
{
    return [self storeHCObject:course];
}
- (BOOL)deleteCourse:(PMCourse *)course
{
    return [self removeHCObject:course];
}

#pragma course schedule
- (BOOL)saveCourseSchedule:(PMCourseSchedule*)courseSchedule
{
    if (!courseSchedule ||
        [self isExistHCObject:courseSchedule]) {
        return NO;
    }
    return [self storeHCObject:courseSchedule];
}
- (BOOL)updateCourseSchedule:(PMCourseSchedule*)courseSchedule
{
    return [self storeHCObject:courseSchedule];
}
- (BOOL)deleteCourseSchedule:(PMCourseSchedule*)courseSchedule
{
    return [self removeHCObject:courseSchedule];
}
@end
