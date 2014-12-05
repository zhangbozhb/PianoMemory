//
//  PMAppUpdateInfo.m
//  PianoMemory
//
//  Created by 张 波 on 14/12/5.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMAppUpdateInfo.h"

@implementation PMAppUpdateInfo
- (id)copyWithZone:(NSZone *)zone
{
    PMAppUpdateInfo *another = [super copyWithZone:zone];
    another.appVersion = self.appVersion;
    another.buildVersion = self.buildVersion;
    another.update_Url = self.update_Url;
    return another;
}
@end
