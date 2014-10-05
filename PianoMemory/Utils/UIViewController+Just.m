//
//  UIViewController+Just.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-1.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "UIViewController+Just.h"
#import "UIDevice+Extend.h"

@implementation UIViewController (Just)

- (void)keepNavigationBarSpace:(BOOL)keep
{
    if (keep) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
}

- (void)adjustUI
{

}


- (UIButton *)getCancelButtonFromSearchBar:(UISearchBar *)searchBar
{
    UIButton *cancelButton = nil;
    if ([UIDevice zb_systemVersion7Latter]) {
        UIView *topView = self.searchDisplayController.searchBar.subviews[0];
        for (UIView *subView in topView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                cancelButton = (UIButton*)subView;
            }
        }
    } else {
        for (UIView *subView in searchBar.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                cancelButton = (UIButton*)subView;
            }
        }
    }
    return cancelButton;
}
@end
