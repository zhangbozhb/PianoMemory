//
//  UIView+ScreenShot.m
//  Utils
//
//  Created by 张 波 on 14-3-28.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "UIView+ScreenShot.h"

@implementation UIView (ScreenShot)

- (UIImage *)zb_screenshot:(BOOL)visibleOnly
{
    UIImage *image = NULL;

    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        if (visibleOnly) {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, [UIScreen mainScreen].scale);
            CGPoint offset = scrollView.contentOffset;
            CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -offset.x, -offset.y);
            [self.layer renderInContext:UIGraphicsGetCurrentContext()];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        } else {
            UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, self.opaque, 0.0);

            CGPoint savedContentOffset = scrollView.contentOffset;
            CGRect savedFrame = scrollView.frame;

            scrollView.contentOffset = CGPointZero;
            scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);

            [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
            image = UIGraphicsGetImageFromCurrentImageContext();

            scrollView.contentOffset = savedContentOffset;
            scrollView.frame = savedFrame;

            UIGraphicsEndImageContext();
        }
    } else {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, [UIScreen mainScreen].scale);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

@end
