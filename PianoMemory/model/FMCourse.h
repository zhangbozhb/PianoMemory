//
//  FMCourse.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "FMObject.h"
#import <CoreGraphics/CGBase.h>

@interface FMCourse : FMObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *briefDescription;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger startDayTime;
@property (nonatomic) NSInteger endDayTime;
@property (nonatomic) CGFloat price;
@end
