//
//  UIViewController+DataUpdate.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-5-26.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "UIViewController+DataUpdate.h"
#import "PMDataUpdate.h"

@implementation UIViewController (DataUpdate)


- (void)registerForDataUpdate
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataUpdated:) name:kPianoMemoryLocalDataUpdatedNotification object:nil];
}

- (void)unRegisterForDataUpdate
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPianoMemoryLocalDataUpdatedNotification object:nil];
}

- (void)handleDataUpdated:(NSNotification *)notification {
}

@end
