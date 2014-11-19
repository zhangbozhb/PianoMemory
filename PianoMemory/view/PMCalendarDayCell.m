//
//  PMCalendarDayCell.m
//  PianoMemory
//
//  Created by 张 波 on 14/11/18.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCalendarDayCell.h"
#import "PMCalendarDayModel.h"

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
    _imgview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 15, self.bounds.size.width-10, self.bounds.size.width-10)];
    _imgview.image = [UIImage imageNamed:@"chack.png"];
    [self addSubview:_imgview];

    //日期
    _dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.bounds.size.width, self.bounds.size.width-10)];
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    _dayLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_dayLabel];

    //农历
    _dayTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-15, self.bounds.size.width, 13)];
    _dayTitleLabel.textColor = [UIColor lightGrayColor];
    _dayTitleLabel.font = [UIFont boldSystemFontOfSize:10];
    _dayTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_dayTitleLabel];


}


- (void)setModel:(PMCalendarDayModel *)model
{
    switch (model.style) {
        case CellDayTypeEmpty://不显示
            [self hidden_YES];
            break;

        case CellDayTypePast://过去的日期
            [self hidden_NO];

            if (model.holiday) {
                self.dayLabel.text = model.holiday;
            }else{
                self.dayLabel.text = [NSString stringWithFormat:@"%d",model.day];
            }

            self.dayLabel.textColor = [UIColor lightGrayColor];
            self.dayTitleLabel.text = model.Chinese_calendar;
            self.imgview.hidden = YES;
            break;

        case CellDayTypeFutur://将来的日期
            [self hidden_NO];

            if (model.holiday) {
                self.dayLabel.text = model.holiday;
                self.dayLabel.textColor = [UIColor orangeColor];
            }else{
                self.dayLabel.text = [NSString stringWithFormat:@"%d",model.day];
                self.dayLabel.textColor = self.futureDayColor;
            }

            self.dayTitleLabel.text = model.Chinese_calendar;
            self.self.imgview.hidden = YES;
            break;

        case CellDayTypeWeek://周末
            [self hidden_NO];

            if (model.holiday) {
                self.dayLabel.text = model.holiday;
                self.dayLabel.textColor = [UIColor orangeColor];
            }else{
                self.dayLabel.text = [NSString stringWithFormat:@"%d",model.day];
                self.dayLabel.textColor = self.weekEndColor;
            }

            self.dayTitleLabel.text = model.Chinese_calendar;
            self.imgview.hidden = YES;
            break;

        case CellDayTypeClick://被点击的日期
            [self hidden_NO];
            self.dayLabel.text = [NSString stringWithFormat:@"%d",model.day];
            self.dayLabel.textColor = [UIColor whiteColor];
            self.dayTitleLabel.text = model.Chinese_calendar;
            self.imgview.hidden = NO;
            break;

        default:

            break;
    }
}



- (void)hidden_YES{
    self.dayLabel.hidden = YES;
    self.dayTitleLabel.hidden = YES;
    self.self.imgview.hidden = YES;
}


- (void)hidden_NO{
    self.dayLabel.hidden = NO;
    self.dayTitleLabel.hidden = NO;
}
@end
