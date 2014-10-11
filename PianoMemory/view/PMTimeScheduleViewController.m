//
//  PMTimeScheduleViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-11.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMTimeScheduleViewController.h"
#import "PMTimeSchedule+Wrapper.h"
#import "PMServerWrapper.h"
#import "PMCourseEditViewController.h"
#import "PMTimeScheduleEditViewController.h"

#import "PMDateUpdte.h"
#import "UIViewController+DataUpdate.h"
#import <MBProgressHUD/MBProgressHUD.h>


static NSString *const timeScheduleTableViewCellReuseIdentifier = @"timeScheduleTableViewCellReuseIdentifier";

@interface PMTimeScheduleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *timeScheduleArray;
@property (nonatomic) BOOL shouldFetchData;

//xib referrence
@property (weak, nonatomic) IBOutlet UITableView *timeScheduleTableView;
@end

@implementation PMTimeScheduleViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForDataUpdate];
    self.shouldFetchData = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCustomerData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.timeScheduleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timeScheduleTableViewCellReuseIdentifier];
    PMTimeSchedule *timeSchedule = [self.timeScheduleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [timeSchedule getNotNilName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ -- %@",
                                 [timeSchedule getStartTimeWithTimeFormatter:nil],
                                 [timeSchedule getEndTimeWithTimeFormatter:nil]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
        PMTimeSchedule *toDeleteTimeSchedule = [self.timeScheduleArray objectAtIndex:indexPath.row];
        [self deleteTimeSchedule:toDeleteTimeSchedule];
    }
}

#pragma ui and customer data
- (void)loadCustomerData
{
    if (self.shouldFetchData) {
        __weak PMTimeScheduleViewController *pSelf = self;
        [[PMServerWrapper defaultServer] queryAllTimeSchedules:^(NSArray *array) {
            pSelf.timeScheduleArray = [NSMutableArray arrayWithArray:array];
            [pSelf refreshUI];
            pSelf.shouldFetchData = NO;
        } failure:^(HCErrorMessage *error) {
        }];
    }
}

- (void)refreshUI
{
    [self.timeScheduleTableView reloadData];
}


- (void)deleteTimeSchedule:(PMTimeSchedule*)timeSchedule
{
    __weak PMTimeScheduleViewController *pSelf = self;
    [[PMServerWrapper defaultServer] deleteTimeSchedule:timeSchedule success:^(PMTimeSchedule *timeSchedule) {
        MBProgressHUD *toast = [pSelf getSimpleToastWithTitle:@"成功" message:@"已经成功删除时间段"];
        [toast showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [toast removeFromSuperview];
        }];
    } failure:^(HCErrorMessage *error) {
        MBProgressHUD *toast = [pSelf getSimpleToastWithTitle:@"失败" message:[error errorMessage]];
        [toast showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [toast removeFromSuperview];
        }];
    }];
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

#pragma data update
- (void)handleDataUpdated:(NSNotification *)notification
{
    [super handleDataUpdated:notification];
    if (PMLocalServer_DateUpateType_TimeSchedule == [PMDateUpdte dateUpdateType:notification.object] ||
        PMLocalServer_DateUpateType_ALL == [PMDateUpdte dateUpdateType:notification.object]) {
        self.shouldFetchData = YES;
        [self loadCustomerData];
    }
}

#pragma segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addTimeScheduleSegueIdentifier"]) {
        PMTimeScheduleEditViewController *addTimeScheduleVC = (PMTimeScheduleEditViewController*)segue.destinationViewController;
        [addTimeScheduleVC setTimeSchedule:nil];
    } else if ([segue.identifier isEqualToString:@"editTimeScheduleSegueIdentifier"]) {
        PMTimeScheduleEditViewController *editTimeScheduleVC = (PMTimeScheduleEditViewController*)segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.timeScheduleTableView indexPathForSelectedRow];
        if (selectedIndexPath && selectedIndexPath.row < [self.timeScheduleArray count]) {
            [editTimeScheduleVC setTimeSchedule:[self.timeScheduleArray objectAtIndex:selectedIndexPath.row]];
        } else {
            [editTimeScheduleVC setTimeSchedule:nil];
        }
    }
}
@end
