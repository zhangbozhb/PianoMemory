//
//  ZBUtils.m
//  Utils
//
//  Created by 张 波 on 14-9-2.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "ZBUtils.h"
#import <AdSupport/ASIdentifierManager.h>

static const NSString *kUUIDKey = @"zbutils.userdefaultstore.zb_deviceUUID";
@implementation ZBUtils

+ (NSUUID*)zb_deviceUUID
{
    static NSUUID *uuid = nil;
    if (nil == uuid) {
        NSString *uuidString = [[NSUserDefaults standardUserDefaults] objectForKey:[kUUIDKey copy]];
        if (nil != uuidString) {
            uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
        } else {
            if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
                uuid = [[ASIdentifierManager sharedManager] advertisingIdentifier];
            } else {
                uuid = [[NSUUID alloc] init];
            }
            [[NSUserDefaults standardUserDefaults] setObject:[uuid UUIDString] forKey:[kUUIDKey copy]];
        }

    }
    return uuid;
}
@end
