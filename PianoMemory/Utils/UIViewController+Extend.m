//
//  UIViewController+Extend.m
//  Utils
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "UIViewController+Extend.h"
#import "UIDevice+Extend.h"

@implementation UIViewController (Extend)
- (void)zb_keepNavigationBarSpace:(BOOL)keep
{
    if (keep) {
        if ([UIDevice zb_systemVersion7Latter])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
        }
    }
}

@end
