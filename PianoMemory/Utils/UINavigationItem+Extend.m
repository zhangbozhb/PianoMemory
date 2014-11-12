//
//  UINavigationItem+iOS7.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-3.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "UINavigationItem+Extend.h"
#import "UIDevice+Extend.h"

@implementation UINavigationItem (Extend)

- (void)zb_setLeftBarButtonItemAsIOS6:(UIBarButtonItem *)item animated:(BOOL)animated
{
    if ([UIDevice zb_systemVersion7Latter]) {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -16; //ios6 -6px
        if (item) {
            [self setLeftBarButtonItems:@[negativeSeperator, item]];
        } else {
            [self setLeftBarButtonItems:@[negativeSeperator]];
        }
    } else {
        [self setLeftBarButtonItem:item animated:animated];
    }
}

- (void)zb_setLeftBarButtonItemAsIOS6:(UIBarButtonItem *)item
{
    [self zb_setLeftBarButtonItemAsIOS6:item animated:NO];
}

- (void)zb_setRightBarButtonItemAsIOS6:(UIBarButtonItem *)item animated:(BOOL)animated
{
    if ([UIDevice zb_systemVersion7Latter]) {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -16; //ios6 -6px
        if (item) {
            [self setRightBarButtonItems:@[negativeSeperator, item]];
        } else {
            [self setRightBarButtonItems:@[negativeSeperator]];
        }
    } else {
        [self setRightBarButtonItem:item animated:animated];
    }
}

- (void)zb_setRightBarButtonItemAsIOS6:(UIBarButtonItem *)item
{
    [self zb_setRightBarButtonItemAsIOS6:item animated:NO];
}
@end
