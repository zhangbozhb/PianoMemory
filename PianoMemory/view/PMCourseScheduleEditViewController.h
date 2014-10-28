//
//  PMCourseScheduleEditViewController.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCourseSchedule.h"

@class PMCourseScheduleEditViewController;
@protocol PMCourseScheduleEditProtocol <NSObject>
- (void)courseScheduleEdit:(PMCourseScheduleEditViewController*)courseScheduleEdit updateCourseSchedule:(PMCourseSchedule*)courseSchedule indexPath:(NSIndexPath*)indexPath;

@end

@interface PMCourseScheduleEditViewController : UIViewController
@property (nonatomic) PMCourseSchedule *courseSchedule;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic, weak) id<PMCourseScheduleEditProtocol>delegate;
@end
