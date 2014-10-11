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
#import "PMCoursePickerViewController.h"
#import "PMStudentPickerViewController.h"
#import "PMCourse+Wrapper.h"
#import "PMStudent+Wrapper.h"
#import "PMCourseSchedule+Wrapper.h"
#import "PMServerWrapper.h"
#import "PMUISettings.h"

@interface PMCourseScheduleEditViewController () <UITextFieldDelegate, PMCoursePickerDelegate, PMStudentPickerDelgate>

@property (nonatomic) PMCourse *course;
@property (nonatomic) NSArray *students;

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
    [self.courseScheduleDescriptionTextView zb_addBorder:1 borderColor:[PMUISettings colorBoarder] cornerRadius:6.f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshUI];
}

- (void)setCourseSchedule:(PMCourseSchedule *)courseSchedule
{
    _courseSchedule = courseSchedule;
    self.course = courseSchedule.course;

}

- (NSString *)checkInputErrorsOfUI
{
    if (0 == [self.coureNameTextField.text length] &&
        self.course) {
        return @"课程不能为空";
    }

    if (0 == [self.studentNameTextField.text length] &&
        (self.students || 0 == [self.students count])) {
        return @"学生不能为空";
    }
    return nil;
}

- (IBAction)commitAction:(id)sender {
    [self.view endEditing:YES];

    NSString *errorMessage = [self checkInputErrorsOfUI];
    if (errorMessage) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                            message:errorMessage
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if (!self.course) {
        PMCourse *course = [[PMCourse alloc] init];
        course.name = self.coureNameTextField.text;
    }
    if (!self.students) {
        PMStudent *student = [[PMStudent alloc] init];
        student.name = self.studentNameTextField.text;
        self.students = [NSArray arrayWithObjects:student, nil];
    }
    //这里不存放的哦数据库，加一个 delegate

}

#pragma delegate textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.coureNameTextField) {
        if (self.course &&
            ![textField.text isEqualToString:self.course.name]) {
            self.course = nil;
        }
    } else if (textField == self.studentNameTextField) {
        if (self.students &&
            [textField.text isEqualToString:[self getNameStringOfStudents:self.students]]) {
            self.students = nil;
        }
    }
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

    if (self.course) {
        self.coureNameTextField.text = [self.course getNotNilName];
    }
    if (self.students) {
        self.studentNameTextField.text = [self getNameStringOfStudents:self.students];
    }
}

- (NSString *)getNameStringOfStudents:(NSArray*)students
{
    NSMutableArray *studentNames = [NSMutableArray array];
    for (PMStudent *student in students) {
        [studentNames addObject:[student getNotNilName]];
    }
    return [studentNames componentsJoinedByString:@";"];
}

#pragma delegate PMCoursePickerDelate
- (void)coursePicker:(PMCoursePickerViewController *)coursePicker course:(PMCourse *)course
{
    self.course = course;
}
#pragma delgate PMStudentPickerDelgate
- (void)studentPicker:(PMStudentPickerViewController*)studentPicker students:(NSArray*)students
{
    self.students = students;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showCoursePickSegueIdentifier"]) {
        PMCoursePickerViewController *coursePickerVC = (PMCoursePickerViewController*)segue.destinationViewController;
        [coursePickerVC setDelegate:self];
    } else if ([segue.identifier isEqualToString:@"showStudentPickSegueIdentifier"]) {
        PMStudentPickerViewController *studentPickerVC = (PMStudentPickerViewController*)segue.destinationViewController;
        [studentPickerVC setDelegate:self];
    }
}

@end
