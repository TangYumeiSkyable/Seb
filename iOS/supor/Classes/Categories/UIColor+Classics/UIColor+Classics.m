//
//  UIColor+Classics.m
//  supor
//
//  Created by 赵冰冰 on 2017/5/5.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "UIColor+Classics.h"
#import "UIColor+FlatUI.h"
@implementation UIColor (Classics)

+ (UIColor *)classics_gray {
    static UIColor * gray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gray = [UIColor colorFromHexCode:@"#848484"];
    });
    return gray;
}

+ (UIColor *)classics_black{
    static UIColor * black = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        black = [UIColor colorFromHexCode:@"36424a"];
    });
    return black;
}

+ (UIColor *)classics_blue {
    static UIColor * blue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        blue = [UIColor colorFromHexCode:@"#009dc2"];
    });
    return blue;
}

@end
