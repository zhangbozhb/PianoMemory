//
//  PMCoursePickerViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-9.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCoursePickerViewController.h"
#import "PMCourse+Wrapper.h"
#import "PMServerWrapper.h"

static NSString *const coursePickerTableViewCellReuseIdentifier = @"coursePickerTableViewCellReuseIdentifier";

@interface PMCoursePickerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *courseArray;
//xib referenc
@property (weak, nonatomic) IBOutlet UITableView *courseTableView;
@end

@implementation PMCoursePickerViewController

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:coursePickerTableViewCellReuseIdentifier];
    PMCourse *course = [self.courseArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [course getNotNilName];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(coursePicker:course:)]) {
        PMCourse *course = [self.courseArray objectAtIndex:indexPath.row];
        [self.delegate coursePicker:self course:course];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelCoursePickerAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma ui and customer data
- (void)loadCustomerData
{
    __weak PMCoursePickerViewController *pSelf = self;
    [[PMServerWrapper defaultServer] queryCourses:nil success:^(NSArray *array) {
        pSelf.courseArray = [NSMutableArray arrayWithArray:array];
        [pSelf refreshUI];
    } failure:^(HCErrorMessage *error) {
    }];
}

- (void)refreshUI
{
    [self.courseTableView reloadData];
}
@end
