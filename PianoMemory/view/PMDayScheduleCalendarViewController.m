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
#import "PMServerWrapper.h"
#import "NSDate+Extend.h"

@interface PMDayScheduleCalendarViewController () <PMCalendarViewDelegate>
@property (nonatomic) BOOL shouldFetchData;
@property (nonatomic) NSDate *selectedDate;
@property (nonatomic) NSMutableDictionary *tipOfDateMapping;
//xib referrence
@property (weak, nonatomic) IBOutlet PMCalendarView *calendarView;
@end

@implementation PMDayScheduleCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.calendarView.delegate = self;
    self.shouldFetchData = YES;
    [self.navigationItem setTitle:@"排课日历"];
    UIBarButtonItem *todayBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"今" style:UIBarButtonItemStylePlain target:self action:@selector(showTodayCalendar)];
    [self.navigationItem setRightBarButtonItem:todayBarButtonItem];
    [self registerForDataUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCustomerData];
}

- (void)showTodayCalendar
{
    [self.calendarView scrollToDate:[NSDate date] animated:YES];
}

#pragma delegate PMCalendarViewDelegate
- (void)calendarView:(PMCalendarView *)calendarView selectDate:(NSDate *)selectDate
{
    self.selectedDate = selectDate;
    [self performSegueWithIdentifier:@"dayScheduleShowDayCourseScheduleSugeIdentifier" sender:self];
}

- (NSString *)calendarView:(PMCalendarView *)calendarView tipOfDate:(NSDate *)date
{
    NSInteger timestamp = [date zb_timestampOfBeginDay];
    return [self.tipOfDateMapping objectForKey:[NSNumber numberWithInteger:timestamp]];
}


#pragma data update
- (void)handleDataUpdated:(NSNotification *)notification
{
    [super handleDataUpdated:notification];
    if (PMLocalServer_DataUpateType_DayCourseSchedule == [PMDataUpdate dataUpdateType:notification.object] ||
        PMLocalServer_DataUpateType_ALL == [PMDataUpdate dataUpdateType:notification.object]) {
        self.shouldFetchData = YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"dayScheduleShowDayCourseScheduleSugeIdentifier"]) {
        PMDayCourseScheduleViewController *dayScheduleVC = (PMDayCourseScheduleViewController*)segue.destinationViewController;
        [dayScheduleVC setTargetDate:self.selectedDate];
    }
}

- (void)refreshUI
{
    [self.calendarView refreshUI];
}

- (void)loadCustomerData
{
    if (!self.shouldFetchData) {
        return;
    }
    //加载最近3个月的排课
    NSDate *currentDate = [NSDate date];
    NSDictionary *params = @{@"starttime":[[NSNumber numberWithLong:
                                            [[currentDate zb_dateAfterMonth:-1] zb_timestampOfBeginMonth]] stringValue],
                             @"endtime":[[NSNumber numberWithLong:
                                          [[currentDate zb_dateAfterMonth:2] zb_timestampOfBeginMonth]] stringValue]};
    __weak PMDayScheduleCalendarViewController *pSelf = self;
    [[PMServerWrapper defaultServer] queryDayCourseSchedules:params success:^(NSArray *array) {
        pSelf.shouldFetchData = NO;
        [pSelf updateTipOfDateMappingWithDayCourseSchedules:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [pSelf refreshUI];
        });
    } failure:^(HCErrorMessage *error) {

    }];
}

- (void)updateTipOfDateMappingWithDayCourseSchedules:(NSArray*)dayCourseSchedules
{
    NSMutableDictionary *tipMapping = [NSMutableDictionary dictionaryWithCapacity:90];
    for (PMDayCourseSchedule *dayCourseSchedule in dayCourseSchedules) {
        NSString *tipMappingValue = [NSString stringWithFormat:@"%ld", (long)[dayCourseSchedule.courseSchedules count]];
        NSInteger scheduleTimestamp = [[NSDate dateWithTimeIntervalSince1970:dayCourseSchedule.scheduleTimestamp] zb_timestampOfBeginDay];
        [tipMapping setObject:tipMappingValue forKey:[NSNumber numberWithInteger:scheduleTimestamp]];
    }
    self.tipOfDateMapping = tipMapping;
}
@end
