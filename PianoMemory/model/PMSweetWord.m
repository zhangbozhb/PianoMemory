//
//  PMSweetWord.m
//  PianoMemory
//
//  Created by 张 波 on 14/12/10.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMSweetWord.h"

@implementation PMSweetWord
- (instancetype)initWithTitle:(NSString*)title sweetWord:(NSString*)sweetWord image:(NSString*)image
{
    self = [super init];
    if (self) {
        self.title = title;
        self.sweetWord = sweetWord;
        self.image = image;
    }
    return self;
}
@end
