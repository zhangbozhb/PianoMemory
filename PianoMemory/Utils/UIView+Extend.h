//
//  UIView+Extend.h
//  Utils
//
//  Created by 张 波 on 14-3-28.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extend)
+ (UIImage *)zb_createImageWithColor:(UIColor *)color ofSize:(CGSize)Size;

- (UIImage *)zb_screenshot:(BOOL)visibleOnly;

#pragma customer styles drawing
//裁剪 corner
- (void)zb_clipCorner:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)corners;
//添加边框
- (void)zb_addBorder:(CGFloat)borderWith borderColor:(UIColor*)borderColor cornerRadius:(CGFloat)cornerRadius;
//添加阴影
- (BOOL)zb_addShadow:(CGSize)shadowOffset opacity:(CGFloat)opacity cornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor*)shadowColor;
@end
