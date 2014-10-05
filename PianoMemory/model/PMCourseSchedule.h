//
//  PMCourseSchedule.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "FMObject.h"

@interface PMCourseSchedule : FMObject
@property (nonatomic) NSString *courseId;
@property (nonatomic) NSMutableArray *students;
@property (nonatomic) NSInteger startTime;
@property (nonatomic) NSInteger endTime;
@end
