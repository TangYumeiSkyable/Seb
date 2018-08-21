//
//  UIColor+LJHex.h
//  chujing
//
//  Created by 刘杰 on 2016/11/10.
//  Copyright © 2016年 Eastnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB_COLOR(R,G,B) [UIColor colorWithRed:(R) / 255.0f green:(G) / 255.0f blue:(B) / 255.0f alpha:1.0f]
#define RGBA_COLOR(R,G,B,A) [UIColor colorWithRed:(R) / 255.0f green:(G) / 255.0f blue:(B) / 255.0f alpha:(A)]
#define MainBrownColor [UIColor colorWithHexString:@"#D3B988"]
#define LJHexColor(color, ...) [UIColor colorWithHexString:color, ##__VA_ARGS__]
#define LJAlphaColor(color, alphas, ...) [UIColor colorWithHexString:color alpha:alphas]


@interface UIColor (LJHex)

// color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
/**
 从十六进制字符串获取颜色

 @param color 颜色字符串
 @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 从十六进制字符串获取颜色，设置透明度

 @param color 颜色字符串
 @param alpha 透明度
 @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
