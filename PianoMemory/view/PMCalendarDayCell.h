//
//  PMCalendarDayCell.h
//  PianoMemory
//
//  Created by 张 波 on 14/11/18.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMCalendarDayCell : UICollectionViewCell
@property (nonatomic, readonly) UILabel *dayLabel;          //今天的日期或者是节日
@property (nonatomic, readonly) UILabel *dayTitleLabel;     //显示标签
@property (nonatomic, readonly) UIImageView *imageView;       //选中时的图片

@property (nonatomic) UIColor *workDayColor;
@property (nonatomic) UIColor *weekEndColor;
@property (nonatomic) UIColor *futureDayColor;
@end
