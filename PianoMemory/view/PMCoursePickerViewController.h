//
//  PMCoursePickerViewController.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-9.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCourse.h"

@class PMCoursePickerViewController;
@protocol PMCoursePickerDelegate <NSObject>
- (void)coursePicker:(PMCoursePickerViewController*)coursePicker course:(PMCourse*)course;
@end

@interface PMCoursePickerViewController : UIViewController
@property (nonatomic, weak) id<PMCoursePickerDelegate> delegate;
@end
