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
@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *holiday;//节日
@property (nonatomic) NSString *lunaCalendar;//农历

@property (nonatomic, readonly) NSUInteger day;//天
@property (nonatomic, readonly) NSUInteger month;//月
@property (nonatomic, readonly) NSUInteger year;//年
@property (nonatomic, readonly) NSUInteger week;//周


- (instancetype)initWithDate:(NSDate*)date;
- (instancetype)initWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;
@end
