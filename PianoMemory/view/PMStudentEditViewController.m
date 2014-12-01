//
//  PMStudentEditViewController.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-5.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMStudentEditViewController.h"
#import "PMStudent+Wrapper.h"
#import "PMServerWrapper.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIViewController+WithKeyboardNotification.h"
#import "UIView+Extend.h"
#import "PMUISettings.h"

@interface PMStudentEditViewController () <UITextFieldDelegate>
@property (nonatomic) PMStudent *changedStudent;

//xib reference
@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationItem;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *qqTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextView *briefDescriptionTextView;

@end

@implementation PMStudentEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.student = (nil == self.student)?nil:self.student;
    [self.briefDescriptionTextView zb_addBorder:1 borderColor:[PMUISettings colorBoarder] cornerRadius:6.f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshUI];
}

#pragma override
- (void)setStudent:(PMStudent *)student
{
    _student = student;
    if (student) {
        self.changedStudent = [student copy];
    } else {
        self.changedStudent = [[PMStudent alloc] init];
    }
}

- (void)updateStudentFromUI
{
    [self.view endEditing:NO];
    self.changedStudent.name = (0 < [self.nameTextField.text length])?self.nameTextField.text:nil;
    self.changedStudent.phone = (0 < [self.phoneTextField.text length])?self.phoneTextField.text:nil;
    self.changedStudent.qq = (0 < [self.qqTextField.text length])?self.qqTextField.text:nil;
    self.changedStudent.email = (0 < [self.emailTextField.text length])?self.emailTextField.text:nil;
    self.changedStudent.briefDescription = (0 < [self.briefDescriptionTextView.text length])?self.briefDescriptionTextView.text:nil;
    [self.changedStudent updateShortcut];
}

- (void)refreshUI
{
    if (self.student) {
        [self.myNavigationItem setTitle:@"修改学生信息"];

        self.nameTextField.text = (nil!=self.changedStudent.name)?self.changedStudent.name:@"";
        self.phoneTextField.text = (nil!=self.changedStudent.phone)?self.changedStudent.phone:@"";
        self.qqTextField.text = (nil!=self.changedStudent.qq)?self.changedStudent.qq:@"";
        self.emailTextField.text = (nil!=self.changedStudent.email)?self.changedStudent.email:@"";
        self.briefDescriptionTextView.text = (nil!=self.changedStudent.briefDescription)?self.changedStudent.briefDescription:@"";
    } else {
        [self.myNavigationItem setTitle:@"新增学生"];

        self.nameTextField.text = @"";
        self.phoneTextField.text = @"";
        self.qqTextField.text = @"";
        self.emailTextField.text = @"";
        self.briefDescriptionTextView.text = @"";
    }
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
        return NO;
    } else if (textField == self.phoneTextField) {
        [self.qqTextField becomeFirstResponder];
        return NO;
    } else if (textField == self.qqTextField) {
        [self.emailTextField becomeFirstResponder];
        return NO;
    } else if (textField == self.emailTextField) {
        [self.briefDescriptionTextView becomeFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)popBackToPreviousViewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveStudentAction:(id)sender {
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
    if (self.student) {
        if ( (self.student.name != self.changedStudent.name &&
              [self.student.name isEqualToString:self.changedStudent.name]) ||
             (self.student.phone != self.changedStudent.phone &&
              [self.student.phone isEqualToString:self.changedStudent.phone]) ||
            (self.student.qq != self.changedStudent.qq &&
             [self.student.qq isEqualToString:self.changedStudent.qq]) ||
            (self.student.email != self.changedStudent.email &&
             [self.student.email isEqualToString:self.changedStudent.email]) ||
            (self.student.briefDescription != self.changedStudent.briefDescription &&
             [self.student.briefDescription isEqualToString:self.changedStudent.briefDescription])) {
            [self updateStudent:self.changedStudent];
        }
    } else {
        [self createStudent:self.changedStudent];
    }
}

#pragma convenience method
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

- (void)createStudent:(PMStudent *)student
{
    __weak PMStudentEditViewController *pSelf = self;
    [[PMServerWrapper defaultServer] createStudent:self.changedStudent success:^(PMStudent *student) {
        dispatch_async(dispatch_get_main_queue(), ^{
            pSelf.changedStudent = student;
            MBProgressHUD *toast = [pSelf getSimpleToastWithTitle:@"成功" message:@"已经成功添加学生"];
            [toast showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [toast removeFromSuperview];
                [pSelf.navigationController popViewControllerAnimated:YES];
            }];
        });
    } failure:^(HCErrorMessage *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *toast = [pSelf getSimpleToastWithTitle:@"失败" message:[error errorMessage]];
            [toast showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [toast removeFromSuperview];
            }];
        });
    }];
}

- (void)updateStudent:(PMStudent *)student
{
    __weak PMStudentEditViewController *pSelf = self;
    [[PMServerWrapper defaultServer] updateStudent:self.changedStudent success:^(PMStudent *student) {
        dispatch_async(dispatch_get_main_queue(), ^{
            pSelf.changedStudent = student;
            MBProgressHUD *toast = [pSelf getSimpleToastWithTitle:@"成功" message:@"已经成功修改学生信息"];
            [toast showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [toast removeFromSuperview];
                [pSelf.navigationController popViewControllerAnimated:YES];
            }];
        });
    } failure:^(HCErrorMessage *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *toast = [pSelf getSimpleToastWithTitle:@"失败" message:[error errorMessage]];
            [toast showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [toast removeFromSuperview];
            }];
        });
    }];
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
    if ([self.emailTextField isFirstResponder] ||
        [self.briefDescriptionTextView isFirstResponder]) {
        [super handleKeyboardAppear:duration keyboardHeight:keyboardHeight-60];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
