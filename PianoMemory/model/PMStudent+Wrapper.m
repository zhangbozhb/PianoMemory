//
//  PMStudent+Wrapper.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-6.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMStudent+Wrapper.h"
#import <PinYin4Objc/PinYin4Objc.h>

@implementation PMStudent (Wrapper)

- (NSString *)getNotNilName
{
    return (nil!=self.name)?self.name:@"";
}

- (NSString *)getNotNilPhone
{
    return (nil!=self.phone)?self.phone:@"";
}

- (NSString *)getNotNilQQ
{
    return (nil!=self.qq)?self.qq:@"";
}

- (NSString *)getNotNilEmail
{
    return (nil!=self.email)?self.email:@"";
}

- (NSString *)getNotNilBriefDescription
{
    return (nil!=self.briefDescription)?self.briefDescription:@"";
}

+ (NSString *)getFirstLetterOfChineseCharacter:(NSString*)inputText
{
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];

    NSMutableString *resultPinyinStrBuf = [[NSMutableString alloc] init];
    for (int i = 0; i <  inputText.length; i++) {
        NSString *mainPinyinStrOfChar = [PinyinHelper getFirstHanyuPinyinStringWithChar:[inputText characterAtIndex:i] withHanyuPinyinOutputFormat:outputFormat];
        if (nil != mainPinyinStrOfChar) {
            if (0 < [mainPinyinStrOfChar length]) {
                [resultPinyinStrBuf appendString:[mainPinyinStrOfChar substringToIndex:1]];
            }
        }
        else {
            [resultPinyinStrBuf appendFormat:@"%C",[inputText characterAtIndex:i]];
        }
    }
    return resultPinyinStrBuf;
}

- (void)updateShortcut
{
    if (self.name) {
        self.nameShortcut = [[self class] getFirstLetterOfChineseCharacter:self.name];
    } else {
        self.nameShortcut = nil;
    }
}
@end
