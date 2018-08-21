//
//  UIButton+Extension.m
//  millHeater
//
//  Created by 赵冰冰 on 16/4/20.
//  Copyright © 2016年 colin. All rights reserved.
//

#import "UIButton+Extension.h"
#import "UIImage+FlatUI.h"
@implementation UIButton (Extension)

- (void)setBGImageWithColor:(UIColor *)color {
    UIImage * image = [UIImage imageWithColor:color cornerRadius:3];
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

@end
