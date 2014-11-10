//
//  PMMoreViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMMoreViewController.h"


static NSString *const menuTableViewCellReuseIdentifier = @"menuTableViewCelReuseIdentifier";

@interface PMMoreViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *menuArray;

//xib reference
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@end

@implementation PMMoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuArray = [NSArray arrayWithObjects:@"课程管理", @"时间管理", @"排课管理", nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuTableViewCellReuseIdentifier];
    [cell.textLabel setText:[self.menuArray objectAtIndex:indexPath.row]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    if (0 == indexPath.row) {
        [cell.imageView setImage:[UIImage imageNamed:@"course_manage"]];
    } else if (1 == indexPath.row) {
        [cell.imageView setImage:[UIImage imageNamed:@"time_manage"]];
    } else if (2 == indexPath.row) {
        [cell.imageView setImage:[UIImage imageNamed:@"schedule_manage"]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        [self performSegueWithIdentifier:@"showMenuCourseSegueIdentifier" sender:self];
    } else if (1 == indexPath.row) {
        [self performSegueWithIdentifier:@"showMenuTimeScheduleSegueIdentifier" sender:self];
    } else if (2 == indexPath.row) {
        [self performSegueWithIdentifier:@"showMenuCourseScheduleSegueIdentifier" sender:self];
    }
}

@end
