//
//  UIToolbar+Extend.m
//  Utils
//
//  Created by 张 波 on 14-9-17.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "UIToolbar+Extend.h"
#import "UIDevice+Extend.h"

@implementation UIToolbar (Extend)

- (void)zb_setToolBarColor:(UIColor *)color
{
    if ([UIDevice zb_systemVersion7Latter]) {
        [self setBarTintColor:color];
    } else {
        [self setTintColor:color];
    }
}

- (void)zb_hideTopLine
{
    [self setClipsToBounds:YES];
}

@end
