//
//  UITabBarItem+Extend.h
//  FM1017
//
//  Created by 张 波 on 14-9-22.
//  Copyright (c) 2014年 palm4fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (Extend)

/**
 *	@brief	设置图片
 *
 *	@param 	image 	为选中图片
 *	@param 	selectedImage 	选中时候图片
 *	@param 	originImage 	是否显示原图
 */
- (void)zb_setImage:(UIImage*)image selectedImage:(UIImage*)selectedImage originImage:(BOOL)originImage;

@end
