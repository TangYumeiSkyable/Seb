//
//  LanguageManager.h
//  supor
//
//  Created by 赵冰冰 on 2017/4/6.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageManager : NSObject

+ (NSString *)appLanguage;

+ (BOOL)isChinese;

+ (BOOL)isChineseLanguage;

+ (NSString *)showText:(NSString *)key;

@end
