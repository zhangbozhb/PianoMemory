//
//  ZBStyleUtils.h
//  Utils
//
//  Created by 张 波 on 14-4-9.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZBStyleUtils : NSObject

//裁剪 corner
+ (void)clipCornerToView:(UIView*)toView cornerRadius:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)corners;
//添加边框
+ (void)addBorderToView:(UIView*)toView borderWith:(CGFloat)borderWith borderColor:(UIColor*)borderColor  cornerRadius:(CGFloat)cornerRadius;
//添加阴影
+ (BOOL)addShadowToView:(UIView*)toView shadowOffset:(CGSize)shadowOffset opacity:(CGFloat)opacity cornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor*)shadowColor;
//返回只一个指定颜色，size 的 image
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
//绘制直线
+ (void)drawLineInContext:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(CGColorRef)color lineWidth:(CGFloat)lineWidth;
//绘制不连续直线
+ (void)drawDashLineInContext:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint length:(CGFloat)length space:(CGFloat)space color:(CGColorRef)color lineWidth:(CGFloat)lineWidth;
//绘制连续折线
+ (void)drawLinesInContext:(CGContextRef)context points:(NSArray *)points color:(CGColorRef)color lineWidth:(CGFloat) lineWidth isClose:(BOOL)isClose;
+ (void)drawLinesInContext2:(CGContextRef)context points:(NSArray *)points color:(CGColorRef)color lineWidth:(CGFloat) lineWidth isClose:(BOOL)isClose;
//绘制多边形
+ (void)drawPolygonInContext:(CGContextRef)context points:(NSArray *)points color:(CGColorRef)color;
//绘制柱状图
+ (void)drawBarGraph:(CGContextRef)context frame:(CGRect)frame fillColor:(CGColorRef)fillColor;

//检验path 是否包含 point
+ (BOOL)containsPoint:(CGPoint)point onPath:(UIBezierPath *)path inFillArea:(BOOL)inFill;

@end
