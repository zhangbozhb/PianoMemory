//
//  PMDayCourseSchedule.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-7.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMObject.h"

@interface PMDayCourseSchedule : PMObject
@property (nonatomic) NSInteger scheduleTimestamp;
@property (nonatomic) NSMutableArray *courseSchedules;
@end
