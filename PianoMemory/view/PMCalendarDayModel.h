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

@property (assign, nonatomic) CollectionViewCellDayType style;//显示的样式

@property (nonatomic, assign) NSUInteger day;//天
@property (nonatomic, assign) NSUInteger month;//月
@property (nonatomic, assign) NSUInteger year;//年
@property (nonatomic, assign) NSUInteger week;//周


- (NSDate *)date;//返回当前天的NSDate对象
- (NSString *)toString;//返回当前天的NSString对象
@end
