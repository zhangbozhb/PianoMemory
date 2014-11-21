//
//  PMTimeScheduleEditViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-11.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMTimeScheduleEditViewController.h"
#import "PMTimeSchedule+Wrapper.h"
#import "UIView+Extend.h"
#import "NSDate+Extend.h"
#import "PMUISettings.h"
#import "PMServerWrapper.h"
#import <MBProgressHUD/MBProgressHUD.h>

static NSInteger const kDefaultDurationTimestamp = 60 * 40;

@interface PMTimeScheduleEditViewController () <UITextFieldDelegate>

@property (nonatomic, weak) UILabel *targetLabel;
@property (nonatomic) PMTimeSchedule *changedTimeSchedle;

//xib reference
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;
@end

@implementation PMTimeScheduleEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.startTimeLabel zb_addBorder:1.f borderColor:[PMUISettings colorBoarder] cornerRadius:6.f];
    [self.endTimeLabel zb_addBorder:1.f borderColor:[PMUISettings colorBoarder] cornerRadius:6.f];

    UITapGestureRecognizer *editStartTimeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hanldeEditStartTimeGesture:)];
    [editStartTimeGesture setNumberOfTapsRequired:1];
    [self.startTimeLabel addGestureRecognizer:editStartTimeGesture];

    UITapGestureRecognizer *editEndTimeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleEditEndTimeGesture:)];
    [editStartTimeGesture setNumberOfTapsRequired:1];
    [self.endTimeLabel addGestureRecognizer:editEndTimeGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshUI];
}

- (void)setTimeSchedule:(PMTimeSchedule *)timeSchedule
{
    _timeSchedule = timeSchedule;
    _changedTimeSchedle = [timeSchedule copy];
}

- (PMTimeSchedule *)changedTimeSchedle
{
    if (!_changedTimeSchedle) {
        if (self.timeSchedule) {
            _changedTimeSchedle = [self.timeSchedule copy];
        } else {
            _changedTimeSchedle = [[PMTimeSchedule alloc] init];
            NSDate *currentDate = [NSDate date];
            _changedTimeSchedle.startTime = [currentDate timeIntervalSince1970] - [currentDate zb_timestampOfDay];
            //默认为40分钟
            _changedTimeSchedle.endTime = _changedTimeSchedle.startTime + kDefaultDurationTimestamp;
        }
    }
    return _changedTimeSchedle;
}

- (void)hanldeEditStartTimeGesture:(UITapGestureRecognizer*)gesture
{
    self.targetLabel = self.startTimeLabel;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[self.changedTimeSchedle defaultDateTimeFormat]];
    NSDate *targetDate = [dateFormatter dateFromString:self.targetLabel.text];
    NSTimeInterval timestampInday = [targetDate timeIntervalSince1970] - [targetDate zb_timestampOfDay];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] zb_timestampOfDay] + timestampInday];
    [self.myDatePicker setDate:date];
    [self.myDatePicker setHidden:NO];
}

- (void)handleEditEndTimeGesture:(UITapGestureRecognizer*)gesture
{
    self.targetLabel = self.endTimeLabel;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[self.changedTimeSchedle defaultDateTimeFormat]];
    NSDate *targetDate = [dateFormatter dateFromString:self.targetLabel.text];
    NSTimeInterval timestampInday = [targetDate timeIntervalSince1970] - [targetDate zb_timestampOfDay];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] zb_timestampOfDay] + timestampInday];
    [self.myDatePicker setDate:date];
    [self.myDatePicker setHidden:NO];
}

- (IBAction)datePickerValueChangeAction:(id)sender {
    NSDate *selectDate = [self.myDatePicker date];
    NSTimeInterval timestampInDay = [selectDate timeIntervalSince1970]-[selectDate zb_timestampOfDay];

    if (self.targetLabel == self.startTimeLabel) {
        [self.changedTimeSchedle setStartTime:timestampInDay];
        self.startTimeLabel.text = [self.changedTimeSchedle getStartTimeWithTimeFormatter:nil];
    } else if (self.targetLabel == self.endTimeLabel) {
        [self.changedTimeSchedle setEndTime:timestampInDay];
        self.endTimeLabel.text = [self.changedTimeSchedle getEndTimeWithTimeFormatter:nil];
    }
}

- (IBAction)saveTimeScheduleAction:(id)sender {

    [self.view endEditing:YES];

    [self updateTimeScheduleFromUI];
    NSString *error = [self checkErrorOfCourse:self.changedTimeSchedle];
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                            message:error
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (self.timeSchedule) {
        if ( (self.timeSchedule.name != self.changedTimeSchedle.name &&
              [self.timeSchedule.name isEqualToString:self.changedTimeSchedle.name]) ||
            fabsf(self.timeSchedule.startTime - self.changedTimeSchedle.startTime) > FLT_EPSILON ||
            fabsf(self.timeSchedule.endTime - self.changedTimeSchedle.endTime) > FLT_EPSILON) {
            [self updateTimeSchedule:self.changedTimeSchedle];
        }
    } else {
        [self createTimeSchedule:self.changedTimeSchedle];
    }
}

#pragma delegate UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.targetLabel = nil;
    [self.myDatePicker setHidden:YES];
    [self.view endEditing:YES];
}


#pragma conveniece method
- (void)updateTimeScheduleFromUI
{
    self.changedTimeSchedle.name = self.nameTextField.text;
}

- (void)refreshUI
{
    self.nameTextField.text = [self.changedTimeSchedle getNotNilName];
    self.startTimeLabel.text = [self.changedTimeSchedle getStartTimeWithTimeFormatter:nil];
    self.endTimeLabel.text = [self.changedTimeSchedle getEndTimeWithTimeFormatter:nil];
}

- (NSString *)checkErrorOfCourse:(PMTimeSchedule *)timeSchedule
{
    NSString *error = nil;
    if (!timeSchedule.name || 0 == [timeSchedule.name length]) {
        error = @"名字不能为空";
    } else if (timeSchedule.startTime >= timeSchedule.endTime) {
        error = @"结束时间不能早于开始时间";
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

- (void)createTimeSchedule:(PMTimeSchedule*)timeSchedule
{
    __weak PMTimeScheduleEditViewController *pSelf = self;
    [[PMServerWrapper defaultServer] createTimeSchedule:timeSchedule success:^(PMTimeSchedule *timeSchedule) {
        dispatch_async(dispatch_get_main_queue(), ^{
            pSelf.timeSchedule = timeSchedule;
            MBProgressHUD *toast = [self getSimpleToastWithTitle:@"成功" message:@"你已成功添加时间"];
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

- (void)updateTimeSchedule:(PMTimeSchedule*)timeSchedule
{
    __weak PMTimeScheduleEditViewController *pSelf = self;
    [[PMServerWrapper defaultServer] updateTimeSchedule:timeSchedule success:^(PMTimeSchedule *timeSchedule) {
        dispatch_async(dispatch_get_main_queue(), ^{
            pSelf.timeSchedule = timeSchedule;
            MBProgressHUD *toast = [self getSimpleToastWithTitle:@"成功" message:@"你已更新添加时间"];
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
@end
