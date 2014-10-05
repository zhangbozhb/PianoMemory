//
//  UITableViewCell+SelectedView.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-2.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "UITableViewCell+SelectedView.h"

@implementation UITableViewCell (SelectedView)


- (void)setSelectedBackgroundViewWithColor:(UIColor *)color
{
    if (!color) {
        return;
    }

    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:color];
    [self setSelectedBackgroundView:view];
}

- (void)setSelectedBackgroundViewWithImage:(UIImage *)image
{
    if (!image) {
        return;
    }

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [imageView setImage:image];
    [self setSelectedBackgroundView:imageView];
}

@end
