//
//  PMWeekDayStat.h
//  PianoMemory
//
//  Created by 张 波 on 14/11/3.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PMCourseScheduleRepeat.h"

@interface PMWeekDayStat :NSObject
@property (nonatomic) PMCourseScheduleRepeatDataWeekDay repeatWeekday;
@property (nonatomic) NSInteger courseCount;
@property (nonatomic) CGFloat durationInHour;
+ (NSArray *)sortDescriptors:(BOOL)ascending;
@end
