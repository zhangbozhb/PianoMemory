//
//  PMCourseScheduleTableViewCell.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-5.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCourseSchedule.h"

@interface PMCourseScheduleTableViewCell : UITableViewCell
@property (nonatomic) PMCourseSchedule *courseSchedule;
- (void)refreshUI;
@end
