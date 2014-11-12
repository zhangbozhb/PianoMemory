//
//  UITabBar+Extend.m
//  FM1017
//
//  Created by 张 波 on 14-9-19.
//  Copyright (c) 2014年 palm4fun. All rights reserved.
//

#import "UITabBar+Extend.h"
#import "UIDevice+Extend.h"

@implementation UITabBar (Extend)

- (void)zb_setTabBarColor:(UIColor *)color
{
    if ([UIDevice zb_systemVersion7Latter]) {
        [self setBarTintColor:color];
    } else {
        [self setTintColor:color];
    }
}
@end
