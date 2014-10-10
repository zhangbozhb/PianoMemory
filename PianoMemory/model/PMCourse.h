//
//  PMCourse.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMObject.h"
#import <CoreGraphics/CGBase.h>

@interface PMCourse : PMObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *briefDescription;
@property (nonatomic) NSInteger type;
@property (nonatomic) CGFloat price;
@property (nonatomic) CGFloat salary;
@end
