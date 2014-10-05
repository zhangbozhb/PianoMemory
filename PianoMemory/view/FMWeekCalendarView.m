//
//  FMWeekCalendarView.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-5.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "FMWeekCalendarView.h"
#import "NSString+Extend.h"
#import "NSDate+Extend.h"
#import "LunarCalendar.h"

#define PMDAYNUMBEROFWEEK 7

@interface FMWeekCalendarView ()
@property (nonatomic) CGRect weekTitleRect;
@property (nonatomic) CGRect weekDayRect;
@property (nonatomic) CGRect lunaDayRect;
@property (nonatomic) NSDate *visiableDate;
@property (nonatomic) NSArray *weekTitles;
@property (nonatomic) NSArray *weekDays;
@end

@implementation FMWeekCalendarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
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

- (void)commonInit
{
    self.visiableDate = [NSDate date];


    self.weekTitleColor = [UIColor blackColor];
    self.weekTitleFont = [UIFont systemFontOfSize:12.f];
    self.weekTitles = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];;

    self.weekDayTitleColor = [UIColor blackColor];
    self.weekDayTitleFont = [UIFont systemFontOfSize:30.f];

    self.lunaFont = [UIFont systemFontOfSize:10.f];
    self.lunaColor = [UIColor blackColor];

    self.selectedDateColor = [UIColor purpleColor];
    self.currentDateColor = [UIColor redColor];
    self.showLunar = YES;

    self.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:singleTap];

    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:leftSwipe];
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:rightSwipe];
}

- (void)drawRect:(CGRect)rect
{
    //计算大小
    [self calcForDraw:rect];

    [self drawSelectedAndCurrentDate:rect];
    [self drawWeekTitles];
    [self drawDays];
    [self drawLunaDays];
}

- (void)calcForDraw:(CGRect)rect
{
    //计算 title 高度
    NSString *title = [self.weekTitles objectAtIndex:0];
    CGFloat titleHeight = [title zb_sizeWithFont:self.weekTitleFont].height;
    self.weekTitleRect = CGRectMake(rect.origin.x+self.contentEdgeInsets.left,
                                    rect.origin.y+self.contentEdgeInsets.top,
                                    rect.size.width-self.contentEdgeInsets.left-self.contentEdgeInsets.right,
                                    titleHeight);

    if (self.showLunar) {
        //计算 luna day 高度
        LunarCalendar *lunaCalendar = [[NSDate date] chineseCalendarDate];
        CGFloat lunaHeight = [lunaCalendar.DayLunar zb_sizeWithFont:self.lunaFont].height;
        self.lunaDayRect = CGRectMake(rect.origin.x+self.contentEdgeInsets.left,
                                      rect.origin.y+rect.size.height-self.contentEdgeInsets.bottom-lunaHeight,
                                      rect.size.width-self.contentEdgeInsets.left-self.contentEdgeInsets.right,
                                      lunaHeight);
        //计算 day 高度
        self.weekDayRect = CGRectMake(rect.origin.x+self.contentEdgeInsets.left,
                                      rect.origin.y+titleHeight+self.contentEdgeInsets.top,
                                      rect.size.width-self.contentEdgeInsets.left-self.contentEdgeInsets.right,
                                      rect.size.height-titleHeight-lunaHeight-self.contentEdgeInsets.top-self.contentEdgeInsets.bottom);
    } else {
        //计算 day 高度
        self.weekDayRect = CGRectMake(rect.origin.x+self.contentEdgeInsets.left,
                                      rect.origin.y+titleHeight+self.contentEdgeInsets.top,
                                      rect.size.width-self.contentEdgeInsets.left-self.contentEdgeInsets.right,
                                      rect.size.height-titleHeight-self.contentEdgeInsets.top-self.contentEdgeInsets.bottom);
    }
}

- (BOOL)isDateVisiable:(NSDate *)date
{
    if (!date) {
        return NO;
    }
    NSDate *startDate = [self.weekDays firstObject];
    NSDate *endDate = [self.weekDays lastObject];
    if ([date zb_getDayTimestamp] < [startDate zb_getDayTimestamp] ||
        [date zb_getDayTimestamp] > [endDate zb_getDayTimestamp]) {
        return NO;
    }
    return YES;
}

- (void)drawSelectedAndCurrentDate:(CGRect)rect
{
    CGFloat contentWith = rect.size.width-self.contentEdgeInsets.left-self.contentEdgeInsets.right;
    CGFloat dayWith = contentWith/PMDAYNUMBEROFWEEK;

    NSDate *currentDate = [NSDate date];
    if ([self isDateVisiable:currentDate]) {
        NSInteger weekDay = [currentDate zb_getWeekDay] - 1;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, self.currentDateColor.CGColor);
        CGRect targetRect = CGRectMake(rect.origin.x+self.contentEdgeInsets.left + dayWith *weekDay,
                                       rect.origin.y,
                                       dayWith,
                                       rect.size.height);
        CGContextFillRect(context, targetRect);
        CGContextRestoreGState(context);
    }

    if (self.selectedDate &&
        [self isDateVisiable:self.selectedDate]) {
        NSInteger weekDay = [self.selectedDate zb_getWeekDay] - 1;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, self.selectedDateColor.CGColor);
        CGRect targetRect = CGRectMake(rect.origin.x+self.contentEdgeInsets.left + dayWith *weekDay,
                                       rect.origin.y,
                                       dayWith,
                                       rect.size.height);
        CGContextFillRect(context, targetRect);
        CGContextRestoreGState(context);
    }
}

- (void)drawWeekTitles
{
    NSArray *weekTitles = self.weekTitles;
    CGFloat weekDayWidth = self.weekTitleRect.size.width/[weekTitles count];
    CGFloat weekDayHeight = self.weekTitleRect.size.height;
    CGFloat startX = self.weekTitleRect.origin.x;
    CGFloat startY = self.weekTitleRect.origin.y;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, self.weekTitleColor.CGColor);
    for (NSInteger index = 0, maxIndex = [weekTitles count]; index < maxIndex; ++index) {
        NSString *weekDay = [weekTitles objectAtIndex:index];
        CGSize weekDaySize = [weekDay zb_sizeWithFont:self.weekTitleFont];
        CGFloat targetX = startX + weekDayWidth * index + (weekDayWidth - weekDaySize.width)/2;
        CGFloat targetY = startY + (weekDayHeight - weekDaySize.height)/2;
        [weekDay drawAtPoint:CGPointMake(targetX, targetY)
                   forWidth:weekDayWidth
                   withFont:self.weekTitleFont
              lineBreakMode:NSLineBreakByCharWrapping];
    }
    CGContextRestoreGState(context);
}

- (NSArray*)getWeekDays
{
    NSInteger weekDay = [self.visiableDate zb_getWeekDay];
    NSInteger startDayOff = (1 == weekDay)?0:weekDay-PMDAYNUMBEROFWEEK;
    NSDate *startDay = [self.visiableDate zb_dateAfterDay:startDayOff];
    NSMutableArray *weekDays = [NSMutableArray array];
    for (NSInteger index = 0; index < 7; ++index) {
        [weekDays addObject:[startDay zb_dateAfterDay:index]];
    }
    return weekDays;
}

- (void)drawDays
{
    NSArray *weekDays =  self.weekDays;
    CGFloat weekDayWidth = self.weekDayRect.size.width/PMDAYNUMBEROFWEEK;
    CGFloat weekDayHeight = self.weekDayRect.size.height;
    CGFloat startX = self.weekDayRect.origin.x;
    CGFloat startY = self.weekDayRect.origin.y;


    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, self.weekDayTitleColor.CGColor);
    for (NSInteger index = 0, maxIndex = [weekDays count]; index < maxIndex; ++index) {
        NSDate *date = [weekDays objectAtIndex:index];

        NSString *monthDay = [NSString stringWithFormat:@"%ld",(long)[date zb_getDay]];
        CGSize weekDaySize = [monthDay zb_sizeWithFont:self.weekDayTitleFont];
        CGFloat targetX = startX + weekDayWidth * index + (weekDayWidth - weekDaySize.width)/2;
        CGFloat targetY = startY + (weekDayHeight - weekDaySize.height)/2;
        [monthDay drawAtPoint:CGPointMake(targetX, targetY)
                    forWidth:weekDayWidth
                    withFont:self.weekDayTitleFont
               lineBreakMode:NSLineBreakByCharWrapping];

    }
    CGContextRestoreGState(context);
}

- (void)drawLunaDays
{
    NSArray *weekDays =  self.weekDays;
    CGFloat weekDayWidth = self.lunaDayRect.size.width/PMDAYNUMBEROFWEEK;
    CGFloat weekDayHeight = self.lunaDayRect.size.height;
    CGFloat startX = self.lunaDayRect.origin.x;
    CGFloat startY = self.lunaDayRect.origin.y;


    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, self.lunaColor.CGColor);
    for (NSInteger index = 0, maxIndex = [weekDays count]; index < maxIndex; ++index) {
        NSDate *date = [weekDays objectAtIndex:index];
        LunarCalendar *lunaCalendar = [date chineseCalendarDate];

        NSString *lunaDay = [lunaCalendar DayLunar];
        CGSize weekDaySize = [lunaDay zb_sizeWithFont:self.lunaFont];
        CGFloat targetX = startX + weekDayWidth * index + (weekDayWidth - weekDaySize.width)/2;
        CGFloat targetY = startY + (weekDayHeight - weekDaySize.height)/2;
        [lunaDay drawAtPoint:CGPointMake(targetX, targetY)
                    forWidth:weekDayWidth
                    withFont:self.lunaFont
               lineBreakMode:NSLineBreakByCharWrapping];

    }
    CGContextRestoreGState(context);
}


- (NSInteger)positionOfWeekDayIndex:(CGPoint)point
{
    CGFloat weekDayWidth = self.weekDayRect.size.width/PMDAYNUMBEROFWEEK;
    NSInteger index = (point.x - self.contentEdgeInsets.left)/ weekDayWidth;
    if (0 > index) {
        index = 0;
    } else if (index > 6){
        index = 6;
    }
    return index;
}
- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    CGPoint tapPoint = [tap locationInView:self];
    NSDate *selectedDate = [self.weekDays objectAtIndex:[self positionOfWeekDayIndex:tapPoint]];
    if ([self.selectedDate zb_getDayTimestamp] != [selectedDate zb_getDayTimestamp]) {
        self.selectedDate = selectedDate;
        [self setNeedsDisplay];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(weekCalendarView:selectDate:)]) {
        [self.delegate weekCalendarView:self selectDate:selectedDate];
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe
{
    if (UISwipeGestureRecognizerDirectionRight == swipe.direction) {
        self.visiableDate = [self.visiableDate zb_dateAfterDay:-PMDAYNUMBEROFWEEK];
    } else {
        self.visiableDate = [self.visiableDate zb_dateAfterDay:PMDAYNUMBEROFWEEK];
    }
    [self setNeedsDisplay];
}


#pragma overrid
-(void)setVisiableDate:(NSDate *)visiableDate
{
    _visiableDate = visiableDate;
    self.weekDays = [self getWeekDays];
}
@end
