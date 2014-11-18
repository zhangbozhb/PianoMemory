//
//  PMCalendarView.m
//  PianoMemory
//
//  Created by 张 波 on 14/11/18.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMCalendarView.h"
#import "PMCalendarMonthCollectionViewLayout.h"
#import "PMCalendarMonthHeaderView.h"
#import "PMCalendarDayCell.h"
#import "PMCalendarDayModel.h"
#import "NSDate+Extend.h"


static NSString *MonthHeader = @"MonthHeaderView";
static NSString *DayCell = @"DayCell";

@interface PMCalendarView () <UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic ,strong) UICollectionView* collectionView;//网格视图
@property(nonatomic ,strong) NSMutableArray *calendarMonth;//每个月份的中的daymodel容器数组
@end

@implementation PMCalendarView
#pragma override property
- (NSDate *)minVisiableDate
{
    if (!_minVisiableDate) {
        _minVisiableDate = [[NSDate date] zb_dateAfterYear:-1];
    }
    return _minVisiableDate;
}

- (NSDate *)maxVisiableDate
{
    if (!_maxVisiableDate) {
        _maxVisiableDate = [[NSDate date] zb_dateAfterYear:1];
    }
    return _maxVisiableDate;
}

- (NSDate *)seletedDate
{
    if (!_seletedDate) {
        _seletedDate = [NSDate date];
    }
    return _seletedDate;
}

#pragma common functions
- (NSArray *)calendarMonthFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate
{
    return nil;
}

#pragma init
- (void)commonInit
{
    self.calendarMonth = [[NSMutableArray alloc]init];//每个月份的数组
    PMCalendarMonthCollectionViewLayout *layout = [PMCalendarMonthCollectionViewLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout]; //初始化网格视图大小
    [self.collectionView registerClass:[PMCalendarDayCell class] forCellWithReuseIdentifier:DayCell];//cell重用设置ID
    [self.collectionView registerClass:[PMCalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    //    self.collectionView.bounces = NO;//将网格视图的下拉效果关闭
    self.collectionView.delegate = self;//实现网格视图的delegate
    self.collectionView.dataSource = self;//实现网格视图的dataSource
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
}


#pragma mark - CollectionView代理方法
//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.calendarMonth.count;
}


//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:section];

    return monthArray.count;
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PMCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:indexPath.section];
    PMCalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        PMCalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%d年 %d月",2014,8];//@"日期";
        monthHeader.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        reusableview = monthHeader;
    }
    return reusableview;

}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    PMCalendarDayModel *model = [month_Array objectAtIndex:indexPath.row];
    if (model.style == CellDayTypeFutur || model.style == CellDayTypeWeek ||model.style == CellDayTypeClick) {

        if (self.delegate
            && [self.delegate respondsToSelector:@selector(calendarView:selectDate:)]) {
            [self.delegate calendarView:self selectDate:model.date];
        }
        [self.collectionView reloadData];
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
