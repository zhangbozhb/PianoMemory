//
//  UITableViewCell+SelectedView.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-2.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (SelectedView)
- (void)setSelectedBackgroundViewWithColor:(UIColor *)color;
- (void)setSelectedBackgroundViewWithImage:(UIImage *)image;
@end
