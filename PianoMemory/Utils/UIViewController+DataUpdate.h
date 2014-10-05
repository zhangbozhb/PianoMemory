//
//  UIViewController+DataUpdate.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-5-26.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DataUpdate)

- (void)registerForDataUpdate;
- (void)unRegisterForDataUpdate;
- (void)handleDataUpdated:(NSNotification *)notification;

@end
