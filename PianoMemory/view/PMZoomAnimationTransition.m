//
//  PMZoomAnimationTransition.m
//  PianoMemory
//
//  Created by 张 波 on 14/11/27.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMZoomAnimationTransition.h"
#import <UIKit/UIKit.h>
#import "UIView+ScreenShot.h"

@implementation PMZoomAnimationTransition
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];

    NSInteger systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (7 == systemVersion
        && toViewController.navigationController) {   //iOS 7bug
        CGRect navigationBarFrame = toViewController.navigationController.navigationBar.frame;
        toViewController.view.frame = CGRectMake(0, navigationBarFrame.size.height, toViewController.view.frame.size.width, toViewController.view.frame.size.height - navigationBarFrame.size.height);
    }
    if (self.isZoom) {
        toViewController.view.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
            toViewController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            fromViewController.view.transform = CGAffineTransformIdentity;
            toViewController.view.transform = CGAffineTransformIdentity;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        UIImage *shotImage = (fromViewController.navigationController)?[fromViewController.navigationController.view zb_screenshot:YES]:[fromViewController.view zb_screenshot:YES];
        UIImageView *shotImageView = [[UIImageView alloc] initWithImage:shotImage];
        [shotImageView setFrame:fromViewController.view.frame];
        [[transitionContext containerView] addSubview:shotImageView];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            shotImageView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        } completion:^(BOOL finished) {
            [shotImageView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}
@end
