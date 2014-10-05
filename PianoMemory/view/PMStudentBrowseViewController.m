//
//  PMStudentBrowseViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMStudentBrowseViewController.h"

@interface PMStudentBrowseViewController () <UITableViewDataSource, UITableViewDelegate>


//xib reference
@property (weak, nonatomic) IBOutlet UITableView *studentsTableView;

@end

@implementation PMStudentBrowseViewController


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


@end
