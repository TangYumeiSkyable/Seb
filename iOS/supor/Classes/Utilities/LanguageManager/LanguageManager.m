
//
//  LanguageManager.m
//  supor
//
//  Created by 赵冰冰 on 2017/4/6.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "LanguageManager.h"

@implementation LanguageManager

+ (NSString *)appLanguage {
    NSArray * languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *tempString = languages[0];
    if ([tempString isEqualToString:@"nl-BE"]) {
        tempString = @"nl";
    } else if ([tempString isEqualToString:@"fr-BE"]) {
        tempString = @"fr";
    } else if ([tempString isEqualToString:@"zh-Hant-HK"]) {
        tempString = @"zh";
    }
    return tempString;
}

+ (BOOL)isChineseLanguage {
    NSString * str = [self appLanguage];
    if ([str isEqualToString:@"zh-Hans-CN"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isChinese {
//#define NEED_CHINESE 1
#ifdef NEED_CHINESE
    NSString *str = [self appLanguage];
    if ([str isEqualToString:@"zh-Hans-CN"]) {
        return YES;
    }
    return NO;
#endif
    return NO;
}

+ (NSString *)showText:(NSString *)key {
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *str = arr.firstObject;
    NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"lproj"];
    return [[NSBundle bundleWithPath:path] localizedStringForKey:key value:nil table:@"Localizable"];
}

@end
