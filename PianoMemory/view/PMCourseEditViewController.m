//
//  PMCourseEditViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCourseEditViewController.h"
#import "UIView+Extend.h"

@interface PMCourseEditViewController ()

//xib referrence
@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationItem;
@property (weak, nonatomic) IBOutlet UITextField *courseNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *courseDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *startTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@end

@implementation PMCourseEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.courseDescriptionTextView zb_addBorder:1
                                     borderColor:[UIColor lightGrayColor]
                                    cornerRadius:6.f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.course) {
        [self.myNavigationItem setTitle:@"编辑课程"];
    } else {
        [self.myNavigationItem setTitle:@"添加课程"];
    }
}

@end
