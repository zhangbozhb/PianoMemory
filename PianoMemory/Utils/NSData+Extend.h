//
//  NSData+Extend.h
//  Utils
//
//  Created by 张 波 on 14-9-1.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Extend)
- (NSData *)zb_AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)zb_AES256DecryptWithKey:(NSString *)key;   //解密
- (NSString *)zb_stringInBase64;            //追加64编码
@end
