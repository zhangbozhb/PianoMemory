//
//  PMNavStuduentViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14/11/12.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMNavStuduentViewController.h"
#import "UITabBarItem+Extend.h"

@interface PMNavStuduentViewController ()

@end

@implementation PMNavStuduentViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self.tabBarItem zb_setImage:[UIImage imageNamed:@"tab_user"]
                   selectedImage:[UIImage imageNamed:@"tab_user"]
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
