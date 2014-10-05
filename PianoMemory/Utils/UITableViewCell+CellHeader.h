//
//  UITableViewCell+CellHeader.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-7-4.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (CellHeader)
- (void)adjustUIAsHeader;
+ (id)cellHeaderView;
@end
