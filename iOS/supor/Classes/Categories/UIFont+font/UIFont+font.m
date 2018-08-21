//
//  UIFont+font.m
//  supor
//
//  Created by 白云杰 on 2017/5/27.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "UIFont+font.h"
#import <objc/message.h>
@implementation UIFont (font)

+ (void)load {
    
//    Method systimeFont = class_getClassMethod(self, @selector(systemFontOfSize:));
//    
//    Method px_systimeFont = class_getClassMethod(self, @selector(px_systemFontOfSize:));
//    
//    method_exchangeImplementations(px_systimeFont, systimeFont);
    
    Method fontNameSize = class_getClassMethod(self, @selector(fontWithName:size:));
    Method px_fontNameSize = class_getClassMethod(self, @selector(px_systemFontName:size:));
    method_exchangeImplementations(px_fontNameSize, fontNameSize);
}


+ (UIFont *)px_systemFontOfSize:(CGFloat)pxSize {
    
    CGFloat pt = (pxSize / 96) * 72 / 2 * kMainScreenHeight / 736;
    
//    NSLog(@"pt--%f",pt);
    
    UIFont *font = [UIFont px_systemFontOfSize:pt];
    
    return font;
    
}

+ (UIFont *)px_systemFontName:(NSString *)fontName size:(CGFloat)size {
    
    CGFloat pt = MIN(size, size * kMainScreenHeight / 736) ;
        
//    NSLog(@"pt--%f",pt);
    
    UIFont *font = [UIFont px_systemFontName:fontName size:pt];
    
    return font;
}

@end
