//
//  PMCourseScheduleViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14/10/29.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCourseScheduleViewController.h"
#import "PMCourseScheduleEditViewController.h"
#import "PMCourseScheduleTableViewCell.h"
#import "PMServerWrapper.h"

#import "PMDataUpdate.h"
#import "UIViewController+DataUpdate.h"
#import <MBProgressHUD/MBProgressHUD.h>


static NSString *const courseScheduleTableViewCellReuseIdentifier = @"courseScheduleTableViewCellReuseIdentifier";

@interface PMCourseScheduleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSMutableArray *courseScheduleArray;
@property (nonatomic) BOOL shouldFetchData;

//xib referrence
@property (weak, nonatomic) IBOutlet UITableView *courseScheduleTableView;
@end

@implementation PMCourseScheduleViewController


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
    return [self.courseScheduleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMCourseScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:courseScheduleTableViewCellReuseIdentifier];
    PMCourseSchedule *courseSchedule = [self.courseScheduleArray objectAtIndex:indexPath.row];
    [cell setCourseSchedule:courseSchedule];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        __weak PMCourseScheduleViewController *pSelf = self;
        [self deleteCourseSchedule:[self.courseScheduleArray objectAtIndex:indexPath.row]
                       finishBlock:^{
            [pSelf.courseScheduleArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

#pragma ui and customer data
- (void)loadCustomerData
{
    if (self.shouldFetchData) {
        __weak PMCourseScheduleViewController *pSelf = self;
        [[PMServerWrapper defaultServer] queryAllCourseSchedules:^(NSArray *array) {
            dispatch_async(dispatch_get_main_queue(), ^{
                pSelf.courseScheduleArray = [NSMutableArray arrayWithArray:array];
                [pSelf refreshUI];
                pSelf.shouldFetchData = NO;
            });
        } failure:^(HCErrorMessage *error) {
        }];
    }
}

- (void)refreshUI
{
    [self.courseScheduleTableView reloadData];
}


- (void)deleteCourseSchedule:(PMCourseSchedule*)courseSchedule finishBlock:(void (^)(void))finishBlock
{
    __weak PMCourseScheduleViewController *pSelf = self;
    [[PMServerWrapper defaultServer] deleteCourseSchedule:courseSchedule success:^(PMCourseSchedule *courseSchedule) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *toast = [pSelf getSimpleToastWithTitle:@"成功" message:@"已经成功删除课程安排"];
            [toast showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [toast removeFromSuperview];
                if (finishBlock) {
                    finishBlock();
                }
            }];
        });
    } failure:^(HCErrorMessage *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *toast = [pSelf getSimpleToastWithTitle:@"失败" message:[error errorMessage]];
            [toast showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [toast removeFromSuperview];
                if (finishBlock) {
                    finishBlock();
                }
            }];
        });
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
    if (PMLocalServer_DataUpateType_CourseSchedule == [PMDataUpdate dataUpdateType:notification.object] ||
        PMLocalServer_DataUpateType_ALL == [PMDataUpdate dataUpdateType:notification.object]) {
        self.shouldFetchData = YES;
    }
}

#pragma segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addCourseScheduleSegueIdentifier"]) {
        PMCourseScheduleEditViewController *addCourseScheduleVC = (PMCourseScheduleEditViewController*)segue.destinationViewController;
        [addCourseScheduleVC setCourseSchedule:nil];
    } else if ([segue.identifier isEqualToString:@"editCourseScheduleSegueIdentifier"]) {
        PMCourseScheduleEditViewController *editCourseScheduleVC = (PMCourseScheduleEditViewController*)segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.courseScheduleTableView indexPathForSelectedRow];
        if (selectedIndexPath && selectedIndexPath.row < [self.courseScheduleArray count]) {
            [editCourseScheduleVC setCourseSchedule:[self.courseScheduleArray objectAtIndex:selectedIndexPath.row]];
        } else {
            [editCourseScheduleVC setCourseSchedule:nil];
        }
    }
}

@end
