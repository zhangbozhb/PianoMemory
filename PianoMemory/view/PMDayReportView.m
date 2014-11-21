//
//  PMDayReportView.m
//  PianoMemory
//
//  Created by 张 波 on 14/11/3.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMDayReportView.h"
#import "PMWeekDayStat.h"
#import "PMCourseScheduleRepeat.h"
#import "PMDayCourseSchedule+Wrapper.h"
#import "PMDayReportPieElement.h"

@interface PMDayReportView ()
@property (nonatomic) NSArray* previsionElements;
@end

@implementation PMDayReportView
+ (Class)layerClass
{
    return [PieLayer class];
}

- (id)init
{
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.layer.maxRadius = 100;
    self.layer.minRadius = 50;
    self.layer.animationDuration = 0.6;
    self.layer.showTitles = ShowTitlesAlways;
    if ([self.layer.self respondsToSelector:@selector(setContentsScale:)])
    {
        self.layer.contentsScale = [[UIScreen mainScreen] scale];
    }

    [self.layer setTransformTitleBlock:^NSString *(PieElement *elem, float percent) {
        PMDayReportPieElement *element = (PMDayReportPieElement*)elem;
        NSString *displayText = [PMCourseScheduleRepeat displayTextOfRepeatWeekDay:element.dayStatistics.repeatWeekday];

        //        return [NSString stringWithFormat:@"%@ 课时:%ld 比例:%.2f%%", displayText,(long)element.dayStatistics.courseCount, percent];
        return [NSString stringWithFormat:@"%@ %ld节", displayText,(long)element.dayStatistics.courseCount];
    }];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)handleTap:(UITapGestureRecognizer*)tap
{
    if(tap.state != UIGestureRecognizerStateEnded)
        return;

    CGPoint pos = [tap locationInView:tap.view];
    PieElement* tappedElem = [self.layer pieElemInPoint:pos];
    if(!tappedElem)
        return;

    if(tappedElem.centrOffset > 0)
        tappedElem = nil;
    [PieElement animateChanges:^{
        for(PieElement* elem in self.layer.values){
            elem.centrOffset = tappedElem==elem? 20 : 0;
        }
    }];
}

- (UIColor*)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)updateWithWeekDayStat:(NSArray*)weekDayStats
{
    if (self.previsionElements) {
        [self.layer deleteValues:self.previsionElements animated:NO];
        self.previsionElements = nil;
    }
    NSMutableArray *targetValues = [NSMutableArray arrayWithCapacity:[weekDayStats count]];
    for (PMWeekDayStat *dayStat in weekDayStats) {
        PMDayReportPieElement *element = [PMDayReportPieElement pieElementWithValue:dayStat.courseCount+0.1f color:[self randomColor]];
        element.dayStatistics = dayStat;
        [targetValues addObject:element];
    }
    [self.layer addValues:targetValues animated:NO];
    self.previsionElements = targetValues;
}



@end
