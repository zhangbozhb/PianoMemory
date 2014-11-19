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
#import "LunarCalendar.h"


static NSString *kmonthHeaderReuseIdentifier = @"monthHeaderReuseIdentifier";
static NSString *kdayCellReuseIdentifier = @"dayCellReuseIdentifier";

@interface PMCalendarView () <UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic ,strong) UICollectionView* collectionView;//网格视图
@property(nonatomic ,strong) NSMutableArray *calendarMonth;//每个月份的中的daymodel容器数组
@end

@implementation PMCalendarView
#pragma override property
- (NSDate *)startDate
{
    if (!_startDate) {
        _startDate = [[NSDate date] zb_dateAfterYear:-1];
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

#pragma common functions
- (NSArray *)calendarMonthFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate selectedDate:(NSDate*)selectedDate
{
    NSDateComponents *todayDC= [fromDate zb_dateComponents];
    NSDateComponents *beforeDC= [toDate zb_dateComponents];
    NSInteger todayYear = todayDC.year;
    NSInteger todayMonth = todayDC.month;
    NSInteger beforeYear = beforeDC.year;
    NSInteger beforeMonth = beforeDC.month;

    NSInteger months = (beforeYear-todayYear) * 12 + (beforeMonth - todayMonth);

    NSMutableArray *calendarMonth = [[NSMutableArray alloc] init];//每个月的dayModel数组
    for (int i = 0; i <= months; i++) {
        NSDate *month = [fromDate zb_dateAfterMonth:i];
        NSArray *dayInPreviousMonth = [self calculateDaysInPreviousMonthWithDate:month];
        NSArray *dayInCurrentMonth =  [self calculateDaysInCurrentMonthWithDate:month];
        NSArray *dayInFollowingMonth =  [self calculateDaysInFollowingMonthWithDate:month];//计算下月份的天数

        [self updateCalendarDayStyle:dayInCurrentMonth selectedDate:selectedDate];
        NSMutableArray *calendarDays = [[NSMutableArray alloc] init];
        [calendarDays addObjectsFromArray:dayInPreviousMonth];
        [calendarDays addObjectsFromArray:dayInCurrentMonth];
        [calendarDays addObjectsFromArray:dayInFollowingMonth];
        [calendarMonth addObject:calendarDays];
    }

    return calendarMonth;
}


#pragma mark - 日历上+当前+下月份的天数
//计算上月份的天数
- (NSArray*)calculateDaysInPreviousMonthWithDate:(NSDate *)date
{
    NSDate *firstDayOfCurrentMonthe = [date zb_firstDayOfCurrentMonth]; //本月第一天
    NSUInteger weekDay = [firstDayOfCurrentMonthe zb_weekDay];//本月第一天是礼拜几
    NSMutableArray *targetArray = [NSMutableArray arrayWithCapacity:weekDay];
    for (NSInteger index = weekDay; index > 1; --index) {
        PMCalendarDayModel *calendarDay = [[PMCalendarDayModel alloc] initWithDate:[firstDayOfCurrentMonthe zb_dateAfterDay:-index+1]];
        calendarDay.style = CellDayTypeEmpty;//不显示
        [targetArray addObject:calendarDay];
    };
    return targetArray;
}

//计算当月的天数
- (NSArray*)calculateDaysInCurrentMonthWithDate:(NSDate *)date
{
    NSUInteger numberOfDayOfCurrentMonth = [date zb_numberOfDayOfCurrentMonth]; //本月第一天
    NSMutableArray *targetArray = [NSMutableArray arrayWithCapacity:numberOfDayOfCurrentMonth];
    for (NSInteger index = 0; index < numberOfDayOfCurrentMonth; ++index) {
        PMCalendarDayModel *calendarDay = [[PMCalendarDayModel alloc] initWithDate:[date zb_dateAfterDay:index]];
        [targetArray addObject:calendarDay];
    };
    return targetArray;
}

//计算下月份的天数
- (NSArray*)calculateDaysInFollowingMonthWithDate:(NSDate *)date
{
    NSDate *firstDayOfCurrentMonthe = [[date zb_dateAfterMonth:1] zb_firstDayOfCurrentMonth]; //下一个月第一天
    NSUInteger weekDay = [firstDayOfCurrentMonthe zb_weekDay];//下月第一天是礼拜几
    NSMutableArray *targetArray = [NSMutableArray arrayWithCapacity:weekDay];
    for (NSInteger index = weekDay; index > 1; --index) {
        PMCalendarDayModel *calendarDay = [[PMCalendarDayModel alloc] initWithDate:[firstDayOfCurrentMonthe zb_dateAfterDay:-index+1]];
        calendarDay.style = CellDayTypeFutur;
        [targetArray addObject:calendarDay];
    };
    return targetArray;
}

#pragma set modle style
- (void)updateCalendarDayStyle:(NSArray *)calendarDays selectedDate:(NSDate*)selectedDate
{
    NSDate *today = [NSDate date];
    NSDateComponents *calendarToDay  = [today zb_dateComponents];//今天
    for (PMCalendarDayModel *calendarDay in calendarDays) {
        //选中日期
        if (selectedDate && NSOrderedSame == [selectedDate compare:calendarDay.date]) {
             calendarDay.style = CellDayTypeClick;
        } else {    //没被点击选中
            NSComparisonResult result = [today compare:calendarDay.date];
            if (NSOrderedSame == result) {

            } else if (NSOrderedAscending == result) {
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

        //节日设定
        if (1 ==  calendarDay.month &&
            1 == calendarDay.day) { //元旦
            calendarDay.holiday = @"元旦";
        } else if (2 ==  calendarDay.month &&
                   14 == calendarDay.day) { //情人节
            calendarDay.holiday = @"情人节";
        } else if (3 ==  calendarDay.month &&
                   8 == calendarDay.day) { //妇女节
            calendarDay.holiday = @"妇女节";
        } else if (5 ==  calendarDay.month &&
                   1 == calendarDay.day) { //劳动节
            calendarDay.holiday = @"劳动节";
        } else if (6 ==  calendarDay.month &&
                   1 == calendarDay.day) { //儿童节
            calendarDay.holiday = @"儿童节";
        } else if (8 ==  calendarDay.month &&
                   1 == calendarDay.day) { //建军节
            calendarDay.holiday = @"建军节";
        } else if (9 ==  calendarDay.month &&
                   10 == calendarDay.day) { //教师节
            calendarDay.holiday = @"教师节";
        } else if (10 ==  calendarDay.month &&
                   1 == calendarDay.day) { //国庆节
            calendarDay.holiday = @"国庆节";
        } else if (11 ==  calendarDay.month &&
                   11 == calendarDay.day) { //光棍节
            calendarDay.holiday = @"光棍节";
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
}

#pragma init
- (void)commonInit
{
    self.calendarMonth = [NSMutableArray arrayWithArray:
                          [self calendarMonthFromDate:self.startDate
                                               toDate:self.endDate
                                         selectedDate:nil]];    //每个月份的数组
    PMCalendarMonthCollectionViewLayout *layout = [PMCalendarMonthCollectionViewLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                             collectionViewLayout:layout]; //初始化网格视图大小
    [self.collectionView registerClass:[PMCalendarDayCell class]
            forCellWithReuseIdentifier:kdayCellReuseIdentifier];    //cell重用设置ID
    [self.collectionView registerClass:[PMCalendarMonthHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:kmonthHeaderReuseIdentifier];
        self.collectionView.bounces = NO;             //将网格视图的下拉效果关闭
    self.collectionView.delegate = self;//实现网格视图的delegate
    self.collectionView.dataSource = self;//实现网格视图的dataSource
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
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
    PMCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kdayCellReuseIdentifier forIndexPath:indexPath];
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:indexPath.section];
    PMCalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
    [self refreshCalendarDayCell:cell calendarDayModel:model];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        PMCalendarDayModel *model = [month_Array objectAtIndex:15];
        PMCalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kmonthHeaderReuseIdentifier forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%d年 %d月",model.year,model.month];//@"日期";
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


#pragma OTHER
- (void)refreshCalendarDayCell:(PMCalendarDayCell *)cell calendarDayModel:(PMCalendarDayModel *)calendarDayModel
{
    if (CellDayTypeEmpty == calendarDayModel.style) {
        [cell.dayLabel setHidden:YES];
        [cell.dayTitleLabel setHidden:YES];
        [cell.imageView setHidden:YES];
    } else {
        [cell.dayLabel setHidden:NO];
        [cell.dayTitleLabel setHidden:NO];
        if (CellDayTypePast == calendarDayModel.style) {
            [cell.dayLabel setTextColor:[UIColor lightGrayColor]];
        } else if (CellDayTypeClick == calendarDayModel.style) {
            [cell.dayLabel setTextColor:[UIColor whiteColor]];
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

        if (calendarDayModel.lunaCalendar) {
            [cell.dayTitleLabel setText:calendarDayModel.lunaCalendar];
        }

        if (CellDayTypeClick == calendarDayModel.style) {
            [cell.imageView setImage:[UIImage imageNamed:@"calendar_day_selected"]];
            [cell.imageView setHidden:NO];
        } else {
            [cell.imageView setHidden:YES];
        }
    }
}

@end
