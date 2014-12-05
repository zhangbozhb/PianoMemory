//
//  PMAppUpdateInfo.h
//  PianoMemory
//
//  Created by 张 波 on 14/12/5.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMObject.h"

@interface PMAppUpdateInfo : FMObject <NSCopying>
@property (nonatomic) NSString *appVersion;
@property (nonatomic) NSString *buildVersion;
@property (nonatomic) NSString *update_Url;
@end
