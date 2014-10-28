
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
#import "PMTimeSchedulePickerViewController.h"
#import "PMCourse+Wrapper.h"
#import "PMStudent+Wrapper.h"
#import "PMCourseSchedule+Wrapper.h"
#import "PMServerWrapper.h"
#import "PMUISettings.h"

#import "NSDate+Extend.h"

@interface PMCourseScheduleEditViewController () <UITextFieldDelegate, PMCoursePickerDelegate, PMStudentPickerDelgate,PMTimeSchedulePickerDelgate, UIScrollViewDelegate>

@property (nonatomic) PMCourseSchedule *changedCourseSchedule;
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
    _changedCourseSchedule = [courseSchedule copy];
}

- (PMCourseSchedule *)changedCourseSchedule
{
    if (!_changedCourseSchedule) {
        _changedCourseSchedule = [[PMCourseSchedule alloc] init];
        _changedCourseSchedule.effectiveDateTimestamp = [[NSDate date] zb_getDayTimestamp];
        _changedCourseSchedule.expireDateTimestamp = [[[NSDate date] zb_dateAfterYear:100] zb_getDayTimestamp] - 1;
    }
    return _changedCourseSchedule;
}

- (NSString *)checkInputErrorsOfUI
{
    if (0 == [self.coureNameTextField.text length] &&
        self.changedCourseSchedule.course) {
        return @"课程不能为空";
    }

    if (0 == [self.studentNameTextField.text length] &&
        (self.changedCourseSchedule.students || 0 == [self.changedCourseSchedule.students count])) {
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
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(courseScheduleEdit:updateCourseSchedule:indexPath:)]) {
        [self.delegate courseScheduleEdit:self updateCourseSchedule:self.changedCourseSchedule indexPath:self.indexPath];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pickEffectiveDateAction:(id)sender {
    if (self.currentDateField == self.effectiveDateTextField) {
        [self hideDatePicker];
    } else {
        self.currentDateField = self.effectiveDateTextField;
        [self.myDatePicker setDatePickerMode:UIDatePickerModeDate];
        [self.myDatePicker setHidden:NO];

        CGPoint targetOffset = CGPointMake(0, self.effectiveDateTextField.frame.origin.y+self.effectiveDateTextField.frame.size.height+self.myDatePicker.frame.size.height-self.myScrollView.frame.size.height);
        if (targetOffset.y < targetOffset.y) {
            [self.myScrollView setContentOffset:targetOffset];
        }
    }
}

- (IBAction)pickExpireDateAction:(id)sender {
    if (self.currentDateField == self.expirationDateTextField) {
        [self hideDatePicker];
    } else {
        self.currentDateField = self.expirationDateTextField;
        [self.myDatePicker setDatePickerMode:UIDatePickerModeDate];
        [self.myDatePicker setHidden:NO];
        CGPoint targetOffset = CGPointMake(0, self.expirationDateTextField.frame.origin.y+self.expirationDateTextField.frame.size.height+self.myDatePicker.frame.size.height-self.myScrollView.frame.size.height);
        if (targetOffset.y < targetOffset.y) {
            [self.myScrollView setContentOffset:targetOffset];
        }
    }
}


- (IBAction)dateTimePickerValueChangeAction:(id)sender {
    if (self.currentDateField == self.effectiveDateTextField) {
        self.changedCourseSchedule.effectiveDateTimestamp = [self.myDatePicker.date zb_getDayTimestamp];
        [self refreshEffectiveExpireTimeUI];
    } else if (self.currentDateField == self.expirationDateTextField) {
        self.changedCourseSchedule.expireDateTimestamp = [[self.myDatePicker.date zb_dateAfterDay:1] zb_getDayTimestamp] - 1;
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
    if (self.changedCourseSchedule.course) {
        self.coureNameTextField.text = [self.changedCourseSchedule.course getNotNilName];
    } else {
        self.coureNameTextField.text = nil;
    }
}

- (void)refreshStudentNameUI
{
    if (self.changedCourseSchedule.students) {
        self.studentNameTextField.text = [self getNameStringOfStudents:self.changedCourseSchedule.students];
    } else {
        self.studentNameTextField.text = nil;
    }
}

- (void)refreshEffectiveExpireTimeUI
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[self effectiveExpireDateFormatterString]];
    self.effectiveDateTextField.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.changedCourseSchedule.effectiveDateTimestamp]];
    self.expirationDateTextField.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.changedCourseSchedule.expireDateTimestamp]];

}

- (NSString *)effectiveExpireDateFormatterString
{
    return @"yyyy-MM-dd";
}

- (void)refreshTimeScheduleUI
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[self timeScheduleFormatterString]];
    self.startTimeTextField.text = [self.changedCourseSchedule.timeSchedule getStartTimeWithTimeFormatter:[self timeScheduleFormatterString]];
    self.endTimeTextField.text = [self.changedCourseSchedule.timeSchedule getEndTimeWithTimeFormatter:[self timeScheduleFormatterString]];
}

- (NSString *)timeScheduleFormatterString
{
    return @"HH:mm";
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
    self.changedCourseSchedule.course = course;
    [self refreshCourseNameUI];
}
#pragma delgate PMStudentPickerDelgate
- (void)studentPicker:(PMStudentPickerViewController*)studentPicker students:(NSArray*)students
{
    self.changedCourseSchedule.students = [NSMutableArray arrayWithArray:students];
    [self refreshStudentNameUI];
}
#pragma delegate PMTimeSchedulePickerDelgate
- (void)timeSchedulePicker:(PMTimeSchedulePickerViewController *)timeSchedulePicker timeSchedule:(PMTimeSchedule *)timeSchedule
{
    self.changedCourseSchedule.timeSchedule = timeSchedule;
    [self refreshTimeScheduleUI];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showCoursePickSegueIdentifier"]) {
        PMCoursePickerViewController *coursePickerVC = (PMCoursePickerViewController*)segue.destinationViewController;
        [coursePickerVC setDelegate:self];
    } else if ([segue.identifier isEqualToString:@"showStudentPickSegueIdentifier"]) {
        PMStudentPickerViewController *studentPickerVC = (PMStudentPickerViewController*)segue.destinationViewController;
        [studentPickerVC setDelegate:self];
    } else if ([segue.identifier isEqualToString:@"showTimeSchedulePickSegueIdentifier"]) {
        PMTimeSchedulePickerViewController *timePickerVC = (PMTimeSchedulePickerViewController*)segue.destinationViewController;
        [timePickerVC setDelegate:self];
    }
}

- (void)hideDatePicker
{
    self.currentDateField = nil;
    [self.myDatePicker setHidden:YES];
}

@end
