//
//  PMDayReportView.h
//  PianoMemory
//
//  Created by 张 波 on 14/11/3.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MagicPie/MagicPieLayer.h>

@interface PMDayReportView : UIView
@property (nonatomic, copy) void(^elemTapped)(PieElement*);
@property (nonatomic,readonly,retain) PieLayer *layer;

- (void)updateWithWeekDayStat:(NSArray*)weekDayStats;
@end
