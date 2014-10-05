//
//  HCUtils.m
//  HairCutSupervisor
//
//  Created by 张 波 on 14-5-7.
//  Copyright (c) 2014年 张 波. All rights reserved.
//

#import "HCUtils.h"

@implementation HCUtils

+ (NSString *)uuid:(BOOL)shouldCreate
{
    static NSString *uuid = nil;
    if (nil == uuid || shouldCreate) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        uuid =(__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        CFRelease(uuidRef);
    }
    return uuid;
}


+ (NSString *)getStringWithWidth:(NSString*)string witdh:(CGFloat)width fontSize:(CGFloat)fontSize
{
    CGFloat stringWith = [string sizeWithFont:[UIFont systemFontOfSize:fontSize]].width;
    NSUInteger number = (stringWith > 0)?width/stringWith+1:1;
    return [string stringByPaddingToLength:number withString:string startingAtIndex:0];
}


+ (NSString *)getNumberStringFromString:(NSString *)content fromLeft:(BOOL)fromLeft
{
    NSString *numberString = nil;
    if (content) {
        NSMutableArray *scanedStrings = [NSMutableArray array];
        NSScanner *scanner = [NSScanner scannerWithString:content];
        NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.+-"];
        while ([scanner isAtEnd] == NO) {
            NSString *buffer;
            if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
                [scanedStrings addObject:buffer];
            } else {
                [scanner setScanLocation:([scanner scanLocation] + 1)];
            }
        }
        if (0 != [scanedStrings count]) {
            if (fromLeft) {
                numberString = [scanedStrings firstObject];
            } else {
                numberString = [scanedStrings lastObject];
            }
        }
    }
    return numberString;
}


+ (UIView *)copyImageView:(UIView *)view
{
    if (!view){
        return nil;
    }

    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    [imageView setImage:image];
    return imageView;
}

@end
