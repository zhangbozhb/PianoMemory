//
//  UINavigationItem+iOS7.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-3.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (Extend)
- (void)zb_setLeftBarButtonItemAsIOS6:(UIBarButtonItem *)item;
- (void)zb_setLeftBarButtonItemAsIOS6:(UIBarButtonItem *)item animated:(BOOL)animated;
- (void)zb_setRightBarButtonItemAsIOS6:(UIBarButtonItem *)item;
- (void)zb_setRightBarButtonItemAsIOS6:(UIBarButtonItem *)item animated:(BOOL)animated;
@end
