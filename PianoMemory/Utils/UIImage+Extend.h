//
//  UIImage+Extend.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-8-3.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)

// 返回一个resize后的image
- (UIImage *)zb_LimitMemSized:(CGFloat)maxMemsize;

//将图片缩放到指定的 size
- (UIImage *)zb_scaledToFitToSize:(CGSize)newSize;
- (UIImage *)zb_scaledToFillToSize:(CGSize)newSize;
@end
