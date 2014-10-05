//
//  HCUtils.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-5-7.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HCUtils : NSObject

+ (NSString *)uuid:(BOOL)shouldCreate;

+ (NSString *)getStringWithWidth:(NSString*)string witdh:(CGFloat)width fontSize:(CGFloat)fontSize;

+ (NSString *)getNumberStringFromString:(NSString *)content fromLeft:(BOOL)fromLeft;

+ (UIView *)copyImageView:(UIView *)view;
@end
