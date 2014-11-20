//
//  PMCalendarDayCell.m
//  PianoMemory
//
//  Created by 张 波 on 14/11/18.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCalendarDayCell.h"

@implementation PMCalendarDayCell
#pragma override property
- (UIColor *)workDayColor
{
    if (!_workDayColor) {
        _workDayColor = [UIColor colorWithRed:26/256.0  green:168/256.0 blue:186/256.0 alpha:1];
    }
    return _workDayColor;
}

- (UIColor *)weekEndColor
{
    if (!_weekEndColor) {
        _weekEndColor = [UIColor redColor];
    }
    return _weekEndColor;
}

- (UIColor *)futureDayColor
{
    if (!_futureDayColor) {
        _futureDayColor = [UIColor colorWithRed:26/256.0  green:168/256.0 blue:186/256.0 alpha:1];
    }
    return _futureDayColor;
}


#pragma other function
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    //选中时显示的图片
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];

    //日期
    _dayLabel = [[UILabel alloc]init];
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    _dayLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_dayLabel];

    //农历
    _dayTitleLabel = [[UILabel alloc] init];
    _dayTitleLabel.textColor = [UIColor lightGrayColor];
    _dayTitleLabel.font = [UIFont boldSystemFontOfSize:10];
    _dayTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_dayTitleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageView setFrame:CGRectMake(5, 15, self.bounds.size.width-10, self.bounds.size.width-10)];
    [self.dayLabel setFrame:CGRectMake(0, 15, self.bounds.size.width, self.bounds.size.width-10)];
    [self.dayTitleLabel setFrame:CGRectMake(0, self.bounds.size.height-15, self.bounds.size.width, 13)];
}
@end
