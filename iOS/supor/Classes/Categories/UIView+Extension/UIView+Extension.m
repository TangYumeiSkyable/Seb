//
//  UIView+Extension.m
//  millHeater
//
//  Created by 赵冰冰 on 16/4/20.
//  Copyright © 2016年 colin. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (UIViewController *)findingSelfVC {
    UIResponder * rep = self;
    while (![rep isKindOfClass:[UIViewController class]]) {
        rep = self.nextResponder;
    }
    return (UIViewController *)rep;
}

+ (id)loadFromNibNoOwner {
    UIView * result = nil;
    NSArray * elements = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    for (id anyObject in elements) {
        if ([anyObject isKindOfClass:[self class]]) {
            result = anyObject;
            break;
        }
    }
    return result;
}

@end
