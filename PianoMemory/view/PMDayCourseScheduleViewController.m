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
#import "PMDataUpdate.h"
#import "PMServerWrapper.h"
#import "PMDayCourseSchedule.h"
#import "PMCourseScheduleEditViewController.h"
#import "PMDayCourseSchedule+Wrapper.h"

static NSString *const dayCourseScheduleTableViewCellReuseIdentifier = @"dayCourseScheduleTableViewCellReuseIdentifier";

@interface PMDayCourseScheduleViewController () <UITableViewDataSource, UITableViewDelegate, PMCourseScheduleEditProtocol>
@property (nonatomic) PMDayCourseSchedule *targetDayCourseSchedule;
@property (nonatomic) BOOL shouldFetchData;

//xib reference
@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationitem;
@property (weak, nonatomic) IBOutlet UITableView *courseScheduleTableView;

@end

@implementation PMDayCourseScheduleViewController

- (NSDate *)targetDate
{
    if (!_targetDate) {
        _targetDate = [NSDate date];
    }
    return _targetDate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForDataUpdate];
    self.shouldFetchData = YES;
    self.targetDayCourseSchedule = [[PMDayCourseSchedule alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCustomerData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.targetDayCourseSchedule.courseSchedules count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMCourseScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dayCourseScheduleTableViewCellReuseIdentifier];
    PMCourseSchedule *courseSchedule = [self.targetDayCourseSchedule.courseSchedules objectAtIndex:indexPath.row];
    [cell setCourseSchedule:courseSchedule];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell refreshUI];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"dayCourseScheduleShowCourseScheduleSugeIdentifier" sender:self];
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
        [self.targetDayCourseSchedule.courseSchedules removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma delegate PMCourseScheduleEditProtocol
- (void)courseScheduleEdit:(PMCourseScheduleEditViewController *)courseScheduleEdit updateCourseSchedule:(PMCourseSchedule *)courseSchedule indexPath:(NSIndexPath *)indexPath
{
    if (nil == indexPath &&
        [self.targetDayCourseSchedule.courseSchedules count] <= indexPath.row) {
        [self.targetDayCourseSchedule addCourseSchedule:courseSchedule];
    } else {
        [self.targetDayCourseSchedule.courseSchedules replaceObjectAtIndex:indexPath.row withObject:courseSchedule];
    }
    [self saveDayCourseSchedule:self.targetDayCourseSchedule];
}

- (void)saveDayCourseSchedule:(PMDayCourseSchedule *)dayCourseSchedule
{
    __weak PMDayCourseScheduleViewController *pSelf = self;
    [[PMServerWrapper defaultServer] createDayCourseSchedule:dayCourseSchedule success:^(PMDayCourseSchedule *retDayCourseSchedule) {
        pSelf.targetDayCourseSchedule = retDayCourseSchedule;
    } failure:^(HCErrorMessage *error) {
    }];;

}

#pragma ui and customer data
- (void)loadCustomerData
{
    if (self.shouldFetchData) {
        __weak PMDayCourseScheduleViewController *pSelf = self;
        [[PMServerWrapper defaultServer] queryDayCourseScheduleOfDate:self.targetDate success:^(PMDayCourseSchedule *dayCourseSchedule) {
            dispatch_async(dispatch_get_main_queue(), ^{
                pSelf.targetDayCourseSchedule = dayCourseSchedule;
                [pSelf refreshUI];
                pSelf.shouldFetchData = NO;
            });
        } failure:^(HCErrorMessage *error) {
        }];
    }
}

- (void)refreshUI
{
    if ([self.targetDate zb_timestampOfDay] == [[NSDate date] zb_timestampOfDay]) {
        [self.myNavigationitem setTitle:@"今日课程"];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M月d日课程"];
        [self.myNavigationitem setTitle:[dateFormatter stringFromDate:self.targetDate]];
    }
    [self.courseScheduleTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"dayCourseScheduleAddCourseScheduleSugeIdentifier"]) {
        PMCourseScheduleEditViewController *addCourseScheduleVC = (PMCourseScheduleEditViewController*)segue.destinationViewController;
        [addCourseScheduleVC setDelegate:self];
        [addCourseScheduleVC setCourseSchedule:nil];
    } else if ([segue.identifier isEqualToString:@"dayCourseScheduleShowCourseScheduleSugeIdentifier"]) {
        PMCourseScheduleEditViewController *editCourseScheduleVC = (PMCourseScheduleEditViewController*)segue.destinationViewController;
        [editCourseScheduleVC setDelegate:self];
        NSIndexPath *selectedIndexPath = [self.courseScheduleTableView indexPathForSelectedRow];
        if (selectedIndexPath && selectedIndexPath.row < [self.targetDayCourseSchedule.courseSchedules count]) {
            [editCourseScheduleVC setCourseSchedule:[self.targetDayCourseSchedule.courseSchedules objectAtIndex:selectedIndexPath.row]];
        } else {
            [editCourseScheduleVC setCourseSchedule:nil];
        }
    }
}

@end
