//
//  PMObject.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-10.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMObject.h"

@implementation PMObject
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.created = self.updated = [[NSDate date] timeIntervalSince1970];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    PMObject *another = [super copyWithZone:zone];
    another.created = self.created;
    another.updated = self.updated;
    return another;
}

+ (NSArray *)sortDescriptors:(BOOL)ascending
{
    NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                [NSSortDescriptor sortDescriptorWithKey:@"created" ascending:ascending],
                                [NSSortDescriptor sortDescriptorWithKey:@"updated" ascending:ascending], nil];
    return sortDescriptors;
}
@end
