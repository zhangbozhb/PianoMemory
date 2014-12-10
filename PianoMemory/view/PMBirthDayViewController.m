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
#import "PMSpecialDay.h"
#import "NSDate+Extend.h"

@interface PMBirthDayViewController ()

@property (nonatomic) NSTimer *autoScrollTimer;

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *birthdayImageView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *guitarImageView;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
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

    NSInteger birthDayCount = [[NSDate date] zb_getYear] - [[PMSpecialDay birthdayDate] zb_getYear];
    if (1 == birthDayCount) {
        @"亲爱的，今天我们在一起后的第一个生日，我想给你一个特别的礼物";
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
