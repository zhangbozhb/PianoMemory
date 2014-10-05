//
//  PMLocalStorage.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "FMSyncStorage.h"

@interface PMLocalStorage : FMSyncStorage
+ (instancetype)defaultLocalStorage;
@end
