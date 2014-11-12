//
//  UINavigationController+Extend.m
//  Utils
//
//  Created by 张 波 on 14-9-5.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "UINavigationController+Extend.h"
#import "UIDevice+Extend.h"

@implementation UINavigationController (Extend)

- (void)zb_hideBottomLine
{
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
}
@end
