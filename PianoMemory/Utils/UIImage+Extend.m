//
//  UIImage+Extend.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-8-3.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "UIImage+Extend.h"

@implementation UIImage (Extend)

- (UIImage *)zb_LimitMemSized:(CGFloat)maxMemsize
{
    UIImage *image = nil;
    CGFloat bytesPerPixel = 4.0f;   //一个像素占用4 byte
    CGFloat imageMemSize = self.size.width * self.size.height * bytesPerPixel;
    CGFloat maxMemSize = 1024 * 1024 * 8;
    if (imageMemSize > maxMemSize) {
        // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
        // Pass 1.0 to force exact pixel size.
        CGFloat scale = sqrt(maxMemSize / imageMemSize);
        CGSize newSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, [[UIScreen mainScreen] scale]);
        [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else {
        image = [self copy];
    }
    return image;
}



- (UIImage *)zb_scaledToSize:(CGSize)newSize inRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(newSize, YES,[[UIScreen mainScreen] scale]);

    //Draw image in provided rect
    [self drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    //Pop this context
    UIGraphicsEndImageContext();

    return newImage;
}

- (UIImage *)zb_scaledToFitToSize:(CGSize)newSize
{
    //Only scale images down
    if (self.size.width < newSize.width && self.size.height < newSize.height) {
        return [self copy];
    }

    //Determine the scale factors
    CGFloat widthScale = newSize.width/self.size.width;
    CGFloat heightScale = newSize.height/self.size.height;

    CGFloat scaleFactor;

    //The smaller scale factor will scale more (0 < scaleFactor < 1) leaving the other dimension inside the newSize rect
    widthScale < heightScale ? (scaleFactor = widthScale) : (scaleFactor = heightScale);
    CGSize scaledSize = CGSizeMake(self.size.width * scaleFactor, self.size.height * scaleFactor);

    //Scale the image
    return [self zb_scaledToSize:scaledSize inRect:CGRectMake(0.0, 0.0, scaledSize.width, scaledSize.height)];
}

- (UIImage *)zb_scaledToFillToSize:(CGSize)newSize
{
    //Only scale images down
    if (self.size.width < newSize.width && self.size.height < newSize.height) {
        return [self copy];
    }

    //Determine the scale factors
    CGFloat widthScale = newSize.width/self.size.width;
    CGFloat heightScale = newSize.height/self.size.height;

    CGFloat scaleFactor;

    //The larger scale factor will scale less (0 < scaleFactor < 1) leaving the other dimension hanging outside the newSize rect
    widthScale > heightScale ? (scaleFactor = widthScale) : (scaleFactor = heightScale);
    CGSize scaledSize = CGSizeMake(self.size.width * scaleFactor, self.size.height * scaleFactor);

    //Create origin point so that the center of the image falls into the drawing context rect (the origin will have negative component).
    CGPoint imageDrawOrigin = CGPointMake(0, 0);
    widthScale > heightScale ?  (imageDrawOrigin.y = (newSize.height - scaledSize.height) * 0.5) :
    (imageDrawOrigin.x = (newSize.width - scaledSize.width) * 0.5);


    //Create rect where the image will draw
    CGRect imageDrawRect = CGRectMake(imageDrawOrigin.x, imageDrawOrigin.y, scaledSize.width, scaledSize.height);

    //The imageDrawRect is larger than the newSize rect, where the imageDraw origin is located defines what part of
    //the image will fall into the newSize rect.
    return [self zb_scaledToSize:newSize inRect:imageDrawRect];
}
@end
