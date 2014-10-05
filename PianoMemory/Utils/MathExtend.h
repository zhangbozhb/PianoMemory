//
//  MathExtend.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-8-6.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathExtend : NSObject

+ (BOOL)zb_floatEqual:(double)valueA valueB:(double)valueB;
+ (BOOL)zb_floatLesser:(double)valueA valueB:(double)valueB;
+ (BOOL)zb_floatGreater:(double)valueA valueB:(double)valueB;
+ (BOOL)zb_floatLesserEqual:(double)valueA valueB:(double)valueB;
+ (BOOL)zb_floatGreaterEqual:(double)valueA valueB:(double)valueB;
@end
