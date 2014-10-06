//
//  PMManualAddStudentUIViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-5.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMManualAddStudentUIViewController.h"
#import "PMStudent+Wrapper.h"
#import "PMLocalServer.h"

@interface PMManualAddStudentUIViewController () <UITextFieldDelegate>
@property (nonatomic) PMStudent *changedStudent;

//xib reference
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *qqTextField;
@property (weak, nonatomic) IBOutlet UITextField *weixinTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation PMManualAddStudentUIViewController

#pragma override
- (void)setStudent:(PMStudent *)student
{
    _student = student;
    if (!student) {
        self.changedStudent = [[PMStudent alloc] init];
    }
}

- (void)updateStudentFromUI
{
    [self.view endEditing:NO];

    self.changedStudent.name = (0 < [self.nameTextField.text length])?self.nameTextField.text:nil;
    self.changedStudent.phone = (0 < [self.phoneTextField.text length])?self.phoneTextField.text:nil;
    self.changedStudent.qq = (0 < [self.qqTextField.text length])?self.qqTextField.text:nil;
    self.changedStudent.weixin = (0 < [self.weixinTextField.text length])?self.weixinTextField.text:nil;
    self.changedStudent.email = (0 < [self.emailTextField.text length])?self.emailTextField.text:nil;
    [self.changedStudent updateShortcut];
}

- (NSString *)checkErrorOfStudent:(PMStudent *)student
{
    NSString *error = nil;
    if (!student.name || 0 == [student.name length]) {
        error = @"名字不能为空";
    } else if (!student.phone || 0 == [student.phone length]) {
        error = @"电话号码不能为空";
    }
    return error;
}

#pragma delegate UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [self.phoneTextField becomeFirstResponder];
    } else if (textField == self.phoneTextField) {
        [self.qqTextField becomeFirstResponder];
    } else if (textField == self.qqTextField) {
        [self.weixinTextField becomeFirstResponder];
    } else if (textField == self.weixinTextField) {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [self.emailTextField resignFirstResponder];
    }
    return YES;
}

- (IBAction)popBackToPreviousViewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addStudentAction:(id)sender {
    [self updateStudentFromUI];

    NSString *error = [self checkErrorOfStudent:self.changedStudent];
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                            message:error
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [[PMLocalServer defaultLocalServer] saveStudent:self.changedStudent];
}
@end
