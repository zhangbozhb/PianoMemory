//
//  PMSweetWordViewController.m
//  PianoMemory
//
//  Created by 张 波 on 14/12/9.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMSweetWordViewController.h"
#import <FXLabel/FXLabel.h>
#import "PMSweetWord.h"
#import "CoreAnimationEffect.h"

@interface PMSweetWordViewController ()
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) NSTimer *autoSwitchTimer;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *skipLabel;
@property (weak, nonatomic) IBOutlet FXLabel *titleLabel;
@property (weak, nonatomic) IBOutlet FXLabel *detailLabel;
@end

@implementation PMSweetWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.currentIndex = -1;

    //添加手势
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadNext)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadPrevious)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];

    self.titleLabel.shadowColor = [UIColor grayColor];
    self.titleLabel.shadowOffset = CGSizeMake(1.f, 1.f);
    self.detailLabel.shadowColor = [UIColor grayColor];
    self.detailLabel.shadowOffset = CGSizeMake(1.f, 1.f);
    self.detailLabel.shadowBlur = 20.0f;


    PMSweetWord *sweetWord1 = [[PMSweetWord alloc] initWithTitle:nil sweetWord:@"遇到你一场场美丽的意外，那天你白衣斯雪，似那误入凡尘的精灵，出现在我面前，出现在我的心里" image:@"meet.jpg"];
    PMSweetWord *sweetWord2 = [[PMSweetWord alloc] initWithTitle:nil sweetWord:@"都说无论多早遇到那个对的人，都会嫌太迟，而你就是那个让我始终觉得相遇太迟的人" image:@"meet_too_late.jpg"];

    PMSweetWord *sweetWord3 = [[PMSweetWord alloc] initWithTitle:nil sweetWord:@"那个金色的秋天，银杏飞舞的季节，认识你就是我最大的收获" image:@"autumn.jpg"];
    PMSweetWord *sweetWord4 = [[PMSweetWord alloc] initWithTitle:nil sweetWord:@"这个银色的冬天，白雪纷飞的季节，你的陪伴给了我最多的温暖" image:@"winter.jpg"];
    PMSweetWord *sweetWord5 = [[PMSweetWord alloc] initWithTitle:nil sweetWord:@"即将到来的生命的春天，万物复苏的季节，你给我的人生注入了新的活力" image:@"spring.jpg"];
    PMSweetWord *sweetWord6 = [[PMSweetWord alloc] initWithTitle:nil sweetWord:@"还会经历热烈夏天，绚烂的季节，感受生命的炽热与激情" image:@"summer.jpg"];
    PMSweetWord *sweetWord7 = [[PMSweetWord alloc] initWithTitle:@"其实..." sweetWord:@"我只是想和你一起走过每一个春夏秋冬" image:@"allseason.jpg"];

    PMSweetWord *sweetWord8 = [[PMSweetWord alloc] initWithTitle:@"我还想..." sweetWord:nil image:@"iwant.jpg"];
    PMSweetWord *sweetWord9 = [[PMSweetWord alloc] initWithTitle:nil sweetWord:@"我想和你一起看日出，感受初升的喜悦" image:@"sunrise.jpg"];
    PMSweetWord *sweetWord10 = [[PMSweetWord alloc] initWithTitle:nil sweetWord:@"我想和你一起看日落，感受夕阳的无限美好" image:@"sunset.jpg"];
    PMSweetWord *sweetWord11 = [[PMSweetWord alloc] initWithTitle:nil sweetWord:@"我想和你一起漫步海边，感受大海的浩瀚" image:@"sea.jpg"];
    PMSweetWord *sweetWord12 = [[PMSweetWord alloc] initWithTitle:nil sweetWord:@"我想和你一起爬山，感受山峰的巍峨" image:@"climb_mountain.jpg"];
    PMSweetWord *sweetWord13 = [[PMSweetWord alloc] initWithTitle:nil sweetWord:@"我想和你一起穿梭在一座座城市，感受都市的繁华" image:@"city.jpg"];
    PMSweetWord *sweetWord14 = [[PMSweetWord alloc] initWithTitle:nil sweetWord:@"我想和你一起仰望星空，感受那无尽星空的深邃" image:@"starsky.jpg"];
    PMSweetWord *sweetWord15 = [[PMSweetWord alloc] initWithTitle:nil sweetWord:@"我只是想陪伴你日日夜夜..." image:@"dayandlight.jpg"];
    PMSweetWord *sweetWord16 = [[PMSweetWord alloc] initWithTitle:@"我想的还有很多..." sweetWord:@"我最想的还是和你一起慢慢变老" image:@"getting_old.jpg"];

    self.sweetWords = [NSArray arrayWithObjects:sweetWord1, sweetWord2, sweetWord3, sweetWord4, sweetWord5,
                       sweetWord6, sweetWord7, sweetWord8,sweetWord9, sweetWord10, sweetWord11, sweetWord12,
                       sweetWord13, sweetWord14, sweetWord15, sweetWord16, nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSTimer *)autoSwitchTimer
{
    if (!_autoSwitchTimer) {
        _autoSwitchTimer = [NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(switchSweetWord) userInfo:nil repeats:YES];
    }
    return _autoSwitchTimer;
}

- (void)switchSweetWord
{
    self.currentIndex = self.currentIndex + 1;
    if (self.currentIndex < [self.sweetWords count]) {
        PMSweetWord *sweetWord = [self.sweetWords objectAtIndex:self.currentIndex];
        [self refreshUIWithSweetWord:sweetWord];
    } else {
        self.currentIndex = 0;
    }
    [CoreAnimationEffect animationCubeFromRight:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.autoSwitchTimer fire];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.autoSwitchTimer invalidate];
}

- (void)refreshUIWithSweetWord:(PMSweetWord*)sweetword
{
    self.titleLabel.text = sweetword.title;
    self.detailLabel.text = sweetword.sweetWord;
    UIImage *image = [UIImage imageNamed:sweetword.image];
    if (!image) {
        image = [UIImage imageNamed:@"sweetwordbg.jpg"];
    }
    [self.backgroundImageView setImage:image];

}

- (void)loadNext
{
    if (self.currentIndex < [self.sweetWords count] - 1) {
        self.currentIndex = self.currentIndex + 1;
        PMSweetWord *sweetWord = [self.sweetWords objectAtIndex:self.currentIndex];
        [self refreshUIWithSweetWord:sweetWord];
    }
    [CoreAnimationEffect animationCubeFromRight:self.view];

}

- (void)loadPrevious
{
    self.currentIndex = self.currentIndex - 1;
    if (self.currentIndex < [self.sweetWords count]) {
        PMSweetWord *sweetWord = [self.sweetWords objectAtIndex:self.currentIndex];
        [self refreshUIWithSweetWord:sweetWord];
    } else {
        self.currentIndex = 0;
    }
    [CoreAnimationEffect animationCubeFromLeft:self.view];
}

@end
