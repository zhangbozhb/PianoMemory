//
//  PMTimeSchedulePickerViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14/10/20.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMTimeSchedulePickerViewController.h"
#import "PMServerWrapper.h"
#import "PMTimeScheduleEditViewController.h"

static NSString *const timeSchedulePickerTableViewCellReuseIdentifier = @"timeSchedulePickerTableViewCellReuseIdentifier";

@interface PMTimeSchedulePickerViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSMutableArray *timeScheduleArray;

//xib reference
@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationItem;
@property (weak, nonatomic) IBOutlet UITableView *studentsTableView;
@end

@implementation PMTimeSchedulePickerViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCustomerData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self loadCustomerData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.timeScheduleArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timeSchedulePickerTableViewCellReuseIdentifier];
    if (indexPath.row < [self.timeScheduleArray count]) {
        PMTimeSchedule *timeSchedule = [self.timeScheduleArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [timeSchedule getNotNilName];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ -- %@",
                                     [timeSchedule getStartTimeWithTimeFormatter:nil],
                                     [timeSchedule getEndTimeWithTimeFormatter:nil]];
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell.imageView setImage:[UIImage imageNamed:@"btn_add_green"]];
        [cell.textLabel setText:@"添加新的时间安排"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.timeScheduleArray count]) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(timeSchedulePicker:timeSchedule:)]) {
            PMTimeSchedule *timeSchedule = [self.timeScheduleArray objectAtIndex:indexPath.row];
            [self.delegate timeSchedulePicker:self timeSchedule:timeSchedule];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self performSegueWithIdentifier:@"pickerAddTimeScheduleSegueIdentifier" sender:self];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
}

- (IBAction)cancelPickTimeScheduleAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loadCustomerData
{
    __weak PMTimeSchedulePickerViewController *pSelf = self;
    [[PMServerWrapper defaultServer] queryAllTimeSchedules:^(NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            pSelf.timeScheduleArray = [NSMutableArray arrayWithArray:array];
            [pSelf refreshUI];
        });
    } failure:^(HCErrorMessage *error) {
    }];
}

- (void)refreshUI
{
    [self.studentsTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pickerAddTimeScheduleSegueIdentifier"]) {
        PMTimeScheduleEditViewController *timeScheduleEditVC = (PMTimeScheduleEditViewController*)segue.destinationViewController;
        [timeScheduleEditVC setTimeSchedule:nil];
    }

}



@end
