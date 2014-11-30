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

static NSString *kmonthHeaderReuseIdentifier = @"monthHeaderReuseIdentifier";
static NSString *kdayCellReuseIdentifier = @"dayCellReuseIdentifier";

@interface PMCalendarView () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic) UICollectionView* collectionView;//网格视图
@property (nonatomic) NSMutableDictionary *monthCalendarDaysMapping;
@end

@implementation PMCalendarView
#pragma override property
- (NSDate *)startDate
{
    if (!_startDate) {
        _startDate = [[NSDate date] zb_dateAfterYear:0];
    }
    return _startDate;
}

- (NSDate *)endDate
{
    if (!_endDate) {
        _endDate = [[NSDate date] zb_dateAfterYear:1];
    }
    return _endDate;
}

- (NSDate *)seletedDate
{
    if (!_seletedDate) {
        _seletedDate = [NSDate date];
    }
    return _seletedDate;
}

#pragma init
- (void)commonInit
{
    self.monthCalendarDaysMapping = [NSMutableDictionary dictionary];
    PMCalendarMonthCollectionViewLayout *layout = [PMCalendarMonthCollectionViewLayout new];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                                          collectionViewLayout:layout]; //初始化网格视图大小
    [collectionView registerClass:[PMCalendarDayCell class] forCellWithReuseIdentifier:kdayCellReuseIdentifier];
    [collectionView registerClass:[PMCalendarMonthHeaderView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:kmonthHeaderReuseIdentifier];
    collectionView.bounces = NO;   //将网格视图的下拉效果关闭
    collectionView.delegate = self;    //实现网格视图的delegate
    collectionView.dataSource = self;  //实现网格视图的dataSource
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    [self setBackgroundColor:[UIColor purpleColor]];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma common functions
- (NSArray*)calendarDaysForMonth:(NSDate*)targetMonth
{
    NSArray *dayInPreviousMonth = [self calculateDaysInPreviousMonthWithDate:targetMonth];
    NSArray *dayInCurrentMonth =  [self calculateDaysInCurrentMonthWithDate:targetMonth];
    NSArray *dayInFollowingMonth =  [self calculateDaysInFollowingMonthWithDate:targetMonth];
    NSMutableArray *calendarDays = [[NSMutableArray alloc] init];
    [calendarDays addObjectsFromArray:dayInPreviousMonth];
    [calendarDays addObjectsFromArray:dayInCurrentMonth];
    [calendarDays addObjectsFromArray:dayInFollowingMonth];
    return calendarDays;
}


#pragma mark - 日历上+当前+下月份的天数
//计算上月份的天数
- (NSArray*)calculateDaysInPreviousMonthWithDate:(NSDate *)date
{
    NSDate *firstDayOfCurrentMonth = [date zb_firstDayOfCurrentMonth]; //本月第一天
    NSUInteger weekDay = [firstDayOfCurrentMonth zb_weekDay];//本月第一天是礼拜几
    NSMutableArray *targetArray = [NSMutableArray arrayWithCapacity:weekDay];
    for (NSInteger index = weekDay; index > 1; --index) {
        PMCalendarDayModel *calendarDay = [[PMCalendarDayModel alloc] initWithDate:[firstDayOfCurrentMonth zb_dateAfterDay:-index+1]];
        calendarDay.style = CellDayTypeEmpty;//不显示
        [targetArray addObject:calendarDay];
    };
    return targetArray;
}

//计算当月的天数
- (NSArray*)calculateDaysInCurrentMonthWithDate:(NSDate *)date
{
    NSDate *firstDayOfCurrentMonth = [date zb_firstDayOfCurrentMonth]; //本月第一天
    NSUInteger numberOfDayOfCurrentMonth = [date zb_numberOfDayOfCurrentMonth];
    NSMutableArray *targetArray = [NSMutableArray arrayWithCapacity:numberOfDayOfCurrentMonth];
    for (NSInteger index = 0; index < numberOfDayOfCurrentMonth; ++index) {
        PMCalendarDayModel *calendarDay = [[PMCalendarDayModel alloc] initWithDate:[firstDayOfCurrentMonth zb_dateAfterDay:index]];
        [targetArray addObject:calendarDay];
    };
    return targetArray;
}

//计算下月份的天数
- (NSArray*)calculateDaysInFollowingMonthWithDate:(NSDate *)date
{
    NSDate *lastDayOfCurrentMonth = [[[date zb_dateAfterMonth:1] zb_firstDayOfCurrentMonth] zb_dateAfterDay:-1]; //本月最后一天
    NSUInteger weekDay = [lastDayOfCurrentMonth zb_weekDay];
    NSMutableArray *targetArray = [NSMutableArray arrayWithCapacity:weekDay];
    for (NSInteger index = weekDay; index < 7; ++index) {
        PMCalendarDayModel *calendarDay = [[PMCalendarDayModel alloc] initWithDate:[lastDayOfCurrentMonth zb_dateAfterDay:index-weekDay+1]];
        calendarDay.style = CellDayTypeFutur;
        [targetArray addObject:calendarDay];
    };
    return targetArray;
}

#pragma set modle style
- (void)updateCalendarDayStyle:(PMCalendarDayModel *)calendarDay selectedDate:(NSDate*)selectedDate
{
    NSDate *today = [NSDate date];
    NSDateComponents *calendarToDay = [today zb_dateComponents];    //今天
    NSDateComponents *calendarSelected = [selectedDate zb_dateComponents];
    //选中日期
    if (selectedDate
        && calendarSelected.year == calendarDay.year
        && calendarSelected.month == calendarDay.month
        && calendarSelected.day == calendarDay.day) {
        calendarDay.style = CellDayTypeClick;
    } else {    //没被点击选中
        if (calendarToDay.year > calendarDay.year
            || (calendarToDay.year == calendarDay.year && calendarToDay.month > calendarDay.month)
            || (calendarToDay.year == calendarDay.year && calendarToDay.month == calendarDay.month && calendarToDay.day > calendarDay.day) ) {
            calendarDay.style = CellDayTypePast;
        } else {
            //周末
            if (calendarDay.week == 1 || calendarDay.week == 7){
                calendarDay.style = CellDayTypeWeek;
            }else {  //工作日
                calendarDay.style = CellDayTypeFutur;
            }
        }
    }
    //特殊处理:
    if (calendarToDay.year == calendarDay.year &&
        calendarToDay.month == calendarDay.month &&
        calendarToDay.day == calendarDay.day) {
        calendarDay.holiday = @"今天";
    }else if(calendarToDay.year == calendarDay.year &&
             calendarToDay.month == calendarDay.month &&
             calendarToDay.day == calendarDay.day -1){
        calendarDay.holiday = @"明天";
    }else if(calendarToDay.year == calendarDay.year &&
             calendarToDay.month == calendarDay.month &&
             calendarToDay.day == calendarDay.day -2){
        calendarDay.holiday = @"后天";
    }
}

#pragma mark - CollectionView代理方法
//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSDateComponents *startComponent = [self.startDate zb_dateComponents];
    NSDateComponents *endComponent = [self.endDate zb_dateComponents];
    NSInteger month = (endComponent.year - startComponent.year) * 12 + endComponent.month - startComponent.month;
    return month;
}

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *calendarDays = [self calendarDaysForSection:section];
    return [calendarDays count];
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PMCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kdayCellReuseIdentifier forIndexPath:indexPath];
    NSDate *targetMonth = [self calendarMonthDateForSection:indexPath.section];
    NSArray *calendarDays = [self calendarDaysForSection:indexPath.section];
    PMCalendarDayModel *dayModel = [calendarDays objectAtIndex:indexPath.row];
    [self updateCalendarDayStyle:dayModel selectedDate:self.seletedDate];
    if ([targetMonth zb_getMonth] != dayModel.month) {
        [dayModel setStyle:CellDayTypeEmpty];
    }
    [self refreshCalendarDayCell:cell calendarDayModel:dayModel];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        PMCalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kmonthHeaderReuseIdentifier forIndexPath:indexPath];

        NSDate *targetMonth = [self calendarMonthDateForSection:indexPath.section];
        NSDateComponents *targetComponent = [targetMonth zb_dateComponents];
        [monthHeader.masterLabel setText:[NSString stringWithFormat:@"%ld年 %ld月",
                                          (long)targetComponent.year,
                                          (long)targetComponent.month]];
        reusableview = monthHeader;
    }
    return reusableview;
}

//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *calendarDays = [self calendarDaysForSection:indexPath.section];
    PMCalendarDayModel *model = [calendarDays objectAtIndex:indexPath.row];
    if (CellDayTypeEmpty != model.style) {
        NSMutableArray *targetIndexPathArray = [NSMutableArray arrayWithObject:indexPath];
        NSIndexPath *preSelectedIndexPath = [self selectedIndexOfDate:self.seletedDate];
        if (preSelectedIndexPath &&
            NSOrderedSame != [preSelectedIndexPath compare:indexPath]) {
            [targetIndexPathArray addObject:preSelectedIndexPath];
        }
        self.seletedDate = model.date;
        [collectionView reloadItemsAtIndexPaths:targetIndexPathArray];
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(calendarView:selectDate:)]) {
            [self.delegate calendarView:self selectDate:model.date];
        }
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma other
- (void)refreshCalendarDayCell:(PMCalendarDayCell *)cell calendarDayModel:(PMCalendarDayModel *)calendarDayModel
{
    if (CellDayTypeEmpty == calendarDayModel.style) {
        [cell.dayLabel setHidden:YES];
        [cell.dayTitleLabel setHidden:YES];
        [cell.imageView setHidden:YES];
        [cell.tipLabel setHidden:YES];
    } else {
        [cell.dayLabel setHidden:NO];
        [cell.dayTitleLabel setHidden:NO];
        if (CellDayTypePast == calendarDayModel.style) {
            [cell.dayLabel setTextColor:[UIColor lightGrayColor]];
        } else if (CellDayTypeClick == calendarDayModel.style) {
            [cell.dayLabel setTextColor:[UIColor whiteColor]];
            cell.dayLabel.transform = CGAffineTransformMakeScale(1.2f,1.2f);
        } else if (CellDayTypeWeek == calendarDayModel.style) {
            [cell.dayLabel setTextColor:[UIColor redColor]];
        } else {
            [cell.dayLabel setTextColor:[UIColor colorWithRed:26/256.0  green:168/256.0 blue:186/256.0 alpha:1]];
        }

        if (calendarDayModel.holiday
            && CellDayTypeClick != calendarDayModel.style) {
            [cell.dayLabel setText:calendarDayModel.holiday];
            [cell.dayLabel setTextColor:[UIColor orangeColor]];
        } else {
            [cell.dayLabel setText:[NSString stringWithFormat:@"%ld", (long)calendarDayModel.day]];
        }

        if (calendarDayModel.lunaDayString) {
            [cell.dayTitleLabel setText:calendarDayModel.lunaDayString];
        }

        if (CellDayTypeClick == calendarDayModel.style) {
            [cell.imageView setImage:[UIImage imageNamed:@"calendar_day_selected"]];
            [cell.imageView setHidden:NO];
        } else {
            [cell.imageView setHidden:YES];
        }

        if (self.delegate
            && [self.delegate respondsToSelector:@selector(calendarView:tipOfDate:)]) {
            NSString *tip = [self.delegate calendarView:self tipOfDate:calendarDayModel.date];
            if (tip) {
                [cell.tipLabel setText:tip];
                [cell.tipLabel setHidden:NO];
            } else {
                [cell.tipLabel setHidden:YES];
            }
        }
    }
}

- (NSDate*)calendarMonthDateForSection:(NSInteger)section
{
    return [self.startDate zb_dateAfterMonth:section];
}

- (NSArray*)calendarDaysForSection:(NSInteger)section
{
    NSArray *targetCalendarDays = [self.monthCalendarDaysMapping objectForKey:[NSNumber numberWithInteger:section]];
    if (!targetCalendarDays) {
        NSDate *targetMonth = [self calendarMonthDateForSection:section];
        targetCalendarDays = [self calendarDaysForMonth:targetMonth];
        [self.monthCalendarDaysMapping setObject:targetCalendarDays forKey:[NSNumber numberWithInteger:section]];
    }
    return targetCalendarDays;
}

- (NSIndexPath*)selectedIndexOfDate:(NSDate*)date
{
    NSIndexPath *indexPath = nil;
    if (date) {
        NSDateComponents *dateComponent = [date zb_dateComponents];
        NSDate *firstDayOfCurrentMonth = [date zb_firstDayOfCurrentMonth]; //本月第一天
        NSUInteger weekDay = [firstDayOfCurrentMonth zb_weekDay];//本月第一天是礼拜几
        if (dateComponent.year >= [self.startDate zb_getYear]) {
            NSInteger month = (dateComponent.year-[self.startDate zb_getYear])*12+dateComponent.month-[self.startDate zb_getMonth];
            indexPath = [NSIndexPath indexPathForRow:weekDay+dateComponent.day-2
                                           inSection:month];
        }
    }
    return indexPath;
}

- (void)scrollToDate:(NSDate*)date animated:(BOOL)animated
{
    if (!date) {
        date = (self.seletedDate)?self.seletedDate:[NSDate date];
    }
    NSIndexPath *indexPath = [self selectedIndexOfDate:date];
    if (indexPath) {
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                            animated:animated];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self scrollToDate:nil animated:NO];
}

- (void)refreshUI
{
    [self.collectionView reloadData];
}
@end
