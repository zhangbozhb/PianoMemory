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

- (NSString *)getNotNilName
{
    return (nil!=self.name)?self.name:@"";
}

- (NSString *)getNotNilBriefDescription
{
    return (nil!=self.briefDescription)?self.briefDescription:@"";
}
@end
