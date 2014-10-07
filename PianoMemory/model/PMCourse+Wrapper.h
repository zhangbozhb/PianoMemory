//
//  PMCourse+Wrapper.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-7.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCourse.h"

@interface PMCourse (Wrapper)
- (NSString*)getStartTimeWithFormatterString:(NSString*)formatterString;
- (NSString*)getEndTimeWithFormatterString:(NSString*)formatterString;
@end
