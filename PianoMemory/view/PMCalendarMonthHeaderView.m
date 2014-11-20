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

- (void)setup
{
    self.clipsToBounds = YES;

    //月份
    UILabel *masterLabel = [[UILabel alloc] init];
    [masterLabel setBackgroundColor:[UIColor clearColor]];
    [masterLabel setTextAlignment:NSTextAlignmentCenter];
    [masterLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0f]];
    self.masterLabel = masterLabel;
    self.masterLabel.textColor = self.workDayColor;
    [self addSubview:self.masterLabel];


    UIFont *dayLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
    UIColor *labelBackgroundColor = [UIColor clearColor];
    //日，一，二，三，四，五，六
    UILabel *dayOfTheWeekLabel = [[UILabel alloc] init];
    [dayOfTheWeekLabel setBackgroundColor:labelBackgroundColor];
    [dayOfTheWeekLabel setFont:dayLabelFont];
    dayOfTheWeekLabel.textAlignment = NSTextAlignmentCenter;
    dayOfTheWeekLabel.textColor = self.weekEndColor;
    [self addSubview:dayOfTheWeekLabel];
    self.day1OfTheWeekLabel = dayOfTheWeekLabel;

    dayOfTheWeekLabel = [[UILabel alloc] init];
    [dayOfTheWeekLabel setBackgroundColor:labelBackgroundColor];
    [dayOfTheWeekLabel setFont:dayLabelFont];
    dayOfTheWeekLabel.textAlignment = NSTextAlignmentCenter;
    dayOfTheWeekLabel.textColor = self.workDayColor;
    [self addSubview:dayOfTheWeekLabel];
    self.day2OfTheWeekLabel = dayOfTheWeekLabel;

    dayOfTheWeekLabel = [[UILabel alloc] init];
    [dayOfTheWeekLabel setBackgroundColor:labelBackgroundColor];
    [dayOfTheWeekLabel setFont:dayLabelFont];
    dayOfTheWeekLabel.textAlignment = NSTextAlignmentCenter;
    dayOfTheWeekLabel.textColor = self.workDayColor;
    [self addSubview:dayOfTheWeekLabel];
    self.day3OfTheWeekLabel = dayOfTheWeekLabel;

    dayOfTheWeekLabel = [[UILabel alloc] init];
    [dayOfTheWeekLabel setBackgroundColor:labelBackgroundColor];
    [dayOfTheWeekLabel setFont:dayLabelFont];
    dayOfTheWeekLabel.textAlignment = NSTextAlignmentCenter;
    dayOfTheWeekLabel.textColor = self.workDayColor;
    [self addSubview:dayOfTheWeekLabel];
    self.day4OfTheWeekLabel = dayOfTheWeekLabel;

    dayOfTheWeekLabel = [[UILabel alloc] init];
    [dayOfTheWeekLabel setBackgroundColor:labelBackgroundColor];
    [dayOfTheWeekLabel setFont:dayLabelFont];
    dayOfTheWeekLabel.textAlignment = NSTextAlignmentCenter;
    dayOfTheWeekLabel.textColor = self.workDayColor;
    [self addSubview:dayOfTheWeekLabel];
    self.day5OfTheWeekLabel = dayOfTheWeekLabel;

    dayOfTheWeekLabel = [[UILabel alloc] init];
    [dayOfTheWeekLabel setBackgroundColor:labelBackgroundColor];
    [dayOfTheWeekLabel setFont:dayLabelFont];
    dayOfTheWeekLabel.textAlignment = NSTextAlignmentCenter;
    dayOfTheWeekLabel.textColor = self.workDayColor;
    [self addSubview:dayOfTheWeekLabel];
    self.day6OfTheWeekLabel = dayOfTheWeekLabel;

    dayOfTheWeekLabel = [[UILabel alloc] init];
    [dayOfTheWeekLabel setBackgroundColor:labelBackgroundColor];
    [dayOfTheWeekLabel setFont:dayLabelFont];
    dayOfTheWeekLabel.textAlignment = NSTextAlignmentCenter;
    dayOfTheWeekLabel.textColor = self.weekEndColor;
    [self addSubview:dayOfTheWeekLabel];
    self.day7OfTheWeekLabel = dayOfTheWeekLabel;

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    CGFloat titleHeight = (self.titleHeight < FLT_EPSILON)?floor(frame.size.height*0.6f):self.titleHeight;
    [self.masterLabel setFrame:CGRectMake(0, 0, frame.size.width, titleHeight)];

    NSArray *dayLables = [NSArray arrayWithObjects:self.day1OfTheWeekLabel, self.day2OfTheWeekLabel,
                          self.day3OfTheWeekLabel, self.day4OfTheWeekLabel, self.day5OfTheWeekLabel,
                          self.day6OfTheWeekLabel, self.day7OfTheWeekLabel, nil];
    CGFloat dayWidth = floor(frame.size.width/[dayLables count]);
    CGFloat dayHeight = (self.dayLabelHeight < FLT_EPSILON)?floor(frame.size.height*0.4f):self.dayLabelHeight;
    CGFloat offsetY = 5.f;
    for (NSInteger index = 0, count = [dayLables count]; index < count; ++index) {
        UILabel *targetLabel = [dayLables objectAtIndex:index];
        [targetLabel setFrame:CGRectMake(dayWidth*index, titleHeight+offsetY, dayWidth, dayHeight)];
    }
}
@end
