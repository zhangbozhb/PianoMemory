//
//  UIView+Extend.m
//  Utils
//
//  Created by 张 波 on 14-3-28.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "UIView+Extend.h"

@implementation UIView (Extend)

+ (UIImage *)zb_createImageWithColor:(UIColor *)color ofSize:(CGSize)Size
{
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Size.width, Size.height)];
    [tempView setBackgroundColor:color];
    UIGraphicsBeginImageContext(tempView.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [tempView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

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

#pragma customer styles drawing
//裁剪 corner
- (void)zb_clipCorner:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

//添加边框
- (void)zb_addBorder:(CGFloat)borderWith borderColor:(UIColor*)borderColor cornerRadius:(CGFloat)cornerRadius
{
    self.layer.borderWidth = borderWith;
    self.layer.borderColor = borderColor.CGColor;
    if (cornerRadius > 0.f) {
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
    }
}

//添加阴影
- (BOOL)zb_addShadow:(CGSize)shadowOffset opacity:(CGFloat)opacity cornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor*)shadowColor
{
    BOOL isSucceed = YES;
    CGPathRef shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius].CGPath;
    UIView *parentView = [self superview];
    if (parentView) {
        CGRect shadowFrame = self.frame;
        shadowFrame.origin.x += shadowOffset.width;
        shadowFrame.origin.y += shadowOffset.height;

        CALayer *shadowLayer = [[CALayer alloc] init];
        [shadowLayer setFrame:shadowFrame];
        shadowLayer.shadowColor = shadowColor.CGColor;
        shadowLayer.shadowPath = shadowPath;
        shadowLayer.shadowOpacity = opacity;
        [parentView.layer insertSublayer:shadowLayer below:self.layer];
    } else {
        if (cornerRadius > 0.0f) {
            isSucceed = NO;
        } else {
            self.layer.shadowColor = shadowColor.CGColor;
            self.layer.shadowPath = shadowPath;
            self.layer.shadowOpacity = opacity;
        }
    }
    return isSucceed;
}
@end
