//
//  PMCalendarMonthHeaderView.m
//  PianoMemory
//
//  Created by 张 波 on 14/11/18.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCalendarMonthHeaderView.h"

@interface PMCalendarMonthHeaderView ()

@property (weak, nonatomic) UILabel *day1OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day2OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day3OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day4OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day5OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day6OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day7OfTheWeekLabel;
@end

@implementation PMCalendarMonthHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (CGFloat)dayLabelHeight
{
    if (_dayLabelHeight < FLT_EPSILON) {
        return 20.f;
    }
    return _dayLabelHeight;
}

- (CGFloat)dayLabelWidth
{
    if (_dayLabelWidth < FLT_EPSILON) {
        return 40.f;
    }
    return _dayLabelWidth;
}

- (UIColor *)wordDayColor
{
    if (!_wordDayColor) {
        _wordDayColor = [UIColor colorWithRed:26/256.0  green:168/256.0 blue:186/256.0 alpha:1];
    }
    return _wordDayColor;
}

- (UIColor *)weekEndColor
{
    if (!_weekEndColor) {
        _weekEndColor = [UIColor redColor];
    }
    return _weekEndColor;
}

- (void)setup
{

    self.clipsToBounds = YES;

    //月份
    UILabel *masterLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 10.0f, 300.0f, 30.f)];
    [masterLabel setBackgroundColor:[UIColor clearColor]];
    [masterLabel setTextAlignment:NSTextAlignmentCenter];
    [masterLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0f]];
    self.masterLabel = masterLabel;
    self.masterLabel.textColor = self.wordDayColor;
    [self addSubview:self.masterLabel];

    CGFloat xOffset = 5.0f;
    CGFloat yOffset = 45.0f;

    //一，二，三，四，五，六，日
    UILabel *dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, self.dayLabelWidth, self.dayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day1OfTheWeekLabel = dayOfTheWeekLabel;
    self.day1OfTheWeekLabel.textAlignment = NSTextAlignmentCenter;
    self.day1OfTheWeekLabel.textColor = self.weekEndColor;
    [self addSubview:self.day1OfTheWeekLabel];

    xOffset += self.dayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, self.dayLabelWidth, self.dayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day2OfTheWeekLabel = dayOfTheWeekLabel;
    self.day2OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day2OfTheWeekLabel.textColor = self.wordDayColor;
    [self addSubview:self.day2OfTheWeekLabel];

    xOffset += self.dayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, self.dayLabelWidth, self.dayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day3OfTheWeekLabel = dayOfTheWeekLabel;
    self.day3OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day3OfTheWeekLabel.textColor = self.wordDayColor;
    [self addSubview:self.day3OfTheWeekLabel];

    xOffset += self.dayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, self.dayLabelWidth, self.dayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day4OfTheWeekLabel = dayOfTheWeekLabel;
    self.day4OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day4OfTheWeekLabel.textColor = self.wordDayColor;
    [self addSubview:self.day4OfTheWeekLabel];

    xOffset += self.dayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, self.dayLabelWidth, self.dayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day5OfTheWeekLabel = dayOfTheWeekLabel;
    self.day5OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day5OfTheWeekLabel.textColor = self.wordDayColor;
    [self addSubview:self.day5OfTheWeekLabel];

    xOffset += self.dayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, self.dayLabelWidth, self.dayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day6OfTheWeekLabel = dayOfTheWeekLabel;
    self.day6OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day6OfTheWeekLabel.textColor = self.wordDayColor;
    [self addSubview:self.day6OfTheWeekLabel];

    xOffset += self.dayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, self.dayLabelWidth, self.dayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day7OfTheWeekLabel = dayOfTheWeekLabel;
    self.day7OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day7OfTheWeekLabel.textColor = self.weekEndColor;
    [self addSubview:self.day7OfTheWeekLabel];

    [self updateWithDayNames:@[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]];

}


//设置 @"日", @"一", @"二", @"三", @"四", @"五", @"六"
- (void)updateWithDayNames:(NSArray *)dayNames
{
    for (int i = 0 ; i < dayNames.count; i++) {
        switch (i) {
            case 0:
                self.day1OfTheWeekLabel.text = dayNames[i];
                break;

            case 1:
                self.day2OfTheWeekLabel.text = dayNames[i];
                break;

            case 2:
                self.day3OfTheWeekLabel.text = dayNames[i];
                break;

            case 3:
                self.day4OfTheWeekLabel.text = dayNames[i];
                break;

            case 4:
                self.day5OfTheWeekLabel.text = dayNames[i];
                break;

            case 5:
                self.day6OfTheWeekLabel.text = dayNames[i];
                break;

            case 6:
                self.day7OfTheWeekLabel.text = dayNames[i];
                break;

            default:
                break;
        }
    }
}
@end
