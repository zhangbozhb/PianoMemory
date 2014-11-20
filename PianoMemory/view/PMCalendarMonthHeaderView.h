//
//  PMCalendarMonthHeaderView.h
//  PianoMemory
//
//  Created by 张 波 on 14/11/18.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMCalendarMonthHeaderView : UICollectionReusableView
@property (nonatomic) CGFloat titleHeight;
@property (nonatomic) CGFloat dayLabelHeight;

@property (nonatomic) UIColor *workDayColor;
@property (nonatomic) UIColor *weekEndColor;
@property (nonatomic) UILabel *masterLabel;
@end
