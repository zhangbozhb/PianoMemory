//
//  PMStudentBrowseViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMStudentBrowseViewController.h"
#import "PMStudent.h"
#import "PMStudentBrowseTableViewCell.h"
#import "PMManualAddStudentUIViewController.h"

static NSString *const studentBrowseTableViewCellReuseIdentifier = @"PMStudentBrowseTableViewCelReuseIdentifier";


@interface PMStudentBrowseViewController () <UITableViewDataSource, UITableViewDelegate,
                                            UISearchBarDelegate>
@property (nonatomic) UITableViewCellEditingStyle studentEditingStyle;
@property (nonatomic) NSMutableArray *studentArray;

//xib reference
@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationItem;
@property (weak, nonatomic) IBOutlet UITableView *studentsTableView;

@property (weak, nonatomic) IBOutlet UIView *addContactViewContainer;
@end

@implementation PMStudentBrowseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchDisplayController.searchResultsTableView setFrame:self.studentsTableView.frame];
    NSMutableArray *students = [NSMutableArray array];
    for (NSInteger index = 0; index < 20; ++index) {
        PMStudent *student = [[PMStudent alloc] init];
        student.name = @"测试名";
        student.phone = [NSString stringWithFormat:@"电话%10ld", (long)index];
        [students addObject:student];
    }
    self.studentArray = students;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideAddContactView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self hideAddContactView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.studentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMStudentBrowseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studentBrowseTableViewCellReuseIdentifier];
    PMStudent *student = [self.studentArray objectAtIndex:indexPath.row];
    [cell setStudent:student];
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
        [self.studentArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (IBAction)performEditAction:(id)sender {
    self.studentEditingStyle = UITableViewCellEditingStyleDelete;
    [self.studentsTableView setEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *students = [NSMutableArray array];
    NSInteger mokeNumber = 10 - searchText.length;
    for (NSInteger index = 0; index < mokeNumber; ++index) {
        PMStudent *student = [[PMStudent alloc] init];
        student.name = @"测试名";
        student.phone = [NSString stringWithFormat:@"电话%10ld", (long)index];
        [students addObject:student];
    }
    self.studentArray = students;
    [self.studentsTableView reloadData];
}

#pragma add contact
- (IBAction)addContactFromContactsAction:(id)sender {

}

- (void)hideAddContactView
{
    [self.addContactViewContainer setHidden:YES];
}

- (IBAction)performAddAction:(id)sender {
    if (self.addContactViewContainer.hidden) {
        self.addContactViewContainer.hidden = NO;
    } else {
        self.addContactViewContainer.hidden = YES;
    }
}

#pragma mark - Segue support

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"contactManualAdd"]) {
        [self hideAddContactView];
    }
}
@end
