//
//  UINavigationBar+Extend.m
//  Utils
//
//  Created by 张 波 on 14-9-17.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "UINavigationBar+Extend.h"
#import "UIDevice+Extend.h"

@implementation UINavigationBar (Extend)

- (void)zb_setNavigationBarColor:(UIColor *)color
{
    if ([UIDevice zb_systemVersion7Latter]) {
        [self setBarTintColor:color];
    } else {
        [self setTintColor:color];
    }
}

- (void)zb_makeNavigationBarTransparent
{
    [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self setTranslucent:YES];
}

- (void)zb_hideBottomLine
{
    if ([UIDevice zb_systemVersion6Latter]) {
        if (nil == [self backgroundImageForBarMetrics:UIBarMetricsDefault]) {
            [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        }
        [self setShadowImage:[[UIImage alloc] init]];
    }
}
@end
