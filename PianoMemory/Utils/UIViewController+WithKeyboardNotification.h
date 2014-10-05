//
//  UIViewController+WithKeyboardNotification.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-5-26.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WithKeyboardNotification)
@property (nonatomic) CGRect viewOriginFrame;

- (void)registerForKeyboardNotifications;
- (void)unRegisterForKeyboardNotifications;

- (void)handleKeyboardAppear:(NSTimeInterval)duration keyboardHeight:(CGFloat)keyboardHeight;
- (void)handleKeyboardDisAppear:(NSTimeInterval)duration keyboardHeight:(CGFloat)keyboardHeight;
@end
