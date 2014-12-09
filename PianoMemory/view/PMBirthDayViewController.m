//
//  PMBirthDayViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14/12/3.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMBirthDayViewController.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import <FLAnimatedImage/FLAnimatedImageView.h>

@interface PMBirthDayViewController ()

@property (nonatomic) NSTimer *autoScrollTimer;

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *birthdayImageView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *guitarImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *sweetWordScrollView;
@end

@implementation PMBirthDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *gifFile = [[NSBundle mainBundle] pathForResource:@"birthday_main" ofType:@"gif"];
    if (gifFile) {
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:gifFile]];
        [self.birthdayImageView setAnimatedImage:image];
    }

    gifFile = [[NSBundle mainBundle] pathForResource:@"birthday_guitar" ofType:@"gif"];
    if (gifFile) {
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:gifFile]];
        [self.guitarImageView setAnimatedImage:image];
    }
}

- (NSTimer *)autoScrollTimer
{
    if (!_autoScrollTimer) {
        _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(scrollSweetWordContent) userInfo:nil repeats:YES];
    }
    return _autoScrollTimer;
}

- (void)scrollSweetWordContent
{
    UIScrollView *scrollView = self.sweetWordScrollView;
    CGFloat maxOffset = scrollView.contentSize.height-scrollView.frame.size.height;
    CGFloat curOffset = scrollView.contentOffset.y;
    CGFloat targetOffset = curOffset;
    CGFloat scrollSpeed = 2.f;
    if (curOffset < maxOffset) {
        if (curOffset + scrollSpeed < maxOffset) {
            targetOffset = curOffset + scrollSpeed;
        } else {
            targetOffset = maxOffset;
        }
    } else {
        targetOffset = 0.f;
    }
    [scrollView setContentOffset:CGPointMake(0, targetOffset)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.autoScrollTimer fire];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.autoScrollTimer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
