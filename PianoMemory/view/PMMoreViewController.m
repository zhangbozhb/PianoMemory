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
    self.menuArray = [NSArray arrayWithObjects:@"课程管理", nil];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

@end
