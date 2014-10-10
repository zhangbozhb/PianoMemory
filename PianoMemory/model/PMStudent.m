//
//  PMStudent.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMStudent.h"

@implementation PMStudent

- (id)copyWithZone:(NSZone *)zone
{
    PMStudent *another = [super copyWithZone:zone];
    another.name = [self.name copy];
    another.nameShortcut = [self.nameShortcut copy];
    another.phone = [self.phone copy];
    another.qq = [self.qq copy];
    another.email = [self.email copy];
    another.level = [self.level copy];
    another.briefDescription = [self.briefDescription copy];
    return another;
}

- (NSString *)syncCreateLocalId
{
    return [NSString stringWithFormat:@"com.traveljoin.PianoMemory.%@", self.phone];
}
@end
