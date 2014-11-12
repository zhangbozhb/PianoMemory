//
//  PMNavReportViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14/11/12.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMNavReportViewController.h"
#import "UITabBarItem+Extend.h"

@interface PMNavReportViewController ()

@end

@implementation PMNavReportViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self.tabBarItem zb_setImage:[UIImage imageNamed:@"tab_statistics"]
                   selectedImage:[UIImage imageNamed:@"tab_statistics"]
                     originImage:YES];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
