//
//  PMTimeSchedule+Wrapper.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-11.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMTimeSchedule+Wrapper.h"
#import "NSDate+Extend.h"

@implementation PMTimeSchedule (Wrapper)
- (NSString *)getNotNilName
{
    return (nil!=self.name)?self.name:@"";
}

- (NSString *)defaultDateTimeFormat
{
    return @"HH:mm";
}

- (NSString *)getStartTimeWithTimeFormatter:(NSString*)dateFormatString
{
    if (!dateFormatString) {
        dateFormatString = [self defaultDateTimeFormat];
    }
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] zb_timestampOfBeginDay]+self.startTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormatString];
    return [dateFormatter stringFromDate:targetDate];
}

- (NSString *)getEndTimeWithTimeFormatter:(NSString*)dateFormatString
{
    if (!dateFormatString) {
        dateFormatString = [self defaultDateTimeFormat];
    }
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] zb_timestampOfBeginDay]+self.endTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormatString];
    return [dateFormatter stringFromDate:targetDate];
}

@end
