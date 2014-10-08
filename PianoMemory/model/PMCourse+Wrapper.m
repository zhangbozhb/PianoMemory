//
//  PMCourse+Wrapper.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-7.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCourse+Wrapper.h"
#import "NSDate+Extend.h"

@implementation PMCourse (Wrapper)
- (NSString*)getStartTimeWithFormatterString:(NSString*)formatterString
{
    if (!formatterString) {
        formatterString = @"HH:mm";
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatterString];
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] zb_getDayTimestamp]+self.startTime];
    return [dateFormatter stringFromDate:targetDate];
}

- (NSString*)getEndTimeWithFormatterString:(NSString*)formatterString
{
    if (!formatterString) {
        formatterString = @"HH:mm";
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatterString];
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] zb_getDayTimestamp]+self.endTime];
    return [dateFormatter stringFromDate:targetDate];
}
@end
