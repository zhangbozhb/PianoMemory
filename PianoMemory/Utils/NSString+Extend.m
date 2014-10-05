//
//  NSString+Extend.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-8-27.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "NSString+Extend.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIDevice+Extend.h"

@implementation NSString (Extend)

#pragma regex
- (BOOL)zb_isValidEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:self];
}

- (BOOL)zb_isValidIdentityCard
{
    if (0 == [self length]) {
        return NO;
    }
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [identityCardPredicate evaluateWithObject:self];
}

- (CGSize)zb_sizeWithFont:(UIFont *)font
{
    CGSize size;
    if ([UIDevice zb_systemVersion7Latter] ) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:font forKey:NSFontAttributeName];
        size = [self sizeWithAttributes:attributes];
    } else {
        size = [self sizeWithFont:font];
    }
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

- (CGSize)zb_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize expectedSize;
    if ([UIDevice zb_systemVersion7Latter]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;

        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self];
        NSRange range = NSMakeRange(0, attributedText.length);
        [attributedText addAttribute:NSFontAttributeName value:font range:range];
        [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        expectedSize = [attributedText boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                    context:nil].size;
    } else {
        expectedSize = [self sizeWithFont:font
                        constrainedToSize:size
                            lineBreakMode:lineBreakMode];
    }
    return CGSizeMake(ceil(expectedSize.width), ceil(expectedSize.height));
}

#pragma Hashes
- (NSString*)zb_md5 {
	unsigned int outputLength = CC_MD5_DIGEST_LENGTH;
	unsigned char output[outputLength];

	CC_MD5(self.UTF8String, [self zb_UTF8Length], output);
	return [self zb_toHexString:output length:outputLength];;
}

- (NSString*)zb_sha1 {
	unsigned int outputLength = CC_SHA1_DIGEST_LENGTH;
	unsigned char output[outputLength];

	CC_SHA1(self.UTF8String, [self zb_UTF8Length], output);
	return [self zb_toHexString:output length:outputLength];;
}

- (NSString*)zb_sha256 {
	unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
	unsigned char output[outputLength];

	CC_SHA256(self.UTF8String, [self zb_UTF8Length], output);
	return [self zb_toHexString:output length:outputLength];;
}

- (NSString*)zb_sha512 {
	unsigned int outputLength = CC_SHA512_DIGEST_LENGTH;
	unsigned char output[outputLength];

	CC_SHA512(self.UTF8String, [self zb_UTF8Length], output);
	return [self zb_toHexString:output length:outputLength];;
}

- (unsigned int)zb_UTF8Length {
	return (unsigned int) [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*)zb_toHexString:(unsigned char*) data length: (unsigned int) length {
	NSMutableString* hash = [NSMutableString stringWithCapacity:length * 2];
	for (unsigned int i = 0; i < length; i++) {
		[hash appendFormat:@"%02x", data[i]];
		data[i] = 0;
	}
	return hash;
}

#pragma other
- (NSString *)zb_removeAllLineHeaderAndTailBlank:(NSString *)lines keepBlankLine:(BOOL)keepBlankLine
{
    NSMutableString *procesedLines = [NSMutableString stringWithString:lines];
    //  *[\r\n]+ *
    [procesedLines replaceOccurrencesOfString:@"[\\t 　]*\\r*\\n[\\t 　]*" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, [procesedLines length])];
    if (!keepBlankLine) {
        [procesedLines replaceOccurrencesOfString:@"\\n+" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, [procesedLines length])];
    }

    return [procesedLines stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma class method
+ (NSString *)zb_blankStringWithWidth:(CGFloat)width fontSize:(CGFloat)fontSize
{
    NSString *blank = @" ";
    CGFloat blankWith = [blank sizeWithFont:[UIFont systemFontOfSize:fontSize]].width;
    NSUInteger number = (blankWith > 0)?ceil(width/blankWith):1;
    NSString *formateString =  [NSString stringWithFormat:@"%%-%ldd",(long)number];
    NSString *blankString = [NSString stringWithFormat:formateString,0];
    return [blankString substringFromIndex:1];
}
@end
