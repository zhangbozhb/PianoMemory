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

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *birthdayImageView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *guitarImageView;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
