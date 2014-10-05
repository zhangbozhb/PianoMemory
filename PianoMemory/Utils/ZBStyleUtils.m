//
//  ZBStyleUtils.m
//  Utils
//
//  Created by 张 波 on 14-4-9.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "ZBStyleUtils.h"

@implementation ZBStyleUtils


//裁剪 corner
+ (void)clipCornerToView:(UIView*)toView cornerRadius:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:toView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = toView.bounds;
    maskLayer.path = maskPath.CGPath;
    toView.layer.mask = maskLayer;
}

//添加边框
+ (void)addBorderToView:(UIView*)toView borderWith:(CGFloat)borderWith borderColor:(UIColor*)borderColor cornerRadius:(CGFloat)cornerRadius
{
    toView.layer.borderWidth = borderWith;
    toView.layer.borderColor = borderColor.CGColor;
    if (cornerRadius > 0.f) {
        toView.layer.cornerRadius = cornerRadius;
        toView.layer.masksToBounds = YES;
    }
}

//添加阴影
+ (BOOL)addShadowToView:(UIView*)toView shadowOffset:(CGSize)shadowOffset opacity:(CGFloat)opacity cornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor*)shadowColor
{
    BOOL isSucceed = YES;
    CGPathRef shadowPath = [UIBezierPath bezierPathWithRoundedRect:toView.bounds cornerRadius:cornerRadius].CGPath;
    UIView *parentView = [toView superview];
    if (parentView) {
        CGRect shadowFrame = toView.frame;
        shadowFrame.origin.x += shadowOffset.width;
        shadowFrame.origin.y += shadowOffset.height;

        CALayer *shadowLayer = [[CALayer alloc] init];
        [shadowLayer setFrame:shadowFrame];
        shadowLayer.shadowColor = shadowColor.CGColor;
        shadowLayer.shadowPath = shadowPath;
        shadowLayer.shadowOpacity = opacity;
        [parentView.layer insertSublayer:shadowLayer below:toView.layer];
    } else {
        if (cornerRadius > 0.0f) {
            isSucceed = NO;
        } else {
            toView.layer.shadowColor = shadowColor.CGColor;
            toView.layer.shadowPath = shadowPath;
            toView.layer.shadowOpacity = opacity;
        }
    }
    return isSucceed;
}

//返回只一个指定颜色，size 的 image
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

//绘制直线
+ (void)drawLineInContext:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(CGColorRef)color lineWidth:(CGFloat)lineWidth
{
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, lineWidth);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

//绘制不连续直线
+ (void)drawDashLineInContext:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint length:(CGFloat)length space:(CGFloat)space color:(CGColorRef)color lineWidth:(CGFloat)lineWidth
{
    CGContextSaveGState(context);
    CGFloat dashes[] = { length, space };
    CGContextSetLineDash(context, 0.f, dashes, 2);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, lineWidth);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

//绘制连续折线
+ (void)drawLinesInContext:(CGContextRef)context points:(NSArray *)points color:(CGColorRef)color lineWidth:(CGFloat) lineWidth isClose:(BOOL)isClose
{
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, lineWidth);
    for(int i = 0; i < points.count; ++i)
    {
        NSValue *pointVal = points[i];
        CGPoint point = [pointVal CGPointValue];
        if(0 == i)
            CGContextMoveToPoint(context, point.x, point.y);
        else
            CGContextAddLineToPoint(context, point.x, point.y);
    }
    if (isClose) {
        CGContextClosePath(context);
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}
+ (void)drawLinesInContext2:(CGContextRef)context points:(NSArray *)points color:(CGColorRef)color lineWidth:(CGFloat) lineWidth isClose:(BOOL)isClose
{
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, lineWidth);

    CGMutablePathRef pathRef = CGPathCreateMutable();
    for(int i = 0; i < points.count; ++i)
    {
        NSValue *pointVal = points[i];
        CGPoint point = [pointVal CGPointValue];
        if(0 == i)
            CGPathMoveToPoint(pathRef, NULL, point.x, point.y);
        else
            CGPathAddLineToPoint(pathRef, NULL, point.x, point.y);
    }
    if (isClose) {
        CGPathCloseSubpath(pathRef);
    }
    CGContextAddPath(context, pathRef);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(pathRef);
    CGContextRestoreGState(context);
}

//绘制多边形
+ (void)drawPolygonInContext:(CGContextRef)context points:(NSArray *)points color:(CGColorRef)color
{
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, color);
    for(int i = 0; i < points.count; ++i)
    {
        NSValue *pointVal = points[i];
        CGPoint point = [pointVal CGPointValue];
        if(0 == i)
            CGContextMoveToPoint(context, point.x, point.y);
        else
            CGContextAddLineToPoint(context, point.x, point.y);
    }
    CGContextClosePath(context);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
}

//绘制柱状图
+ (void)drawBarGraph:(CGContextRef)context frame:(CGRect)frame fillColor:(CGColorRef)fillColor
{
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, fillColor);
    CGContextFillRect(context, frame);
    CGContextRestoreGState(context);
}

//检验path 是否包含 point
+ (BOOL)containsPoint:(CGPoint)point onPath:(UIBezierPath *)path inFillArea:(BOOL)inFill
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef cgPath = path.CGPath;
    BOOL    isHit = NO;

    // Determine the drawing mode to use. Default to detecting hits on the stroked portion of the path.
    CGPathDrawingMode mode = kCGPathStroke;
    if (inFill)    {
        // Look for hits in the fill area of the path instead.
        if (path.usesEvenOddFillRule)
            mode = kCGPathEOFill;
        else
            mode = kCGPathFill;
    }

    // Save the graphics state so that the path can be removed later.
    CGContextSaveGState(context);
    CGContextAddPath(context, cgPath);

    // Do the hit detection.
    isHit = CGContextPathContainsPoint(context, point, mode);

    CGContextRestoreGState(context);
    return isHit;
}

@end
