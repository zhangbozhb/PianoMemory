
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
#import "UIView+Extend.h"
#import <MBProgressHUD/MBProgressHUD.h>

const static NSString *addToHistoryDayCourseSchedule = @"课程安排的开始日期早于今天，是否将本课程安排添加到历史数据中?";

@interface PMCourseScheduleEditViewController () <UITextFieldDelegate, PMCoursePickerDelegate, PMStudentPickerDelgate,PMTimeSchedulePickerDelgate, UIScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic) PMCourseSchedule *changedCourseSchedule;
@property (weak, nonatomic) UILabel *currentDateField;


//xib reference
@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationItem;

@property (weak, nonatomic) IBOutlet UIView *anchorView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *myContentView;

@property (weak, nonatomic) IBOutlet UILabel *coureNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *effectiveDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *expirationDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *courseScheduleDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;
@property (weak, nonatomic) IBOutlet UISwitch *repeatSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *weekDaySegmentControl;

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

    NSArray *viewContainerArray = [NSArray arrayWithObjects:self.coureNameLabel, self.studentNameLabel,
                                   self.startTimeLabel, self.endTimeLabel, self.effectiveDateLabel,
                                   self.expirationDateLabel, nil];
    UIColor *boardColor = [UIColor colorWithRed:230.f/255.f green:230.f/255.f blue:230.f/255.f alpha:1.f];
    for (UIView *containerView in viewContainerArray) {
        [containerView zb_addBorder:1.f borderColor:boardColor cornerRadius:6.f];
    }
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
    if (0 == [self.coureNameLabel.text length] &&
        self.changedCourseSchedule.course) {
        return @"课程不能为空";
    }

    if (0 == [self.studentNameLabel.text length] &&
        (self.changedCourseSchedule.students || 0 == [self.changedCourseSchedule.students count])) {
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
    if (PMCourseScheduleRepeatTypeNone == self.changedCourseSchedule.repeatType) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(courseScheduleEdit:updateCourseSchedule:indexPath:)]) {
            [self.delegate courseScheduleEdit:self updateCourseSchedule:self.changedCourseSchedule indexPath:self.indexPath];
        }
    } else {
        if (self.changedCourseSchedule.effectiveDateTimestamp <= [[NSDate date] zb_getDayTimestamp]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:[addToHistoryDayCourseSchedule copy]
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            [alertView show];
        } else {
            [self saveCourseSchedule:NO];
        }
    }
}

- (void)saveCourseSchedule:(BOOL)addToHistoryDayCourseSchedule
{
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:toast];
    toast.removeFromSuperViewOnHide = YES;
    toast.mode = MBProgressHUDModeIndeterminate;
    toast.animationType = MBProgressHUDAnimationFade;
    [toast setLabelText:@"正在保存课程..."];
    [toast show:YES];

    __weak PMCourseScheduleEditViewController *pSelf = self;
    [[PMServerWrapper defaultServer] updateCourseSchedule:self.changedCourseSchedule success:^(PMCourseSchedule *courseSchedule) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (pSelf.delegate &&
                [pSelf.delegate respondsToSelector:@selector(courseScheduleEdit:updateCourseSchedule:indexPath:)]) {
                [pSelf.delegate courseScheduleEdit:pSelf updateCourseSchedule:courseSchedule indexPath:pSelf.indexPath];
            }

            if (addToHistoryDayCourseSchedule) {
                [toast setLabelText:@"正在更新历史课程安排..."];
                [[PMServerWrapper defaultServer] updateHistoryDayCourseScheduleWithCourseSchedule:courseSchedule success:^{
                    [toast hide:YES];
                    [pSelf.navigationController popViewControllerAnimated:YES];
                } failure:^(HCErrorMessage *error) {
                    [toast hide:YES];
                    [pSelf.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                [toast setLabelText:@"课程保存成功"];
                [toast showAnimated:YES whileExecutingBlock:^{
                    sleep(2);
                } completionBlock:^{
                    [toast removeFromSuperview];
                    [pSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
        });
    } failure:^(HCErrorMessage *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [toast setLabelText:@"课程保存失败"];
            [toast setDetailsLabelText:error.errorMessage];
            [toast show:YES];
            [toast hide:YES afterDelay:2];
        });
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:[addToHistoryDayCourseSchedule copy]]) {
        [self saveCourseSchedule:1==buttonIndex];
    }
}

- (IBAction)pickEffectiveDateAction:(id)sender {
    if (self.currentDateField == self.effectiveDateLabel) {
        [self hideDatePicker];
    } else {
        self.currentDateField = self.effectiveDateLabel;
        [self.myDatePicker setDatePickerMode:UIDatePickerModeDate];
        [self.myDatePicker setHidden:NO];

        CGPoint targetOffset = CGPointMake(0, self.effectiveDateLabel.frame.origin.y+self.effectiveDateLabel.frame.size.height+self.myDatePicker.frame.size.height-self.myScrollView.frame.size.height);
        if (targetOffset.y < targetOffset.y) {
            [self.myScrollView setContentOffset:targetOffset];
        }
    }
}

- (IBAction)pickExpireDateAction:(id)sender {
    if (self.currentDateField == self.expirationDateLabel) {
        [self hideDatePicker];
    } else {
        self.currentDateField = self.expirationDateLabel;
        [self.myDatePicker setDatePickerMode:UIDatePickerModeDate];
        [self.myDatePicker setHidden:NO];
        CGPoint targetOffset = CGPointMake(0, self.expirationDateLabel.frame.origin.y+self.expirationDateLabel.frame.size.height+self.myDatePicker.frame.size.height-self.myScrollView.frame.size.height);
        if (targetOffset.y < targetOffset.y) {
            [self.myScrollView setContentOffset:targetOffset];
        }
    }
}


- (IBAction)dateTimePickerValueChangeAction:(id)sender {
    if (self.currentDateField == self.effectiveDateLabel) {
        self.changedCourseSchedule.effectiveDateTimestamp = [self.myDatePicker.date zb_getDayTimestamp];
        [self refreshEffectiveExpireTimeUI];
    } else if (self.currentDateField == self.expirationDateLabel) {
        self.changedCourseSchedule.expireDateTimestamp = [[self.myDatePicker.date zb_dateAfterDay:1] zb_getDayTimestamp] - 1;
        [self refreshEffectiveExpireTimeUI];
    }
}

- (IBAction)repeatTypeChangedAction:(id)sender {
    if ([self.repeatSwitch isOn]) {
        [self.changedCourseSchedule setRepeatType:PMCourseScheduleRepeatTypeWeek];

        PMCourseScheduleRepeatDataWeekDay repateWeekday = [PMCourseScheduleRepeat repeatWeekDayFromDate:[NSDate date]];
        [self.changedCourseSchedule setRepeatWeekDay:repateWeekday];
    } else {
        [self.changedCourseSchedule setRepeatType:PMCourseScheduleRepeatTypeNone];
    }
    [self refreshRepeatInfoUI];
}

- (IBAction)repeatDateChangeAction:(id)sender {
    PMCourseScheduleRepeatDataWeekDay repateWeekday = [PMCourseScheduleRepeat repeatWeekDayFromDayIndexInWeek:[self.weekDaySegmentControl selectedSegmentIndex]];
    [self.changedCourseSchedule setRepeatWeekDay:repateWeekday];
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
        self.coureNameLabel.text = [self.changedCourseSchedule.course getNotNilName];
    } else {
        self.coureNameLabel.text = nil;
    }
}

- (void)refreshStudentNameUI
{
    if (self.changedCourseSchedule.students) {
        self.studentNameLabel.text = [self getNameStringOfStudents:self.changedCourseSchedule.students];
    } else {
        self.studentNameLabel.text = nil;
    }
}

- (void)refreshEffectiveExpireTimeUI
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[self effectiveExpireDateFormatterString]];
    self.effectiveDateLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.changedCourseSchedule.effectiveDateTimestamp]];
    self.expirationDateLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.changedCourseSchedule.expireDateTimestamp]];
}

- (NSString *)effectiveExpireDateFormatterString
{
    return @"yyyy-MM-dd";
}

- (void)refreshTimeScheduleUI
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[self timeScheduleFormatterString]];
    self.startTimeLabel.text = [self.changedCourseSchedule.timeSchedule getStartTimeWithTimeFormatter:[self timeScheduleFormatterString]];
    self.endTimeLabel.text = [self.changedCourseSchedule.timeSchedule getEndTimeWithTimeFormatter:[self timeScheduleFormatterString]];
}

- (NSString *)timeScheduleFormatterString
{
    return @"HH:mm";
}

- (void)refreshRepeatInfoUI
{
    if (PMCourseScheduleRepeatTypeWeek == self.changedCourseSchedule.repeatType) {
        [self.repeatSwitch setOn:YES];
        [self.weekDaySegmentControl setEnabled:YES];
        NSArray *weekDays = [self.changedCourseSchedule getRepeatWeekDays];
        NSInteger dayIndexInWeek = [PMCourseScheduleRepeat dayIndexInWeekFromRepeatWeekDay:[[weekDays firstObject] longValue]];
        [self.weekDaySegmentControl setSelectedSegmentIndex:dayIndexInWeek];
    } else  {
        [self.repeatSwitch setOn:NO];
        [self.weekDaySegmentControl setEnabled:NO];
    }
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
    [self refreshTimeScheduleUI];
    [self refreshEffectiveExpireTimeUI];
    [self refreshRepeatInfoUI];
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
