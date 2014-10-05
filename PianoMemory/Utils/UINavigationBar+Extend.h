//
//  UINavigationBar+Extend.h
//  Utils
//
//  Created by 张 波 on 14-9-17.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Extend)
//设置 navigation bar 的颜色
- (void)zb_setNavigationBarColor:(UIColor *)color;

//设置 navigation bar 透明
- (void)zb_makeNavigationBarTransparent;

//隐藏底部1px 线条
- (void)zb_hideBottomLine;
@end
