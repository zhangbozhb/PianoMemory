//
//  MathExtend.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-8-6.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "MathExtend.h"


@implementation MathExtend
+ (BOOL)zb_floatEqual:(double)valueA valueB:(double)valueB
{
    double diff = valueA - valueB;
    if (fabs(diff) <= FLT_EPSILON) {
        return YES;
    }
    return NO;
}
+ (BOOL)zb_floatLesser:(double)valueA valueB:(double)valueB
{
    double diff = valueA - valueB;
    if (diff < 0 && fabs(diff) > FLT_EPSILON) {
        return YES;
    }
    return NO;
}
+ (BOOL)zb_floatGreater:(double)valueA valueB:(double)valueB
{
    double diff = valueA - valueB;
    if (diff > 0 && fabs(diff) > FLT_EPSILON) {
        return YES;
    }
    return NO;
}
+ (BOOL)zb_floatLesserEqual:(double)valueA valueB:(double)valueB
{
    double diff = valueA - valueB;
    if (diff < 0 || fabs(diff) <= FLT_EPSILON) {
        return YES;
    }
    return NO;
}
+ (BOOL)zb_floatGreaterEqual:(double)valueA valueB:(double)valueB
{
    double diff = valueA - valueB;
    if (diff > 0 || fabs(diff) <= FLT_EPSILON) {
        return YES;
    }
    return NO;
}
@end
