//
//  PMDayScheduleCalendarViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14/11/20.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMDayScheduleCalendarViewController.h"
#import "PMCalendarView.h"
#import "PMDayCourseScheduleViewController.h"
#import "PMDataUpdate.h"
#import "UIViewController+DataUpdate.h"

@interface PMDayScheduleCalendarViewController () <PMCalendarViewDelegate>
@property (nonatomic) NSDate *selectedDate;
//xib referrence
@property (weak, nonatomic) IBOutlet PMCalendarView *calendarView;
@end

@implementation PMDayScheduleCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.calendarView.delegate = self;
    [self.navigationItem setTitle:@"课程日历"];
    [self registerForDataUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma delegate PMCalendarViewDelegate
- (void)calendarView:(PMCalendarView *)calendarView selectDate:(NSDate *)selectDate
{
    self.selectedDate = selectDate;
    [self performSegueWithIdentifier:@"dayScheduleShowDayCourseScheduleSugeIdentifier" sender:self];
}


#pragma data update
- (void)handleDataUpdated:(NSNotification *)notification
{
    [super handleDataUpdated:notification];
    if (PMLocalServer_DataUpateType_Student == [PMDataUpdate dataUpdateType:notification.object] ||
        PMLocalServer_DataUpateType_ALL == [PMDataUpdate dataUpdateType:notification.object]) {
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"dayScheduleShowDayCourseScheduleSugeIdentifier"]) {
        PMDayCourseScheduleViewController *dayScheduleVC = (PMDayCourseScheduleViewController*)segue.destinationViewController;
        [dayScheduleVC setTargetDate:self.selectedDate];
    }
}
@end
