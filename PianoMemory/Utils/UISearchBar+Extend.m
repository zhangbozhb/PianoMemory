//
//  UISearchBar+Extend.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "UISearchBar+Extend.h"
#import "UIDevice+Extend.h"

@implementation UISearchBar (Extend)

- (UIButton *)zb_getCancelButton
{
    UIButton *cancelButton = nil;
    if ([UIDevice zb_systemVersion7Latter]) {
        UIView *topView = self.subviews[0];
        for (UIView *subView in topView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                cancelButton = (UIButton*)subView;
            }
        }
    } else {
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                cancelButton = (UIButton*)subView;
            }
        }
    }
    return cancelButton;
}
@end
