//
//  PMReportViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14/10/31.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMReportViewController.h"
#import "PMServerWrapper.h"
#import "NSDate+Extend.h"
#import "PMWeekDayStat.h"
#import "PMDayReportView.h"
#import "UIColor+Extend.h"
#import <MBProgressHUD/MBProgressHUD.h>

static NSString *const reportTableViewCellReuseIdentifier = @"reportTableViewCellReuseIdentifier";

@interface PMReportViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) NSArray *weekDayStatArray;
@property (nonatomic) PMWeekDayStat *totalDayStat;
@property (nonatomic) NSDate *targetMonth;

@property (nonatomic) MBProgressHUD *toast;

//xib reference
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *anchorView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *myContentView;

@property (weak, nonatomic) IBOutlet PMDayReportView *chartViewContainer;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@end

@implementation PMReportViewController
- (NSDate *)targetMonth
{
    if (!_targetMonth) {
        _targetMonth = [NSDate date];
    }
    return _targetMonth;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *currentMonthBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"今" style:UIBarButtonItemStylePlain target:self action:@selector(showCurrentMonthReport)];
    [self.navigationItem setRightBarButtonItem:currentMonthBarButtonItem];

    //添加手势
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadNextMonthData)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadPreviousMonthData)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
}

- (void)showCurrentMonthReport
{
    self.targetMonth = [NSDate date];
    [self loadCustomerData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.targetMonth = nil;
    [self loadCustomerData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.weekDayStatArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[reportTableViewCellReuseIdentifier copy]];
    if (indexPath.row < [self.weekDayStatArray count]) {
        PMWeekDayStat *dayStat = [self.weekDayStatArray objectAtIndex:indexPath.row];
        [cell.textLabel setText:[PMCourseScheduleRepeat displayTextOfRepeatWeekDay:dayStat.repeatWeekday]];
        CGFloat averageHour = (0 != dayStat.courseCount)? dayStat.durationInHour/dayStat.courseCount:0.f;
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld节\t课时:%.2f\t平均时长:%.2f",
                                       (long)dayStat.courseCount, dayStat.durationInHour,averageHour]];
        cell.textLabel.textColor = cell.detailTextLabel.textColor = (dayStat.dayColor)?dayStat.dayColor:[UIColor blackColor];
    } else {
        [cell.textLabel setText:@"总计"];
        CGFloat averageHour = (0 != self.totalDayStat.courseCount)? self.totalDayStat.durationInHour/self.totalDayStat.courseCount:0.f;
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld节\t课时:%.2f\t平均时长:%.2f",
                                       (long)self.totalDayStat.courseCount, self.totalDayStat.durationInHour,averageHour]];
    }
    return cell;
}


- (void)loadCustomerData
{
    NSDictionary *params = @{@"starttime":[[NSNumber numberWithLong:
                                            [self.targetMonth zb_timestampOfMonth]] stringValue],
                             @"endtime":[[NSNumber numberWithLong:
                                          [[self.targetMonth zb_dateAfterMonth:1] zb_timestampOfMonth]] stringValue]};

    __weak PMReportViewController *pSelf = self;
    [[PMServerWrapper defaultServer] queryDayCourseSchedules:params success:^(NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [pSelf hideToast];
            [pSelf updateDatasWithDayCourseSchedules:array];
            [pSelf refreshUI];
        });
    } failure:^(HCErrorMessage *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [pSelf hideToast];
        });
    }];
}

- (void)refreshTitleUI
{
    NSDate *currentDate = [NSDate date];
    NSInteger year = [self.targetMonth zb_getYear], month = [self.targetMonth zb_getMonth];
    if (year == [currentDate zb_getMonth]
        && month == [currentDate zb_getMonth]) {
        [self.navigationItem setTitle:@"本月课时统计"];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YY年MM月"];
        NSString *titleString = [NSString stringWithFormat:@"%@课时统计",
                                 [dateFormatter stringFromDate:self.targetMonth]];
        [self.navigationItem setTitle:titleString];
    }
}

- (void)updateDatasWithDayCourseSchedules:(NSArray*)dayCourseSchedules;
{
    NSArray *weekDayStats = [self createWeekDayReportFromDayCourseSchedules:dayCourseSchedules];
    PMWeekDayStat *totalStat = [[PMWeekDayStat alloc] init];
    for (PMWeekDayStat *weekDayStat in weekDayStats) {
        totalStat.courseCount += weekDayStat.courseCount;
        totalStat.durationInHour += weekDayStat.durationInHour;
    }
    self.weekDayStatArray = weekDayStats;
    self.totalDayStat = totalStat;
}

- (void)refreshUI
{
    [self refreshTitleUI];
    [self.chartViewContainer updateWithWeekDayStat:self.weekDayStatArray];
    [self.totalLabel setText:[NSString stringWithFormat:@"总计:%ld\n时长:%.1f",
                              (long)self.totalDayStat.courseCount,
                              self.totalDayStat.durationInHour]];


    [self.myTableView reloadData];

    CGFloat averageHour = (0 != self.totalDayStat.courseCount)? self.totalDayStat.durationInHour/self.totalDayStat.courseCount:0.f;
    [self.titleLabel setText:[NSString stringWithFormat:@"总计:%ld节\t总课时:%.2f\t平均时长:%.2f",
                              (long)self.totalDayStat.courseCount, self.totalDayStat.durationInHour,averageHour]];
}

- (NSArray*)createWeekDayReportFromDayCourseSchedules:(NSArray*)dayCourseSchedules
{
    NSArray *colorArray = [NSArray arrayWithObjects:@"#C9FFE5", @"#B284BE", @"#5D8AA8",
                           @"#F19CBB", @"#AB274F",@"#ED872D", @"#3B7A57", nil];
    NSMutableDictionary *weekDayReportDictionary = [NSMutableDictionary dictionaryWithCapacity:7];
    for (NSInteger index = 0; index < 7; ++index) {
        PMWeekDayStat *weekDayStat = [[PMWeekDayStat alloc] init];
        PMCourseScheduleRepeatDataWeekDay repeateWeekDay = [PMCourseScheduleRepeat repeatWeekDayFromDayIndexInWeek:index];
        weekDayStat.repeatWeekday = repeateWeekDay;
        weekDayStat.dayColor = [UIColor zb_colorWithHexString:[colorArray objectAtIndex:index]];
        [weekDayReportDictionary setObject:weekDayStat
                                    forKey:[NSNumber numberWithLong:repeateWeekDay]];
    }
    for (PMDayCourseSchedule *dayCourseSchedule in dayCourseSchedules) {
        PMCourseScheduleRepeatDataWeekDay repeateWeekDay = [PMCourseScheduleRepeat repeatWeekDayFromDate:
                                                            [NSDate dateWithTimeIntervalSince1970:dayCourseSchedule.scheduleTimestamp]];
        PMWeekDayStat *weekDayStat = (PMWeekDayStat*)[weekDayReportDictionary objectForKey:
                                                      [NSNumber numberWithLong:repeateWeekDay]];
        if (weekDayStat) {
            for (PMCourseSchedule *courseSchedule in dayCourseSchedule.courseSchedules) {
                weekDayStat.courseCount += 1;
                weekDayStat.durationInHour += (courseSchedule.timeSchedule.endTime - courseSchedule.timeSchedule.startTime)/3600;
            }
        }
    }

    NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                [NSSortDescriptor sortDescriptorWithKey:@"repeatWeekday" ascending:YES], nil];
    return [[weekDayReportDictionary allValues] sortedArrayUsingDescriptors:sortDescriptors];
}

- (void)showLoadDataToast
{
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:toast];
    toast.removeFromSuperViewOnHide = YES;
    toast.mode = MBProgressHUDModeIndeterminate;
    toast.animationType = MBProgressHUDAnimationFade;
    [toast setLabelText:@"正在加载数据..."];
    [toast show:YES];
    self.toast = toast;
}

- (void)hideToast
{
    if (self.toast) {
        [self.toast hide:YES afterDelay:0.3f];
        self.toast = nil;
    }
}

- (void)loadNextMonthData
{
    self.targetMonth = [self.targetMonth zb_dateAfterMonth:1];
    [self showLoadDataToast];
    [self loadCustomerData];
}

- (void)loadPreviousMonthData
{
    self.targetMonth = [self.targetMonth zb_dateAfterMonth:-1];
    [self showLoadDataToast];
    [self loadCustomerData];
}
@end
