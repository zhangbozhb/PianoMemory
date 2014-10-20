
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

#import "NSDate+Extend.h"

@interface PMCourseScheduleEditViewController () <UITextFieldDelegate, PMCoursePickerDelegate, PMStudentPickerDelgate, UIScrollViewDelegate>

@property (nonatomic) PMCourseSchedule *courseScheduleForUI;
@property (weak, nonatomic) UITextField *currentDateField;

//xib reference

@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationItem;

@property (weak, nonatomic) IBOutlet UIView *anchorView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *myContentView;

@property (weak, nonatomic) IBOutlet UITextField *coureNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *studentNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *startTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *effectiveDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *expirationDateTextField;
@property (weak, nonatomic) IBOutlet UITextView *courseScheduleDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;

@end

@implementation PMCourseScheduleEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.courseScheduleDescriptionTextView zb_addBorder:1 borderColor:[PMUISettings colorBoarder] cornerRadius:6.f];
    [self.myScrollView setContentSize:self.anchorView.frame.size];
    UITapGestureRecognizer *hideDatePickerGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDatePicker)];
    [self.myScrollView addGestureRecognizer:hideDatePickerGesture];

    [self.myDatePicker setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshUI];
}

- (void)setCourseSchedule:(PMCourseSchedule *)courseSchedule
{
    _courseSchedule = courseSchedule;
    if (courseSchedule) {
        _courseScheduleForUI = [courseSchedule copy];
    }
}

- (PMCourseSchedule *)courseScheduleForUI
{
    if (!_courseScheduleForUI) {
        _courseScheduleForUI = [[PMCourseSchedule alloc] init];
        _courseScheduleForUI.effectiveDateTimestamp = [[NSDate date] zb_getDayTimestamp];
        _courseScheduleForUI.expireDateTimestamp = [[[NSDate date] zb_dateAfterYear:100] zb_getDayTimestamp] - 1;
    }
    return _courseScheduleForUI;
}

- (NSString *)checkInputErrorsOfUI
{
    if (0 == [self.coureNameTextField.text length] &&
        self.courseScheduleForUI.course) {
        return @"课程不能为空";
    }

    if (0 == [self.studentNameTextField.text length] &&
        (self.courseScheduleForUI.students || 0 == [self.courseScheduleForUI.students count])) {
        return @"学生不能为空";
    }
    return nil;
}

- (void)updateCourseScheduleFromUI
{

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
    //这里不存放的哦数据库，加一个 delegate

}

- (IBAction)pickEffectiveDateAction:(id)sender {
    self.currentDateField = self.effectiveDateTextField;
    [self.myDatePicker setDatePickerMode:UIDatePickerModeDate];
    [self.myDatePicker setHidden:NO];

    CGPoint targetOffset = CGPointMake(0, self.effectiveDateTextField.frame.origin.y+self.effectiveDateTextField.frame.size.height+self.myDatePicker.frame.size.height-self.myScrollView.frame.size.height);
    if (targetOffset.y < targetOffset.y) {
        [self.myScrollView setContentOffset:targetOffset];
    }
}

- (IBAction)pickExpireDateAction:(id)sender {
    self.currentDateField = self.expirationDateTextField;
    [self.myDatePicker setDatePickerMode:UIDatePickerModeDate];
    [self.myDatePicker setHidden:NO];
    CGPoint targetOffset = CGPointMake(0, self.expirationDateTextField.frame.origin.y+self.expirationDateTextField.frame.size.height+self.myDatePicker.frame.size.height-self.myScrollView.frame.size.height);
    if (targetOffset.y < targetOffset.y) {
        [self.myScrollView setContentOffset:targetOffset];
    }
}


- (IBAction)dateTimePickerValueChangeAction:(id)sender {
    if (self.currentDateField == self.effectiveDateTextField) {
        self.courseScheduleForUI.effectiveDateTimestamp = [self.myDatePicker.date zb_getDayTimestamp];
        [self refreshEffectiveExpireTimeUI];
    } else if (self.currentDateField == self.expirationDateTextField) {
        self.courseScheduleForUI.expireDateTimestamp = [[self.myDatePicker.date zb_dateAfterDay:1] zb_getDayTimestamp] - 1;
        [self refreshEffectiveExpireTimeUI];
    }
}

#pragma delegate textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma delegate UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

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

- (void)refreshCourseNameUI
{
    if (self.courseScheduleForUI.course) {
        self.coureNameTextField.text = [self.courseScheduleForUI.course getNotNilName];
    } else {
        self.coureNameTextField.text = nil;
    }
}

- (void)refreshStudentNameUI
{
    if (self.courseScheduleForUI.students) {
        self.studentNameTextField.text = [self getNameStringOfStudents:self.courseScheduleForUI.students];
    } else {
        self.studentNameTextField.text = nil;
    }
}

- (void)refreshEffectiveExpireTimeUI
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[self effectiveExpireDateFormatterString]];
    self.effectiveDateTextField.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.courseScheduleForUI.effectiveDateTimestamp]];
    self.expirationDateTextField.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.courseScheduleForUI.expireDateTimestamp]];

}

- (NSString *)effectiveExpireDateFormatterString
{
    return @"yyyy-MM-dd";
}

- (void)refreshUI
{
    NSString *navigationTilte = @"新增课程安排";
    if (self.courseSchedule) {
        navigationTilte = @"修改课程安排";
    }
    [self.myNavigationItem setTitle:navigationTilte];

    [self refreshCourseNameUI];
    [self refreshStudentNameUI];
    [self refreshEffectiveExpireTimeUI];
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
    self.courseScheduleForUI.course = course;
    [self refreshCourseNameUI];
}
#pragma delgate PMStudentPickerDelgate
- (void)studentPicker:(PMStudentPickerViewController*)studentPicker students:(NSArray*)students
{
    self.courseScheduleForUI.students = [NSMutableArray arrayWithArray:students];
    [self refreshStudentNameUI];
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

- (void)hideDatePicker
{
    self.currentDateField = nil;
    [self.myDatePicker setHidden:YES];
}

@end
