//
//  PMDayReportPieElement.h
//  PianoMemory
//
//  Created by 张 波 on 14/11/4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MagicPie/PieElement.h>
#import "PMWeekDayStat.h"

@interface PMDayReportPieElement : PieElement
@property (nonatomic) PMWeekDayStat *dayStatistics;
@end
