//
//  PMNavDayScheduleViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14/11/12.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMNavDayScheduleViewController.h"
#import "UITabBarItem+Extend.h"
#import "PMZoomAnimationTransition.h"
#import "PMDayScheduleCalendarViewController.h"

@interface PMNavDayScheduleViewController () <UINavigationControllerDelegate>
@property (nonatomic) PMZoomAnimationTransition *animator;
@end

@implementation PMNavDayScheduleViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self.tabBarItem zb_setImage:[UIImage imageNamed:@"tab_schedule"]
                   selectedImage:[UIImage imageNamed:@"tab_schedule"]
                     originImage:YES];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PMZoomAnimationTransition *)animator
{
    if (!_animator) {
        _animator = [[PMZoomAnimationTransition alloc] init];
    }
    return _animator;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if ([fromVC isKindOfClass:[PMDayScheduleCalendarViewController class]] &&
        operation == UINavigationControllerOperationPush) {
        return self.animator;
    }
    return nil;
}

@end
