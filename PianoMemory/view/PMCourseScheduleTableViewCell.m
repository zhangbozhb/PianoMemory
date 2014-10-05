//
//  PMCourseScheduleTableViewCell.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-5.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCourseScheduleTableViewCell.h"

@interface PMCourseScheduleTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;

@end

@implementation PMCourseScheduleTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
}

- (void)refreshUI
{
    NSDateFormatter *dateFormattor = [[NSDateFormatter alloc] init];
    [dateFormattor setDateFormat:@"HH:mm"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.courseSchedule.startTime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:self.courseSchedule.endTime];
    [self.startTimeLabel setText:[dateFormattor stringFromDate:startDate]];
    [self.endTimeLabel setText:[dateFormattor stringFromDate:endDate]];

}
@end
