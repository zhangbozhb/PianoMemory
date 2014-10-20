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
#import "PMCourseEditViewController.h"

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
    return [self.courseArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:coursePickerTableViewCellReuseIdentifier];
    if (indexPath.row < [self.courseArray count]) {
        PMCourse *course = [self.courseArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [course getNotNilName];
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell.imageView setImage:[UIImage imageNamed:@"btn_add_green"]];
        [cell.textLabel setText:@"添加新的课程"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.courseArray count]) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(coursePicker:course:)]) {
            PMCourse *course = [self.courseArray objectAtIndex:indexPath.row];
            [self.delegate coursePicker:self course:course];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self performSegueWithIdentifier:@"pickerAddCourseSegueIdentifier" sender:self];
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pickerAddCourseSegueIdentifier"]) {
        PMCourseEditViewController *coureEditVC = (PMCourseEditViewController *)segue.destinationViewController;
        [coureEditVC setCourse:nil];
    }
}

@end
