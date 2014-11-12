//
//  UIToolbar+Extend.h
//  Utils
//
//  Created by 张 波 on 14-9-17.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToolbar (Extend)

//设置 tool bar 的颜色
- (void)zb_setToolBarColor:(UIColor *)color;

//隐藏 top hairline（细线）
- (void)zb_hideTopLine;

@end
