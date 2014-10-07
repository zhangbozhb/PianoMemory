//
//  PMCourseScheduleEditViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCourseScheduleEditViewController.h"
#import "UIView+Extend.h"
#import "UIViewController+WithKeyboardNotification.h"

@interface PMCourseScheduleEditViewController () <UITextFieldDelegate>


//xib reference
@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationItem;
@property (weak, nonatomic) IBOutlet UITextField *coureNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *studentNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *startTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTextField;
@property (weak, nonatomic) IBOutlet UITextView *courseScheduleDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@end

@implementation PMCourseScheduleEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.courseScheduleDescriptionTextView zb_addBorder:1 borderColor:[UIColor lightGrayColor] cornerRadius:6.f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshUI];
}

#pragma delegate textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma add keyboard appear and dissappear
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //register keyboard notification
    [self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self unRegisterForKeyboardNotifications];
}

- (void)handleKeyboardAppear:(NSTimeInterval)duration keyboardHeight:(CGFloat)keyboardHeight
{
    if ([self.courseScheduleDescriptionTextView isFirstResponder]) {
        [super handleKeyboardAppear:duration keyboardHeight:keyboardHeight-60];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)refreshUI
{
    NSString *navigationTilte = @"新增课程安排";
    NSString *commitButtonTitle = @"添加";
    if (self.courseSchedule) {
        navigationTilte = @"修改课程安排";
        commitButtonTitle = @"修改";
    }
    [self.myNavigationItem setTitle:navigationTilte];
    [self.commitButton setTitle:commitButtonTitle forState:UIControlStateNormal];
}


@end
