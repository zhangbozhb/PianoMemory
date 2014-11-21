//
//  PMCalendarView.h
//  PianoMemory
//
//  Created by 张 波 on 14/11/18.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMCalendarView;
@protocol PMCalendarViewDelegate <NSObject>
- (void)calendarView:(PMCalendarView*)calendarView selectDate:(NSDate*)selectDate;
- (NSString*)calendarView:(PMCalendarView*)calendarView tipOfDate:(NSDate*)date;
@end

@interface PMCalendarView : UIView
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSDate *seletedDate;

@property (nonatomic, weak) id<PMCalendarViewDelegate>delegate;

- (void)scrollToDate:(NSDate*)date animated:(BOOL)animated;
- (void)refreshUI;
@end
