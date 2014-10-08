//
//  PMDayCourseScheduleViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-5.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMDayCourseScheduleViewController.h"
#import "PMCourseScheduleTableViewCell.h"
#import "PMCourseSchedule.h"
#import "NSDate+Extend.h"
#import "UIViewController+DataUpdate.h"
#import "PMDateUpdte.h"
#import "PMServerWrapper.h"
#import "PMDayCourseSchedule.h"
#import "FMWeekCalendarView.h"

static NSString *const courseScheduleTableViewCellReuseIdentifier = @"PMCourseScheduleTableViewCellReuseIdentifier";

@interface PMDayCourseScheduleViewController () <UITableViewDataSource, UITableViewDataSource, FMWeekCalendarViewDelegate>

@property (nonatomic) NSDate *targetDate;
@property (nonatomic) PMDayCourseSchedule *targeDayCourseSchedule;
@property (nonatomic) BOOL shouldFetchData;

//xib reference
@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationitem;
@property (weak, nonatomic) IBOutlet FMWeekCalendarView *weekCalendarView;
@property (weak, nonatomic) IBOutlet UITableView *courseScheduleTableView;

@end

@implementation PMDayCourseScheduleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForDataUpdate];
    self.shouldFetchData = YES;
    self.targetDate = [NSDate date];
    [self.weekCalendarView setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCustomerData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.targeDayCourseSchedule.courseSchedules count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMCourseScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:courseScheduleTableViewCellReuseIdentifier];
    PMCourseSchedule *courseSchedule = [self.targeDayCourseSchedule.courseSchedules objectAtIndex:indexPath.row];
    [cell setCourseSchedule:courseSchedule];
    [cell refreshUI];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [self.targeDayCourseSchedule.courseSchedules removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma delegate FMWeekCalendarViewDelegate
- (void)weekCalendarView:(FMWeekCalendarView *)weekCalendarView selectedDate:(NSDate *)selectedDate
{
    if ([self.targetDate zb_getDayTimestamp] != [selectedDate zb_getDayTimestamp]) {
        self.targetDate = selectedDate;
        self.shouldFetchData = YES;
        [self loadCustomerData];
    }
}

#pragma ui and customer data
- (void)loadCustomerData
{
    if (self.shouldFetchData) {
        __weak PMDayCourseScheduleViewController *pSelf = self;
        [[PMServerWrapper defaultServer] queryDayCourseScheduleOfDate:self.targetDate success:^(PMDayCourseSchedule *dayCourseSchedule) {
            pSelf.targeDayCourseSchedule = dayCourseSchedule;
            [pSelf refreshUI];
            pSelf.shouldFetchData = NO;
        } failure:^(HCErrorMessage *error) {
        }];
    }
}

- (void)refreshUI
{
    if ([self.targetDate zb_getDayTimestamp] == [[NSDate date] zb_getDayTimestamp]) {
        [self.myNavigationitem setTitle:@"今日课程"];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M月d日课程"];
        [self.myNavigationitem setTitle:[dateFormatter stringFromDate:self.targetDate]];
    }
    [self.courseScheduleTableView reloadData];
}

@end
