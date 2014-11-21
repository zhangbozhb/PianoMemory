//
//  FMObject.h
//  FM1017
//
//  Created by 张 波 on 14-9-2.
//  Copyright (c) 2014年 palm4fun. All rights reserved.
//

#import "HCObject.h"

@interface FMObject : HCObject <NSCopying>
@property (nonatomic) NSString *localDBId;
@property (nonatomic) NSString *remoteDBId;
- (BOOL)hasBeenSavedToLocalDB;
@end
