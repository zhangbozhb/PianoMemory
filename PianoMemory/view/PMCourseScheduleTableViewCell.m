//
//  PMCourseScheduleTableViewCell.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-5.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCourseScheduleTableViewCell.h"
#import "PMTimeSchedule+Wrapper.h"
#import "PMCourseSchedule+Wrapper.h"

@interface PMCourseScheduleTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;

@end

@implementation PMCourseScheduleTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)refreshUI
{
    NSString *dateFormateString = @"HH:mm";
    PMTimeSchedule *timeSchedule = self.courseSchedule.timeSchedule;
    [self.startTimeLabel setText:[timeSchedule getStartTimeWithTimeFormatter:dateFormateString]];
    [self.endTimeLabel setText:[timeSchedule getEndTimeWithTimeFormatter:dateFormateString]];

    [self.studentNameLabel setText:[self.courseSchedule getNotNilStudentNameWith:@";"]];
    [self.courseNameLabel setText:[self.courseSchedule getNotNilCourseName]];
    if (self.repeatLabel) {
        if (PMCourseScheduleRepeatTypeWeek == self.courseSchedule.repeatType) {
            [self.repeatLabel setHidden:NO];
            NSArray *repeatDays = [self.courseSchedule getRepeatWeekDays];
            NSMutableArray *repeateDayStrings = [NSMutableArray array];
            for (NSNumber *repeatDay in repeatDays) {
                NSInteger repateDayValue = [repeatDay longValue];
                if (PMCourseScheduleRepeatDataWeekDaySunday == repateDayValue) {
                    [repeateDayStrings addObject:@"日"];
                } else if (PMCourseScheduleRepeatDataWeekDayMonday == repateDayValue) {
                    [repeateDayStrings addObject:@"一"];
                } else if (PMCourseScheduleRepeatDataWeekDayTuesday == repateDayValue) {
                    [repeateDayStrings addObject:@"二"];
                } else if (PMCourseScheduleRepeatDataWeekDayWednesday == repateDayValue) {
                    [repeateDayStrings addObject:@"三"];
                } else if (PMCourseScheduleRepeatDataWeekDayThursday == repateDayValue) {
                    [repeateDayStrings addObject:@"四"];
                } else if (PMCourseScheduleRepeatDataWeekDayFriday == repateDayValue) {
                    [repeateDayStrings addObject:@"五"];
                } else if (PMCourseScheduleRepeatDataWeekDayStaturday == repateDayValue) {
                    [repeateDayStrings addObject:@"六"];
                }
            }
            [self.repeatLabel setText:[repeateDayStrings componentsJoinedByString:@","]];
        } else {
            [self.repeatLabel setHidden:YES];
        }
    }
}
@end
