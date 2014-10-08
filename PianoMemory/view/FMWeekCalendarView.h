//
//  FMWeekCalendarView.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-5.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMWeekCalendarView;
@protocol FMWeekCalendarViewDelegate <NSObject>

- (void)weekCalendarView:(FMWeekCalendarView *)weekCalendarView selectedDate:(NSDate*)selectedDate;
@end

@interface FMWeekCalendarView : UIView
@property (nonatomic) UIFont *weekTitleFont;
@property (nonatomic) UIFont *weekDayTitleFont;
@property (nonatomic) UIFont *lunaFont;

@property (nonatomic) UIColor *weekTitleColor;
@property (nonatomic) UIColor *weekDayTitleColor;
@property (nonatomic) UIColor *lunaColor;
@property (nonatomic) UIColor *selectedDateColor;
@property (nonatomic) UIColor *currentDateColor;

@property (nonatomic) BOOL showLunar;

@property (nonatomic) NSDate *selectedDate;
@property (nonatomic) UIEdgeInsets contentEdgeInsets;

@property (nonatomic, weak) id<FMWeekCalendarViewDelegate>delegate;
@end
