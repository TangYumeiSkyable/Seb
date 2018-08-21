//
//  NSBundle+Language.m
//  supor
//
//  Created by 刘杰 on 2018/3/26.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "NSBundle+Language.h"
#import <objc/runtime.h>

static const char kBundleKey = 0;

@interface BundleEX : NSBundle

@end

@implementation BundleEX

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    NSBundle *bundle = objc_getAssociatedObject(self, &kBundleKey);
    if (bundle) {
        return [bundle localizedStringForKey:key value:value table:tableName];
    } else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}


@end

@implementation NSBundle (Language)

+ (void)setLanguage:(NSString *)langeuage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle], [BundleEX class]);
    });
    id value = langeuage ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:langeuage ofType:@"lproj"]] : nil;
    objc_setAssociatedObject([NSBundle mainBundle], &kBundleKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end
