//
//  PMNavMoreViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14/11/12.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMNavMoreViewController.h"
#import "UITabBarItem+Extend.h"

@interface PMNavMoreViewController ()

@end

@implementation PMNavMoreViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self.tabBarItem zb_setImage:[UIImage imageNamed:@"tab_more"]
                   selectedImage:[UIImage imageNamed:@"tab_more"]
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
