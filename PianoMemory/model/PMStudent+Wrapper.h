//
//  PMStudent+Wrapper.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMStudent.h"

@interface PMStudent (Wrapper)
- (NSString *)getNotNilName;
- (NSString *)getNotNilPhone;
- (NSString *)getNotNilQQ;
- (NSString *)getNotNilEmail;
- (NSString *)getNotNilBriefDescription;
- (void)updateShortcut;
@end
