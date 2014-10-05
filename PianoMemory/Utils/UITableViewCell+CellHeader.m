//
//  UITableViewCell+CellHeader.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-4.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "UITableViewCell+CellHeader.h"

@implementation UITableViewCell (CellHeader)

- (void)adjustUIAsHeader
{

}

+ (id)cellHeaderView
{
    NSString *className = [self description];
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    for (id view in xib) {
        if ([view isKindOfClass:[self class]]) {
            [view adjustUIAsHeader];
            return view;
        }
    }
    return nil;
}

@end
