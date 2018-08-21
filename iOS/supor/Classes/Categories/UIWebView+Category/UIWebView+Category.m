//
//  UIWebView+Category.m
//  supor
//
//  Created by 赵冰冰 on 16/6/29.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "UIWebView+Category.h"

@implementation UIWebView (Category)

- (NSString *)getWebTitle {
    NSString *lJs = @"document.title";
    NSString * title = [self stringByEvaluatingJavaScriptFromString:lJs];
    return title;
}

@end
