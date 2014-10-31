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

@interface PMReportViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>


//xib reference
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *anchorView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *myContentView;

@property (weak, nonatomic) IBOutlet UIView *chartViewContainer;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end


@implementation PMReportViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self loaddatat];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


- (void)loaddatat
{
    NSDate *currentDate = [NSDate date];
    NSDictionary *params = @{@"starttime":[[NSNumber numberWithLong:
                                            [currentDate zb_getMonthTimestamp]] stringValue],
                             @"endtime":[[NSNumber numberWithLong:
                                          [[currentDate zb_dateafterMonth:1] zb_getMonthTimestamp]] stringValue]};
    [[PMServerWrapper defaultServer] queryDayCourseSchedules:params success:^(NSArray *array) {
        int fff = 4;
    } failure:^(HCErrorMessage *error) {

    }];

}
@end
