//
//  PMStudent.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMStudent.h"

@implementation PMStudent

- (NSString *)syncCreateLocalId
{
    return [NSString stringWithFormat:@"com.traveljoin.PianoMemory.%@", self.phone];
}
@end
