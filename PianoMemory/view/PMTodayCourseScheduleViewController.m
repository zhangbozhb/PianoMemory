//
//  PMTodayCourseScheduleViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-5.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMTodayCourseScheduleViewController.h"
#import "PMCourseScheduleTableViewCell.h"
#import "PMCourseSchedule.h"
#import "NSDate+Extend.h"

static NSString *const courseScheduleTableViewCellReuseIdentifier = @"PMCourseScheduleTableViewCellReuseIdentifier";

@interface PMTodayCourseScheduleViewController () <UITableViewDataSource, UITableViewDataSource>

@property (nonatomic) UITableViewCellEditingStyle studentEditingStyle;
@property (nonatomic) NSMutableArray *courseScheduleArray;

@end

@implementation PMTodayCourseScheduleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *courseSchedules = [NSMutableArray array];
    NSInteger starTime = [[NSDate date] timeIntervalSince1970] - 3600 *10;
    for (NSInteger index = 0; index < 12; ++index) {
        PMCourseSchedule *courseSchedule = [[PMCourseSchedule alloc] init];
        courseSchedule.startTime = starTime;
        courseSchedule.endTime = starTime + 1600;
        [courseSchedules addObject:courseSchedule];

        starTime += (index+1) * 1000;
    }
    self.courseScheduleArray = courseSchedules;
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
    [cell refreshUI];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.studentEditingStyle != UITableViewCellEditingStyleInsert) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [self.courseScheduleArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
