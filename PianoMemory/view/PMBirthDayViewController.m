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
#import <FXLabel/FXLabel.h>
#import "PMSweetWordViewController.h"

@interface PMBirthDayViewController ()
@property (weak, nonatomic) IBOutlet FXLabel *titleLabel;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *birthdayImageView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *guitarImageView;
@property (weak, nonatomic) IBOutlet FXLabel *wordLabel;
@end

@implementation PMBirthDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.titleLabel.gradientStartPoint = CGPointMake(0.0f, 0.0f);
    self.titleLabel.gradientEndPoint = CGPointMake(1.0f, 1.0f);
    self.titleLabel.gradientColors = [NSArray arrayWithObjects:
                             [UIColor redColor],
                             [UIColor yellowColor],
                             [UIColor greenColor],
                             [UIColor cyanColor],
                             [UIColor blueColor],
                             [UIColor purpleColor],
                             [UIColor redColor],
                             nil];

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
        self.wordLabel.text = @"亲爱的，今天我们在一起后的第一个生日，我想给你一个特别的礼物。你知道吗？我们相识的第54天我们在一起了，又一个54天过去，迎来了你的一个生日。";
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)acceptGiftAction:(id)sender {
    [self presentViewController:[[PMSweetWordViewController alloc] init] animated:YES completion:nil];
}

@end
