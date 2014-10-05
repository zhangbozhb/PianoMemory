//
//  UIViewController+Just.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-1.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Just)
//保留 navigationbar 位置
- (void)keepNavigationBarSpace:(BOOL)keep;

//调整 UI
- (void)adjustUI;

//获取 cancelbutton
- (UIButton *)getCancelButtonFromSearchBar:(UISearchBar *)searchBar;
@end
