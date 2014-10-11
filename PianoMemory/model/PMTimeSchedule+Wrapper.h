//
//  PMTimeSchedule+Wrapper.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-11.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMTimeSchedule.h"

@interface PMTimeSchedule (Wrapper)
- (NSString *)getNotNilName;
- (NSString *)defaultDateTimeFormat;
- (NSString *)getStartTimeWithTimeFormatter:(NSString*)dateFormatString;
- (NSString *)getEndTimeWithTimeFormatter:(NSString*)dateFormatString;
@end
