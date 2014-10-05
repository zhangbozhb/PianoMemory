//
//  NSString+Extend.h
//  HairCutSupervisor
//
//  Created by 张 波 on 14-8-27.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extend)

- (BOOL)zb_isValidEmail;
- (BOOL)zb_isValidIdentityCard;  //身份证号

#pragma ios7
- (CGSize)zb_sizeWithFont:(UIFont *)font;
- (CGSize)zb_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

#pragma Hashes
- (NSString*)zb_md5;
- (NSString*)zb_sha1;
- (NSString*)zb_sha256;
- (NSString*)zb_sha512;


- (NSString *)zb_removeAllLineHeaderAndTailBlank:(NSString *)lines keepBlankLine:(BOOL)keepBlankLine;


#pragma class method
+ (NSString *)zb_blankStringWithWidth:(CGFloat)width fontSize:(CGFloat)fontSize;

@end
