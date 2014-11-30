//
//  PMCalendarDayModel.h
//  PianoMemory
//
//  Created by 张 波 on 14/11/18.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CollectionViewCellDayType) {
    CellDayTypeEmpty,   //不显示
    CellDayTypePast,    //过去的日期
    CellDayTypeFutur,   //将来的日期
    CellDayTypeWeek,    //周末
    CellDayTypeClick    //被点击的日期
};

@interface PMCalendarDayModel : NSObject
@property (nonatomic) CollectionViewCellDayType style;//显示的样式
@property (nonatomic, readonly) NSDate *date;
@property (nonatomic) NSString *holiday;            //节日
@property (nonatomic, readonly) NSString *lunaDayString;      //农历日
@property (nonatomic, readonly) NSString *lunaMonthString;    //农历月
@property (nonatomic, readonly) NSString *lunaYearString;    //农历年

@property (nonatomic, readonly) NSUInteger day;         //天
@property (nonatomic, readonly) NSUInteger month;       //月
@property (nonatomic, readonly) NSUInteger year;        //年
@property (nonatomic, readonly) NSUInteger week;        //周
@property (nonatomic, readonly) NSUInteger lunaDay;     //农历天
@property (nonatomic, readonly) NSUInteger lunaMonth;   //农历月
@property (nonatomic, readonly) NSUInteger lunaYear;    //农历年(甲子,...)


- (instancetype)initWithDate:(NSDate*)date;
@end
