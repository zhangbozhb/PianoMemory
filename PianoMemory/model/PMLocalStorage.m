//
//  PMLocalStorage.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-4.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMLocalStorage.h"

static NSString *const klocal_activity_mapping_key = @"org.plam4fun.fm1017.localActivityMappingKey";
static NSString *const klocal_activity_view_key = @"org.plam4fun.fm1017.localActivityViewKey";
static NSString *const klocal_activity_etag_key = @"org.plam4fun.fm1017.localActivityEtagKey";

static NSString *const klocal_article_mapping_key = @"org.plam4fun.fm1017.localArticleMappingKey";
static NSString *const klocal_article_view_key = @"org.plam4fun.fm1017.localArticleViewKey";
static NSString *const klocal_article_etag_key = @"org.plam4fun.fmPMLocalStorage1017.localArticleEtagKey";

@implementation PMLocalStorage

+ (instancetype)defaultLocalStorage
{
    static PMLocalStorage *localStorage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localStorage = [[PMLocalStorage alloc] initWithDBName:@"local.ldb"];
    });
    return localStorage;
}

#pragma encapsulate mapping methods(override)
- (NSString *)mappingKeyOfClass:(Class)objectClass;
{
//    if ([objectClass isSubclassOfClass:[FMActivity class]]) {
//        return klocal_activity_mapping_key;
//    }
    return nil;
}

#pragma encapsulate view methods(override)
- (NSString*)viewKeyOfClass:(Class)objectClass;
{
//    if ([objectClass isSubclassOfClass:[FMActivity class]]) {
//        return klocal_activity_view_key;
//    }
    return nil;
}
@end
