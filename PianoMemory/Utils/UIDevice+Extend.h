//
//  UIDevice+Extend.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-29.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Extend)

+ (CGFloat)zb_systemVersion;

+ (BOOL)zb_systemVersion5Before;
+ (BOOL)zb_systemVersion5Latter;
+ (BOOL)zb_systemVersion6Latter;
+ (BOOL)zb_systemVersion7Latter;
+ (BOOL)zb_systemVersion8Latter;
@end
