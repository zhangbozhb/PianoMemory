//
//  UIViewController+WithKeyboardNotification.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-5-26.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "UIViewController+WithKeyboardNotification.h"
#import <objc/runtime.h>

@implementation UIViewController (WithKeyboardNotification)
@dynamic viewOriginFrame;

static char innerDataKey;
- (NSMutableDictionary*)innerData
{
    NSMutableDictionary *innerData = (NSMutableDictionary*)objc_getAssociatedObject(self, &innerDataKey);
    if (nil == innerData) {
        innerData = [NSMutableDictionary dictionary];
        [innerData setObject:[NSValue valueWithCGRect:CGRectZero] forKey:@"viewOriginFrame"];
        objc_setAssociatedObject(self, &innerDataKey , innerData , OBJC_ASSOCIATION_RETAIN);
    }
    return (NSMutableDictionary*)objc_getAssociatedObject(self, &innerDataKey);
}

- (CGRect)viewOriginFrame
{
    return ((NSValue*)[self.innerData objectForKey:@"viewOriginFrame"]).CGRectValue;
}

- (void)setViewOriginFrame:(CGRect)originFrame
{
    [self.innerData setValue:[NSValue valueWithCGRect:originFrame] forKey:@"viewOriginFrame"];
}

- (void)registerForKeyboardNotifications
{
    //register keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDisAppear:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unRegisterForKeyboardNotifications
{
    //un register keyboard notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)handleKeyboardAppear:(NSNotification *)notification
{
    //获取键盘 frame(window)
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //将 frame转化为当前 view 的 frame
    keyboardFrame = [self.view.window convertRect:keyboardFrame fromView:self.view];
    //获取键盘动画time
    CGFloat animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [self handleKeyboardAppear:animationDuration keyboardHeight:keyboardFrame.size.height];
}

- (void)handleKeyboardDisAppear:(NSNotification *)notification {
    //获取键盘动画time
    CGFloat animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //获取键盘 frame(window)
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //将 frame转化为当前 view 的 frame
    keyboardFrame = [self.view.window convertRect:keyboardFrame fromView:self.view];

    [self handleKeyboardDisAppear:animationDuration keyboardHeight:keyboardFrame.size.height];
}

- (void)handleKeyboardAppear:(NSTimeInterval)duration keyboardHeight:(CGFloat)keyboardHeight
{
    [self setViewOriginFrame:self.view.frame];
    CGRect orgFrame = self.view.frame;
    CGRect targetFrame = orgFrame;
    //如果当前 vc 为 rootview，frame 其实是 window 的，所以更具 orientation 来改变
    if ([[[UIApplication sharedApplication] keyWindow] rootViewController] == self) {
        if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
            targetFrame.origin.x -= keyboardHeight;
        } else {
            targetFrame.origin.y -= keyboardHeight;
        }
    } else {
        targetFrame.origin.y -= keyboardHeight;
    }
    if (!CGRectEqualToRect(orgFrame, targetFrame)) {
        [UIView animateWithDuration:duration animations:^{
            [self.view setFrame:targetFrame];
        }];
    }
}

- (void)handleKeyboardDisAppear:(NSTimeInterval)duration keyboardHeight:(CGFloat)keyboardHeight {
    CGRect newFrame = self.viewOriginFrame;
    if (!CGRectEqualToRect(newFrame, CGRectZero)
        &&!CGRectEqualToRect(newFrame, self.view.frame)) {
        [UIView animateWithDuration:duration animations:^{
            [self.view setFrame:newFrame];
        }];
    }
}

@end
