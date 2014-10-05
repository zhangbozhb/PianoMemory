//
//  PMManualAddStudentUIViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-5.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMManualAddStudentUIViewController.h"

@interface PMManualAddStudentUIViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *qqTextField;
@property (weak, nonatomic) IBOutlet UITextField *weixinTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation PMManualAddStudentUIViewController


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
}
@end
