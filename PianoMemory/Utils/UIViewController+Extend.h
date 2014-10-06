//
//  UIViewController+Extend.h
//  Utils
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extend)
//保留 navigationbar 位置
- (void)zb_keepNavigationBarSpace:(BOOL)keep;
@end
