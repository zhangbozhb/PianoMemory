//
//  UITabBarItem+Extend.m
//  FM1017
//
//  Created by 张 波 on 14-9-22.
//  Copyright (c) 2014年 palm4fun. All rights reserved.
//

#import "UITabBarItem+Extend.h"
#import "UIDevice+Extend.h"

@implementation UITabBarItem (Extend)

- (void)zb_setImage:(UIImage*)image selectedImage:(UIImage*)selectedImage originImage:(BOOL)originImage
{
    if (originImage) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    if ([UIDevice zb_systemVersion7Latter]) {
        [self setImage:image];
        [self setSelectedImage:selectedImage];
    } else {
        [self setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:image];
    }
}
@end
