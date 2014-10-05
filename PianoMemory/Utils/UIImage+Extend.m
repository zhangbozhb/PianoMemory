//
//  UIImage+Extend.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-8-3.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "UIImage+Extend.h"

@implementation UIImage (Extend)

- (UIImage*)zb_scaledToSize:(CGSize)toSize
{
    NSInteger height = self.size.height * toSize.width/self.size.width;
    NSInteger width = toSize.width;
    if (height > toSize.height) {
        height = toSize.height;
        width = self.size.width * toSize.height/self.size.height;
    }
    UIGraphicsBeginImageContext(toSize);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}
@end
