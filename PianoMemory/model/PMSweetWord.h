//
//  PMSweetWord.h
//  PianoMemory
//
//  Created by 张 波 on 14/12/10.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMSweetWord : NSObject
@property (nonatomic) NSString *image;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *sweetWord;

- (instancetype)initWithTitle:(NSString*)title sweetWord:(NSString*)sweetWord image:(NSString*)image;
@end
