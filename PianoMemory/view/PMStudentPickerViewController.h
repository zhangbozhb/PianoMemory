//
//  PMStudentPickerViewController.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-9.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMStudent.h"

@class PMStudentPickerViewController;
@protocol PMStudentPickerDelgate <NSObject>
- (void)studentPicker:(PMStudentPickerViewController*)studentPicker students:(NSArray*)students;
@end

@interface PMStudentPickerViewController : UIViewController
@property (nonatomic, weak) id<PMStudentPickerDelgate>delegate;
@end
