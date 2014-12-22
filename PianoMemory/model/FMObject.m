//
//  FMObject.m
//  FM1017
//
//  Created by 张 波 on 14-9-2.
//  Copyright (c) 2014年 palm4fun. All rights reserved.
//

#import "FMObject.h"

@implementation FMObject
- (id)copyWithZone:(NSZone *)zone
{
    FMObject *another = [super copyWithZone:zone];
    another.remoteDBId = [self.remoteDBId copy];
    another.localDBId = [self.localDBId copy];
    return another;
}

- (NSString *)syncLocalId
{
    return self.localDBId;
}

- (NSString *)syncRemoteId
{
    return self.remoteDBId;
}

- (void)setSyncLocalId:(NSString *)localId
{
    self.localDBId = localId;
}

- (void)setSyncRemoteId:(NSString *)remoteId
{
    self.remoteDBId = remoteId;
}

/* 将字符串转化为 db 列名字符串(将 "大写字母" 换成 "_小写字母" */
+ (NSString *)rkNameForPropertyName:(NSString *)propertyName
{
    NSDictionary *specailKeys = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"id", nil]
                                                            forKeys:[NSArray arrayWithObjects:@"remoteDBId", nil]];
    NSString *dbColumnString = [specailKeys objectForKey:propertyName];
    if (dbColumnString) {
        return dbColumnString;
    }

    NSMutableString *newString = [NSMutableString stringWithString:@""];
    for (NSInteger i = 0,length = propertyName.length; i < length; i++) {
        NSRange range = NSMakeRange(i, 1);
        //截取字符串中的每一个字符
        NSString *charString = [propertyName substringWithRange:range];
        if (![[charString lowercaseString] isEqualToString:charString]) {
            [newString appendString:@"_"];
            [newString appendString:[charString lowercaseString]];
        } else {
            [newString appendString:charString];
        }
    }
    return newString;
}

- (BOOL)hasBeenSavedToLocalDB
{
    return (nil != self.localDBId) && 0 != [self.localDBId length];
}

+ (NSString *)primaryKeyPropertyName
{
    return @"localDBId";
}

+ (NSString *)columnNameForPropertyName:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"localDBId"]
        || [propertyName isEqualToString:@"remoteDBId"]) {
        return propertyName;
    }
    return [super columnNameForPropertyName:propertyName];
}
@end
