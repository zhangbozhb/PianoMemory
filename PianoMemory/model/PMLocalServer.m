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
    BOOL isExist = [self.localStorage isStudentExist:student];
    if (!isExist) {
        isExist = (nil != [self.localStorage getStudentWithId:[student syncCreateLocalId]])?YES:NO;
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
    NSMutableArray *students = [NSMutableArray array];
    NSDictionary *viewStudent = [self.localStorage viewStudent];
    for (NSString *studentId in viewStudent) {
        PMStudent *student = [self.localStorage getStudentWithId:studentId];
        BOOL isMatch = NO;
        if (student) {
            if (0 != [name length] &&
                student.name &&
                NSNotFound != [student.name rangeOfString:name].location) {
                isMatch = YES;
            } else if (0 != [phone length] &&
                student.phone &&
                NSNotFound != [student.phone rangeOfString:phone].location) {
                isMatch = YES;
            } else if (0 != [nameShortcut length] &&
                        student.nameShortcut &&
                        NSNotFound != [student.nameShortcut rangeOfString:nameShortcut].location) {
                isMatch = YES;
            } else if (0 ==  [name length]
                       && 0 == [phone length] &&
                       0 == [nameShortcut length]){
                isMatch = YES;
            }
            if (isMatch) {
                [students addObject:student];
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
- (NSArray *)queryCourseScheduleOfDate:(NSDate*)date
{
    NSMutableArray *targetCourseSchedules = [NSMutableArray array];
    NSArray *allCourseSchedules = [self queryAllCourseSchedule];
    for (PMCourseSchedule *courseSchedule in allCourseSchedules) {
        if ([courseSchedule availableFordDate:date]) {
            [targetCourseSchedules addObject:courseSchedule];
        }
    }
    return targetCourseSchedules;
}
- (NSDictionary *)queryCourseScheduleMapingOfRepeatWeekDay
{
    NSArray *allCourseSchedules = [self queryAllCourseSchedule];
    NSMutableDictionary *repreatWeekDayMapping = [NSMutableDictionary dictionary];
    for (PMCourseSchedule *courseSchdeudle in allCourseSchedules) {
        if (PMCourseScheduleRepeatTypeWeek == courseSchdeudle.repeatType) {
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
    return repreatWeekDayMapping;
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

- (NSArray*)queryDayCourseSchedulesFrom:(NSInteger)startTime toEndTime:(NSInteger)endTime createIfNotExsit:(BOOL)createIfNotExsit
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
    if (!createIfNotExsit) {
        return dayCourseScheduleArray;
    }

    //1,获取周一，周二每天的 courseMapping
    NSDictionary *repreatWeekDayMapping = [self queryCourseScheduleMapingOfRepeatWeekDay];


    //2, 构建dayCourseScheduleMapping
    NSMutableDictionary *dayCourseScheduleMapping = [NSMutableDictionary dictionary];
    for (PMDayCourseSchedule *dayCourseSchedule in dayCourseScheduleArray) {
        NSTimeInterval scheduleTimestamp = [[NSDate dateWithTimeIntervalSince1970:dayCourseSchedule.scheduleTimestamp] zb_getDayTimestamp];
        [dayCourseScheduleMapping setObject:dayCourseSchedule forKey:[NSNumber numberWithLong:scheduleTimestamp]];
    }


    //3, 递归每天的dayCourseSchedule
    NSTimeInterval maxCreateTimestamp = [[[NSDate date] zb_dateAfterDay:1] timeIntervalSince1970];
    NSDate *targetDay = [NSDate dateWithTimeIntervalSince1970:startTime];
    long targetDayTimestamp = [targetDay zb_getDayTimestamp];
    while (targetDayTimestamp < endTime) {
        PMDayCourseSchedule *dayCourseSchedule = [dayCourseScheduleMapping objectForKey:[NSNumber numberWithLong:targetDayTimestamp]];
        if (!dayCourseSchedule &&
            targetDayTimestamp < maxCreateTimestamp) {
            //创建 day
            PMCourseScheduleRepeatDataWeekDay repeatWeekDay = [PMCourseSchedule getRepeatWeekDayFromWeekDayIndex:[targetDay zb_getWeekDay]-1];
            NSArray *repeatWeekDayCourseSchedules = [repreatWeekDayMapping objectForKey:[NSNumber numberWithInteger:repeatWeekDay]];
            NSMutableArray *canditeCourseSchedules = [NSMutableArray array];
            for (PMCourseSchedule *courseSchedule in repeatWeekDayCourseSchedules) {
                if (courseSchedule.effectiveDateTimestamp <= targetDayTimestamp &&
                    targetDayTimestamp <= courseSchedule.expireDateTimestamp) {
                    [canditeCourseSchedules addObject:courseSchedule];
                }
            }
            PMDayCourseSchedule *createdDayCourseSchedule = [PMBusiness createDayCourseScheduleWithCourseSchedules:canditeCourseSchedules atDate:targetDay];
            [self saveDayCourseSchedule:createdDayCourseSchedule];
            dayCourseSchedule = createdDayCourseSchedule;
        }

        if(dayCourseSchedule) {
            [dayCourseScheduleArray addObject:dayCourseSchedule];
        }
        targetDay = [targetDay zb_dateAfterDay:1];
        targetDayTimestamp = [targetDay zb_getDayTimestamp];
    }
    return dayCourseScheduleArray;
}


- (PMDayCourseSchedule *)queryDayCourseScheduleOfDate:(NSDate*)date createIfNotExsit:(BOOL)createIfNotExsit
{
    NSInteger startTime = [date zb_getDayTimestamp];
    NSInteger endTime = [[date zb_dateAfterDay:1] zb_getDayTimestamp];
    NSArray *dayCourseSchedules = [self queryDayCourseSchedulesFrom:startTime toEndTime:endTime createIfNotExsit:NO];
    if (0 == [dayCourseSchedules count]) {
        NSArray *courseSchedules = [self queryCourseScheduleOfDate:date];
        PMDayCourseSchedule *dayCourseSchedule = [PMBusiness createDayCourseScheduleWithCourseSchedules:courseSchedules atDate:date];
        if (createIfNotExsit) {
            [self saveDayCourseSchedule:dayCourseSchedule];
        }
        return dayCourseSchedule;
    }
    return [dayCourseSchedules firstObject];
}
@end
