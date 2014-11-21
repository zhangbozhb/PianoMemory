//
//  PMLocalServer.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMLocalServer.h"
#import "PMLocalStorage.h"
#import "NSDate+Extend.h"
#import "PMBusiness.h"

@interface PMLocalServerCache : NSObject
@property (nonatomic) NSMutableDictionary  *weekDayCourseScheduleMapping;
@property (nonatomic) NSTimeInterval lastUpdateTimestamp;
@property (nonatomic) NSTimeInterval lifeTimestamp;
+ (instancetype)sharedCache;
- (void)updateWeekDayCourseScheduleMapping:(NSArray*)courseSchedules;
@end
@implementation PMLocalServerCache

+ (instancetype)sharedCache
{
    static PMLocalServerCache *sharedCache = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedCache = [[PMLocalServerCache alloc] init];
        sharedCache.lifeTimestamp = 60 * 5;
    });
    return sharedCache;
}

- (NSMutableDictionary *)weekDayCourseScheduleMapping
{
    NSMutableDictionary *targetMapping = nil;
    if (_weekDayCourseScheduleMapping) {
        NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
        if (self.lastUpdateTimestamp + self.lifeTimestamp < currentTimestamp) {
            targetMapping = nil;
        } else {
            targetMapping = _weekDayCourseScheduleMapping;
        }
    }
    return targetMapping;
}

- (void)updateWeekDayCourseScheduleMapping:(NSArray*)courseSchedules
{
    NSMutableDictionary *repreatWeekDayMapping = [NSMutableDictionary dictionary];
    for (PMCourseSchedule *courseSchdeudle in courseSchedules) {
        if (PMCourseScheduleRepeatTypeWeek == courseSchdeudle.repeatType) {
            NSArray *weekDays = [NSArray arrayWithObjects:
                                 [NSNumber numberWithLong:PMCourseScheduleRepeatDataWeekDaySunday],
                                 [NSNumber numberWithLong:PMCourseScheduleRepeatDataWeekDayMonday],
                                 [NSNumber numberWithLong:PMCourseScheduleRepeatDataWeekDayTuesday],
                                 [NSNumber numberWithLong:PMCourseScheduleRepeatDataWeekDayWednesday],
                                 [NSNumber numberWithLong:PMCourseScheduleRepeatDataWeekDayThursday],
                                 [NSNumber numberWithLong:PMCourseScheduleRepeatDataWeekDayFriday],
                                 [NSNumber numberWithLong:PMCourseScheduleRepeatDataWeekDayStaturday],
                                 nil];
            for (NSNumber *mappingKey in weekDays) {
                if ([courseSchdeudle availableForRepeatWeekDay:PMCourseScheduleRepeatDataWeekDaySunday]) {
                    NSMutableArray *weekDayScheudles = [repreatWeekDayMapping objectForKey:mappingKey];
                    if (weekDayScheudles) {
                        [weekDayScheudles addObject:courseSchdeudle];
                    } else {
                        weekDayScheudles = [NSMutableArray arrayWithObject:courseSchdeudle];
                    }
                }
            }
        }
    }
    _lastUpdateTimestamp = [[NSDate date] timeIntervalSince1970];
    _weekDayCourseScheduleMapping = repreatWeekDayMapping;
}
@end

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
- (BOOL)isStudentWithPhoneExist:(NSString*)phone
{
    BOOL isExist = NO;
    if (0 < phone.length) {
        NSDictionary *viewStudent = [self.localStorage viewStudent];
        for (NSString *studentId in viewStudent) {
            NSString *studentViewValue = [viewStudent objectForKey:studentId];
            if (NSNotFound != [studentViewValue rangeOfString:phone].location) {
                PMStudent *student = [self.localStorage getStudentWithId:studentId];
                if ([phone isEqualToString:student.phone]) {
                    isExist = YES;
                    break;
                }
            }
        }
    }
    return isExist;
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

- (NSArray *)queryStudents:(NSString*)name phone:(NSString*)phone nameShortcut:(NSString *)nameShortcut
{
    NSMutableArray *fastMatchTextArray = [NSMutableArray array];
    if (0 < name.length) {
        [fastMatchTextArray addObject:[name lowercaseString]];
    } else if (0 < phone.length) {
        [fastMatchTextArray addObject:[phone lowercaseString]];
    } else if (0 < nameShortcut.length) {
        [fastMatchTextArray addObject:[nameShortcut lowercaseString]];
    }
    BOOL fetchAll = (0 == [fastMatchTextArray count])?YES:NO;
    NSMutableArray *students = [NSMutableArray array];
    NSDictionary *viewStudent = [self.localStorage viewStudent];
    for (NSString *studentId in viewStudent) {
        if (fetchAll) {
            PMStudent *student = [self.localStorage getStudentWithId:studentId];
            if (student) {
                [students addObject:student];
            }
        } else {
            NSString *studentViewValue = [[viewStudent objectForKey:studentId] lowercaseString];
            //先在 studentViewValue快速查找
            BOOL fastMatch = NO;
            for (NSString *fastMetchText in fastMatchTextArray) {
                if (NSNotFound != [studentViewValue rangeOfString:fastMetchText].location) {
                    fastMatch = YES;
                    break;
                }
            }

            if (fastMatch) {
                PMStudent *student = [self.localStorage getStudentWithId:studentId];
                BOOL isMatch = NO;
                if (student) {
                    if (0 != [name length] &&
                        student.name &&
                        NSNotFound != [[student.name lowercaseString] rangeOfString:[name lowercaseString]].location) {
                        isMatch = YES;
                    } else if (0 != [phone length] &&
                               student.phone &&
                               NSNotFound != [student.phone rangeOfString:phone].location) {
                        isMatch = YES;
                    } else if (0 != [nameShortcut length] &&
                               student.nameShortcut &&
                               NSNotFound != [[student.nameShortcut lowercaseString] rangeOfString:[nameShortcut lowercaseString]].location) {
                        isMatch = YES;
                    }
                    if (isMatch) {
                        [students addObject:student];
                    }
                }
            }
        }
    }
    return students;
}

#pragma course
- (BOOL)saveCourse:(PMCourse*)course
{
    return [self.localStorage storeCourse:course];
}
- (BOOL)deleteCourse:(PMCourse*)course
{
    return [self.localStorage removeCourse:course];
}
- (PMCourse*)queryCourseWithId:(NSString*)courseId
{
    return [self.localStorage getCourseWithId:courseId];
}
- (NSArray*)queryCourses:(NSString*)name
{
    NSMutableArray *courses = [NSMutableArray array];
    NSDictionary *viewCourse = [self.localStorage viewCourse];
    for (NSString *courseId in viewCourse) {
        PMCourse *course = [self.localStorage getCourseWithId:courseId];
        if (course) {
            if (0 == [name length] ||
                NSNotFound != [course.name rangeOfString:name].location) {
                [courses addObject:course];
            }
        }
    }
    return courses;
}
- (NSArray*)queryCoursesWithAccurateName:(NSString*)name
{
    NSMutableArray *courses = [NSMutableArray array];
    NSDictionary *viewCourse = [self.localStorage viewCourse];
    for (NSString *courseId in viewCourse) {
        PMCourse *course = [self.localStorage getCourseWithId:courseId];
        if (course) {
            if (0 != [name length] ||
                [name isEqualToString:course.name]) {
                [courses addObject:course];
            }
        }
    }
    return courses;
}

#pragma timeSchedule
- (BOOL)saveTimeSchedule:(PMTimeSchedule*)timeSchedule
{
    return [self.localStorage storeTimeSchedule:timeSchedule];
}
- (BOOL)deleteTimeSchedule:(PMTimeSchedule*)timeSchedule
{
    return [self.localStorage removeTimeSchedule:timeSchedule];
}
- (PMTimeSchedule*)queryTimeScheduleWithId:(NSString*)timeScheduleId
{
    return [self.localStorage getTimeScheduleeWithId:timeScheduleId];
}
- (NSArray*)queryAllTimeSchedule
{
    NSMutableArray *timeSchedules = [NSMutableArray array];
    NSDictionary *viewTimeSchedule = [self.localStorage viewTimeSchedule];
    for (NSString *timeScheudleId in viewTimeSchedule) {
        PMTimeSchedule *timeSchedule = [self.localStorage getTimeScheduleeWithId:timeScheudleId];
        [timeSchedules addObject:timeSchedule];
    }
    return timeSchedules;
}

#pragma courseSchedule
- (BOOL)saveCourseSchedule:(PMCourseSchedule*)courseSchedule
{
    return [self.localStorage storeCourseSchedule:courseSchedule];
}
- (BOOL)deleteCourseSchedule:(PMCourseSchedule*)courseSchedule
{
    return [self.localStorage removeCourseSchedule:courseSchedule];
}
- (PMCourseSchedule*)queryCourseScheduleWithId:(NSString*)courseScheduleId
{
    return [self.localStorage getCourseScheduleWithId:courseScheduleId];
}
- (NSArray*)queryAllCourseSchedule
{
    NSMutableArray *courseSchedules = [NSMutableArray array];
    NSDictionary *viewCourseSchedule = [self.localStorage viewCourseSchedule];
    for (NSString *courseScheduleId in viewCourseSchedule) {
        PMCourseSchedule *courseSchedule = [self.localStorage getCourseScheduleWithId:courseScheduleId];
        if (courseSchedule) {
            [courseSchedules addObject:courseSchedule];
        }
    }
    return courseSchedules;
}
- (NSDictionary *)queryCourseScheduleMapingOfRepeatWeekDay:(NSInteger)startTime endTime:(NSInteger)endTime
{
    NSArray *allCourseSchedules = [self queryAllCourseSchedule];
    NSMutableDictionary *repreatWeekDayMapping = [NSMutableDictionary dictionary];
    for (PMCourseSchedule *courseSchdeudle in allCourseSchedules) {
        if (PMCourseScheduleRepeatTypeWeek == courseSchdeudle.repeatType
            && startTime <= courseSchdeudle.expireDateTimestamp
            && endTime > courseSchdeudle.effectiveDateTimestamp) {
            NSArray *weekDays = [NSArray arrayWithObjects:
                                 [NSNumber numberWithInteger:PMCourseScheduleRepeatDataWeekDaySunday],
                                 [NSNumber numberWithInteger:PMCourseScheduleRepeatDataWeekDayMonday],
                                 [NSNumber numberWithInteger:PMCourseScheduleRepeatDataWeekDayTuesday],
                                 [NSNumber numberWithInteger:PMCourseScheduleRepeatDataWeekDayWednesday],
                                 [NSNumber numberWithInteger:PMCourseScheduleRepeatDataWeekDayThursday],
                                 [NSNumber numberWithInteger:PMCourseScheduleRepeatDataWeekDayFriday],
                                 [NSNumber numberWithInteger:PMCourseScheduleRepeatDataWeekDayStaturday],
                                 nil];
            for (NSNumber *mappingKey in weekDays) {
                PMCourseScheduleRepeatDataWeekDay repeateWeekDay = [mappingKey longValue];
                if ([courseSchdeudle availableForRepeatWeekDay:repeateWeekDay]) {
                    NSMutableArray *weekDayScheudles = [repreatWeekDayMapping objectForKey:mappingKey];
                    if (weekDayScheudles) {
                        [weekDayScheudles addObject:courseSchdeudle];
                    } else {
                        weekDayScheudles = [NSMutableArray arrayWithObject:courseSchdeudle];
                        [repreatWeekDayMapping setObject:weekDayScheudles forKey:mappingKey];
                    }
                }
            }
        }
    }
    return repreatWeekDayMapping;
}
- (NSArray *)queryCourseScheduleOfDate:(NSDate*)date
{
    NSInteger startTime = [date zb_timestampOfDay];
    NSInteger endTime = [[date zb_dateAfterDay:1] zb_timestampOfDay];
    //1,获取周一，周二..每天的 courseMapping
    NSDictionary *repreatWeekDayMapping = [self queryCourseScheduleMapingOfRepeatWeekDay:startTime endTime:endTime];

    //2, 获取 weekday
    PMCourseScheduleRepeatDataWeekDay repeatWeekDay = [PMCourseScheduleRepeat repeatWeekDayFromDate:date];
    NSArray *candidateCourseSchedules = [repreatWeekDayMapping objectForKey:[NSNumber numberWithInteger:repeatWeekDay]];

    //3，filter time
    NSInteger timestamp  = [date timeIntervalSince1970];
    NSMutableArray *targetCourseSchedules = [NSMutableArray array];
    for (PMCourseSchedule *courseSchedule in candidateCourseSchedules) {
        if (courseSchedule.effectiveDateTimestamp <= timestamp
            && timestamp < courseSchedule.expireDateTimestamp) {
            [targetCourseSchedules addObject:courseSchedule];
        }
    }
    return targetCourseSchedules;
}

#pragma dayCourseSchedule
- (BOOL)saveDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule
{
    return [self.localStorage storeDayCourseSchedule:dayCourseSchedule];
}
- (BOOL)deleteDayCourseSchedule:(PMDayCourseSchedule*)dayCourseSchedule
{
    return [self.localStorage removeDayCourseSchedule:dayCourseSchedule];
}
- (PMDayCourseSchedule*)queryDayCourseScheduleWithId:(NSString*)dayCourseScheduleId
{
    return [self.localStorage getDayCourseScheduleWithId:dayCourseScheduleId];
}
- (NSArray*)queryAllDayCourseSchedule
{
    NSMutableArray *dayCourseSchedules = [NSMutableArray array];
    NSDictionary *viewDayCourseSchedule = [self.localStorage viewDayCourseSchedule];
    for (NSString *dayCourseScheduleId in viewDayCourseSchedule) {
        PMDayCourseSchedule *dayCourseSchedule = [self.localStorage getDayCourseScheduleWithId:dayCourseScheduleId];
        if (dayCourseSchedule) {
            [dayCourseSchedules addObject:dayCourseSchedule];
        }
    }
    return dayCourseSchedules;
}

- (NSArray*)queryDayCourseSchedulesFrom:(NSInteger)startTime toEndTime:(NSInteger)endTime fillNotExist:(BOOL)fillNotExist
{
    NSMutableArray *dayCourseScheduleArray = [NSMutableArray array];
    NSDictionary *viewDayCourseSchedule = [self.localStorage viewDayCourseSchedule];
    for (NSString *dayCourseScheduleId in viewDayCourseSchedule) {
        NSString *scheduleTimestampString = [viewDayCourseSchedule objectForKey:dayCourseScheduleId];
        NSInteger scheduleTimestamp = [scheduleTimestampString integerValue];
        if (startTime <= scheduleTimestamp &&
            scheduleTimestamp < endTime) {
            PMDayCourseSchedule *dayCourseSchedule = [self.localStorage getDayCourseScheduleWithId:dayCourseScheduleId];
            if (dayCourseSchedule) {
                [dayCourseScheduleArray addObject:dayCourseSchedule];
            }
        }
    }
    //检查是否需要 fill, 或者直接返回
    NSInteger endTime1 = [[NSDate dateWithTimeIntervalSince1970:endTime] zb_timestampOfDay];
    if (!fillNotExist
        || startTime + 3600 * 24 * [dayCourseScheduleArray count] >= endTime1) {
        return dayCourseScheduleArray;
    }

    //1,获取周一，周二每天的 courseMapping
    NSDictionary *repreatWeekDayMapping = [self queryCourseScheduleMapingOfRepeatWeekDay:startTime endTime:endTime];

    //2, 构建dayCourseScheduleMapping
    NSMutableDictionary *dayCourseScheduleMapping = [NSMutableDictionary dictionaryWithCapacity:[dayCourseScheduleArray count]];
    for (PMDayCourseSchedule *dayCourseSchedule in dayCourseScheduleArray) {
        NSTimeInterval scheduleTimestamp = [[NSDate dateWithTimeIntervalSince1970:dayCourseSchedule.scheduleTimestamp] zb_timestampOfDay];
        [dayCourseScheduleMapping setObject:dayCourseSchedule forKey:[NSNumber numberWithLong:scheduleTimestamp]];
    }

    //3, 递归每天的dayCourseSchedule
    NSDate *targetDay = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSInteger targetDayTimestamp = [targetDay zb_timestampOfDay];
    while (targetDayTimestamp < endTime) {
        PMDayCourseSchedule *dayCourseSchedule = [dayCourseScheduleMapping objectForKey:[NSNumber numberWithLong:targetDayTimestamp]];
        if (!dayCourseSchedule) {   //填充缺失的 排课信息
            PMCourseScheduleRepeatDataWeekDay repeatWeekDay = [PMCourseScheduleRepeat repeatWeekDayFromDate:targetDay];
            NSArray *candidateCourseSchedules = [repreatWeekDayMapping objectForKey:[NSNumber numberWithInteger:repeatWeekDay]];
            NSMutableArray *targetCourseSchedules = [NSMutableArray array];
            for (PMCourseSchedule *courseSchedule in candidateCourseSchedules) {
                if (courseSchedule.effectiveDateTimestamp <= targetDayTimestamp &&
                    targetDayTimestamp < courseSchedule.expireDateTimestamp) {
                    [targetCourseSchedules addObject:[courseSchedule copy]];
                }
            }
            PMDayCourseSchedule *createdDayCourseSchedule = [PMBusiness createDayCourseScheduleWithCourseSchedules:targetCourseSchedules atDate:targetDay];
            [dayCourseScheduleArray addObject:createdDayCourseSchedule];
        }
        targetDay = [targetDay zb_dateAfterDay:1];
        targetDayTimestamp = [targetDay zb_timestampOfDay];
    }
    return dayCourseScheduleArray;
}

- (BOOL)updateHistoryDayCourseScheduleWithCourseSchedule:(PMCourseSchedule*)courseSchedule
{
    if (PMCourseScheduleRepeatTypeNone == courseSchedule.repeatType &&
        courseSchedule.localDBId) {
        return YES;
    }
    NSArray *dayCourseScheduleArray =[self queryDayCourseSchedulesFrom:courseSchedule.effectiveDateTimestamp toEndTime:[[[NSDate date] zb_dateAfterDay:1] zb_timestampOfDay] fillNotExist:YES];
    for (PMDayCourseSchedule *dayCourseSchedule in dayCourseScheduleArray) {
        if ([dayCourseSchedule hasBeenSavedToLocalDB]) {    //只更新已经 save 到 db 的排课
            BOOL isExist = NO;
            for (PMCourseSchedule *item in dayCourseSchedule.courseSchedules) {
                if ([item.localDBId isEqualToString:courseSchedule.localDBId]) {
                    isExist = YES;
                }
            }
            if (!isExist) {
                if (dayCourseSchedule.courseSchedules) {
                    [dayCourseSchedule.courseSchedules addObject:courseSchedule];
                } else {
                    dayCourseSchedule.courseSchedules = [NSMutableArray arrayWithObject:courseSchedule];
                }
                [self saveDayCourseSchedule:dayCourseSchedule];
            }
        }
    }
    return YES;
}
@end
