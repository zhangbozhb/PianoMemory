//
//  PMTimeSchedule.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-10.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMObject.h"

@interface PMTimeSchedule : PMObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval endTime;

- (BOOL)isValid;
@end
