//
//  PMTimeSchedulePickerViewController.h
//  PianoMemory
//
//  Created by 张 波 on 14/10/20.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMTimeSchedule+Wrapper.h"

@class PMTimeSchedulePickerViewController;
@protocol PMTimeSchedulePickerDelgate <NSObject>
- (void)timeSchedulePicker:(PMTimeSchedulePickerViewController*)timeSchedulePicker timeSchedule:(PMTimeSchedule*)timeSchedule;
@end

@interface PMTimeSchedulePickerViewController : UIViewController
@property (nonatomic, weak) id<PMTimeSchedulePickerDelgate>delegate;
@end
