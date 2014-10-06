//
//  HCErrorMessage.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-5-4.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "HCObject.h"

@interface HCErrorMessage : HCObject <NSCopying>
@property (nonatomic) NSMutableDictionary *errors;

- (instancetype)initWithErrorMessage:(NSString *)message;

- (NSString *)errorMessage;
@end
