//
//  PMCourseViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCourseViewController.h"
#import "PMCourseTableViewCell.h"
#import "PMCourse+Wrapper.h"
#import "PMServerWrapper.h"
#import "PMCourseEditViewController.h"

#import "PMDateUpdte.h"
#import "UIViewController+DataUpdate.h"
#import <MBProgressHUD/MBProgressHUD.h>

static NSString *const courseTableViewCellReuseIdentifier = @"PMCourseTableViewCellReuseIdentifier";

@interface PMCourseViewController () <UITableViewDataSource, UITableViewDataSource>

@property (nonatomic) NSArray *courseArray;
@property (nonatomic) BOOL shouldFetchData;

//xib reference
@property (weak, nonatomic) IBOutlet UITableView *courseTableView;

@end

@implementation PMCourseViewController

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
    return [self.courseArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:courseTableViewCellReuseIdentifier];
    PMCourse *course = [self.courseArray objectAtIndex:indexPath.row];
    cell.textLabel.text = (nil!=course.name)?course.name:@"";
    NSString *detailInfo = [NSString stringWithFormat:@"%@ -- %@",
                            [course getStartTimeWithFormatterString:@"HH:mm"],
                            [course getEndTimeWithFormatterString:@"HH:mm"]];
    cell.detailTextLabel.text = detailInfo;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma ui and customer data
- (void)loadCustomerData
{
    if (self.shouldFetchData) {
        __weak PMCourseViewController *pSelf = self;
        [[PMServerWrapper defaultServer] queryCourses:nil success:^(NSArray *array) {
            pSelf.courseArray = [NSMutableArray arrayWithArray:array];
            [pSelf refreshUI];
            pSelf.shouldFetchData = NO;
        } failure:^(HCErrorMessage *error) {
        }];
    }
}

- (void)refreshUI
{
    [self.courseTableView reloadData];
}


- (void)deleteCourse:(PMCourse*)course
{
//    __weak PMCourseViewController *pSelf = self;
//    [[PMServerWrapper defaultServer] deleteStudent:student success:^(PMStudent *student) {
//        MBProgressHUD *toast = [pSelf getSimpleToastWithTitle:@"成功" message:@"已经成功删除学生"];
//        [toast showAnimated:YES whileExecutingBlock:^{
//            sleep(2);
//        } completionBlock:^{
//            [toast removeFromSuperview];
//        }];
//    } failure:^(HCErrorMessage *error) {
//        MBProgressHUD *toast = [pSelf getSimpleToastWithTitle:@"失败" message:[error errorMessage]];
//        [toast showAnimated:YES whileExecutingBlock:^{
//            sleep(2);
//        } completionBlock:^{
//            [toast removeFromSuperview];
//        }];
//    }];
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
    if (PMLocalServer_DateUpateType_Course == [PMDateUpdte dateUpdateType:notification.object] ||
        PMLocalServer_DateUpateType_ALL == [PMDateUpdte dateUpdateType:notification.object]) {
        self.shouldFetchData = YES;
        [self loadCustomerData];
    }
}

#pragma segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addCourseSegueIdentifier"]) {
        PMCourseEditViewController *addCourseVC = (PMCourseEditViewController*)segue.destinationViewController;
        [addCourseVC setCourse:nil];
    } else if ([segue.identifier isEqualToString:@"editCourseSegueIdentifier"]) {
        PMCourseEditViewController *addCourseVC = (PMCourseEditViewController*)segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.courseTableView indexPathForSelectedRow];
        if (selectedIndexPath && selectedIndexPath.row < [self.courseArray count]) {
            [addCourseVC setCourse:[self.courseArray objectAtIndex:selectedIndexPath.row]];
        } else {
            [addCourseVC setCourse:nil];
        }
    }
}
@end
