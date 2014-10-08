//
//  PMCourseSchedule.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "FMObject.h"
#import "PMCourse.h"
#import "PMStudent.h"

@interface PMCourseSchedule : FMObject
@property (nonatomic) PMCourse *course;
@property (nonatomic) NSMutableArray *students;
@property (nonatomic) NSInteger startTime;
@property (nonatomic) NSInteger endTime;
@property (nonatomic) NSString *briefDescription;

+ (NSArray *)sortDescriptors:(BOOL)ascending;
@end
