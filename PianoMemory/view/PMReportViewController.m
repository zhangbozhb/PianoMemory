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

@interface PMReportViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) NSArray *weekDayStatArray;
@property (nonatomic) PMWeekDayStat *totalDayStat;

//xib reference
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *anchorView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *myContentView;

@property (weak, nonatomic) IBOutlet PMDayReportView *chartViewContainer;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end


@implementation PMReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadCurrentMonthData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.weekDayStatArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (indexPath.row < [self.weekDayStatArray count]) {
        PMWeekDayStat *dayStat = [self.weekDayStatArray objectAtIndex:indexPath.row];
        [cell.textLabel setText:[PMCourseScheduleRepeat displayTextOfRepeatWeekDay:dayStat.repeatWeekday]];
        CGFloat averageHour = (0 != dayStat.courseCount)? dayStat.durationInHour/dayStat.courseCount:0.f;
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld节\t课时:%.2f\t平均时长:%.2f",
                                       (long)dayStat.courseCount, dayStat.durationInHour,averageHour]];
    } else {
        [cell.textLabel setText:@"总计"];
        CGFloat averageHour = (0 != self.totalDayStat.courseCount)? self.totalDayStat.durationInHour/self.totalDayStat.courseCount:0.f;
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld节\t课时:%.2f\t平均时长:%.2f",
                                       (long)self.totalDayStat.courseCount, self.totalDayStat.durationInHour,averageHour]];

    }
    return cell;
}


- (void)loadCurrentMonthData
{
    NSDate *currentDate = [NSDate date];
    NSDictionary *params = @{@"starttime":[[NSNumber numberWithLong:
                                            [currentDate zb_getMonthTimestamp]] stringValue],
                             @"endtime":[[NSNumber numberWithLong:
                                          [[currentDate zb_dateafterMonth:1] zb_getMonthTimestamp]] stringValue]};
    [[PMServerWrapper defaultServer] queryDayCourseSchedules:params success:^(NSArray *array) {
        [self refreshUIWithDayCourseSchedules:array];
    } failure:^(HCErrorMessage *error) {

    }];
}



- (void)refreshUIWithDayCourseSchedules:(NSArray*)dayCourseSchedules;
{
    NSArray *weekDayStats = [self createWeekDayReportFromDayCourseSchedules:dayCourseSchedules];

    [self.chartViewContainer updateWithWeekDayStat:weekDayStats];

    PMWeekDayStat *totalStat = [[PMWeekDayStat alloc] init];
    for (PMWeekDayStat *weekDayStat in weekDayStats) {
        totalStat.courseCount += weekDayStat.courseCount;
        totalStat.durationInHour += weekDayStat.durationInHour;
    }
    self.weekDayStatArray = weekDayStats;
    self.totalDayStat = totalStat;

    [self.myTableView reloadData];
}

- (NSArray*)createWeekDayReportFromDayCourseSchedules:(NSArray*)dayCourseSchedules
{
    NSMutableDictionary *weekDayReportDictionary = [NSMutableDictionary dictionaryWithCapacity:7];
    for (NSInteger index = 0; index < 7; ++index) {
        PMWeekDayStat *weekDayStat = [[PMWeekDayStat alloc] init];
        PMCourseScheduleRepeatDataWeekDay repeateWeekDay = [PMCourseScheduleRepeat repeatWeekDayFromDayIndexInWeek:index];
        weekDayStat.repeatWeekday = repeateWeekDay;
        weekDayStat.courseCount = 0;
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
    return [[weekDayReportDictionary allValues] sortedArrayUsingDescriptors:[PMWeekDayStat sortDescriptors:NO]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.myTableView reloadData];
}

@end
