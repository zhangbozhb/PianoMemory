//
//  UINavigationItem+iOS7.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-3.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "UINavigationItem+iOS7.h"
#import "UIDevice+Extend.h"

@implementation UINavigationItem (iOS7)

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    if ([UIDevice zb_systemVersion7Latter]) {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -16; //ios6 -6px
        if (leftBarButtonItem) {
            [self setLeftBarButtonItems:@[negativeSeperator, leftBarButtonItem]];
        } else {
            [self setLeftBarButtonItems:@[negativeSeperator]];
        }
    } else {
        [self setLeftBarButtonItem:leftBarButtonItem animated:NO];
    }
}

//- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
//{
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negativeSeperator.width = -16; //ios6 -6px
//        if (rightBarButtonItem) {
//            [self setRightBarButtonItems:@[negativeSeperator, rightBarButtonItem]];
//        } else {
//            [self setRightBarButtonItems:@[negativeSeperator]];
//        }
//    } else {
//        [self setRightBarButtonItem:rightBarButtonItem animated:NO];
//    }
//}


@end
