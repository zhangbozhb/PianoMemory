//
//  PMObject.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-10.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "FMObject.h"

@interface PMObject : FMObject
@property (nonatomic) NSTimeInterval created;
@property (nonatomic) NSTimeInterval updated;
+ (NSArray *)sortDescriptors:(BOOL)ascending;
@end
