//
//  PMStudentPickerViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-9.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMStudentPickerViewController.h"
#import "PMStudent+Wrapper.h"
#import "PMServerWrapper.h"
#import "PMStudentEditViewController.h"

static NSString *const studentPickerTableViewCellReuseIdentifier = @"studentPickerTableViewCellReuseIdentifier";

@interface PMStudentPickerViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSMutableArray *studentArray;

//xib reference
@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationItem;
@property (weak, nonatomic) IBOutlet UITableView *studentsTableView;
@end

@implementation PMStudentPickerViewController


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
    return [self.studentArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studentPickerTableViewCellReuseIdentifier];
    if (indexPath.row < [self.studentArray count]) {
        PMStudent *student = [self.studentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [student getNotNilName];
        cell.detailTextLabel.text = [student getNotNilPhone];
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell.imageView setImage:[UIImage imageNamed:@"btn_add_green"]];
        [cell.textLabel setText:@"添加新的学生"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.studentArray count]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [self performSegueWithIdentifier:@"pickerAddStudentSegueIdentifier" sender:self];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
}

- (IBAction)cancelPickStudentAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmPickAction:(id)sender {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(studentPicker:students:)]) {
        NSArray *selectedIndexPaths = [self.studentsTableView indexPathsForSelectedRows];
        NSMutableArray *pickedStudents = [NSMutableArray array];
        for (NSIndexPath *indexPath in selectedIndexPaths) {
            [pickedStudents addObject:[self.studentArray objectAtIndex:indexPath.row ]];
        }
        [self.delegate studentPicker:self students:pickedStudents];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadCustomerData
{
    __weak PMStudentPickerViewController *pSelf = self;
    [[PMServerWrapper defaultServer] queryStudents:nil success:^(NSArray *array) {
        pSelf.studentArray = [NSMutableArray arrayWithArray:array];
        [pSelf refreshUI];
    } failure:^(HCErrorMessage *error) {
    }];
}

- (void)refreshUI
{
    [self.studentsTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pickerAddStudentSegueIdentifier"]) {
        PMStudentEditViewController *studentEditVC = (PMStudentEditViewController*)segue.destinationViewController;
        [studentEditVC setStudent:nil];
    }

}
@end
