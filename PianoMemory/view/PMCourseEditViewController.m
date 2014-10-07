//
//  PMCourseEditViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCourseEditViewController.h"
#import "UIView+Extend.h"
#import "NSDate+Extend.h"
#import "PMCourse+Wrapper.h"
#import "PMServerWrapper.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface PMCourseEditViewController () <UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic) PMCourse *changedCourse;

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
    self.course = (nil == self.course)?nil:self.course;
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
    [self refreshUI];
}


- (void)setCourse:(PMCourse *)course
{
    _course = course;
    if (course) {
        self.changedCourse = [course copy];
    } else {
        self.changedCourse = [[PMCourse alloc] init];
    }
}

#pragma delegate of textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.courseNameTextField) {
        [self.courseDescriptionTextView becomeFirstResponder];
    } else if (textField == self.startTimeTextField) {
        [self.endTimeTextField becomeFirstResponder];
    } else if (textField == self.endTimeTextField) {
        [self.priceTextField becomeFirstResponder];
    } else if (textField == self.endTimeTextField) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma conveniece method
- (void)updateCourseFromUI
{
    self.changedCourse.name = self.courseNameTextField.text;
    self.changedCourse.briefDescription = self.courseDescriptionTextView.text;
}



- (void)refreshUI
{
    if (self.changedCourse) {
        self.courseNameTextField.text = (nil != self.changedCourse.name)?self.changedCourse.name:@"";
        self.courseDescriptionTextView.text = (nil != self.changedCourse.briefDescription)?self.changedCourse.briefDescription:@"";
        self.startTimeTextField.text = [self.changedCourse getStartTimeWithFormatterString:@"HH:mm"];
        self.endTimeTextField.text = [self.changedCourse getEndTimeWithFormatterString:@"HH:mm"];
        self.priceTextField.text = [NSString stringWithFormat:@"%.2f", self.changedCourse.price];
    } else {
        self.courseNameTextField.text = @"";
        self.courseDescriptionTextView.text = @"";
        self.startTimeTextField.text = @"";
        self.endTimeTextField.text = @"";
        self.priceTextField.text = [NSString stringWithFormat:@"%.2f", 0.f];
    }
}

- (NSString *)checkErrorOfCourse:(PMCourse *)course
{
    NSString *error = nil;
    if (!course.name || 0 == [course.name length]) {
        error = @"名字不能为空";
    }
    return error;
}

- (MBProgressHUD*)getSimpleToastWithTitle:(NSString*)title message:(NSString*)message
{
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:toast];
    toast.mode = MBProgressHUDModeText;
    toast.animationType = MBProgressHUDAnimationZoomOut;
    [toast setLabelText:title];
    [toast setDetailsLabelText:message];
    return toast;
}

- (void)createCourse:(PMCourse*)course
{
    __weak PMCourseEditViewController *pSelf = self;
    [[PMServerWrapper defaultServer] createCourse:course success:^(PMCourse *course) {
        pSelf.course = course;
        MBProgressHUD *toast = [self getSimpleToastWithTitle:@"成功" message:@"你已成功添加课程"];
        [toast showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [toast removeFromSuperview];
            [pSelf.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(HCErrorMessage *error) {
        MBProgressHUD *toast = [pSelf getSimpleToastWithTitle:@"失败" message:[error errorMessage]];
        [toast showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [toast removeFromSuperview];
        }];
    }];
}

- (void)updateCourse:(PMCourse*)course
{
    __weak PMCourseEditViewController *pSelf = self;
    [[PMServerWrapper defaultServer] updateCourse:course success:^(PMCourse *course) {
        pSelf.course = course;
        MBProgressHUD *toast = [self getSimpleToastWithTitle:@"成功" message:@"你已成功修改课程"];
        [toast showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [toast removeFromSuperview];
            [pSelf.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(HCErrorMessage *error) {
        MBProgressHUD *toast = [pSelf getSimpleToastWithTitle:@"失败" message:[error errorMessage]];
        [toast showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [toast removeFromSuperview];
        }];
    }];
}

- (IBAction)commitChangeAction:(id)sender {
    [self updateCourseFromUI];

    NSString *error = [self checkErrorOfCourse:self.changedCourse];
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                            message:error
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (self.course) {
        if ( (self.course.name != self.changedCourse.name &&
              [self.course.name isEqualToString:self.changedCourse.name]) ||
            (self.course.briefDescription != self.changedCourse.briefDescription &&
             [self.course.briefDescription isEqualToString:self.changedCourse.briefDescription]) ||
            self.course.startDayTime != self.changedCourse.startDayTime ||
            self.course.endDayTime != self.changedCourse.endDayTime ||
            fabsf(self.course.price - self.changedCourse.price) > FLT_EPSILON ) {
            [self updateCourse:self.changedCourse];
        }
    } else {
        [self createCourse:self.changedCourse];
    }
}


@end
