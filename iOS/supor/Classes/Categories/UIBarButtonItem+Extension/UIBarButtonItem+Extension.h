//
//  UIBarButtonItem+Extension.h
//  millHeater
//
//  Created by 赵冰冰 on 16/4/20.
//  Copyright © 2016年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *)createLeftItemWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image highLightImage:(UIImage *)highLightImage target:(id)target selector:(SEL)sel;

+ (UIBarButtonItem *)createRightItemWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image highLightImage:(UIImage *)highLightImage target:(id)target selector:(SEL)sel;

+ (UIBarButtonItem *)mCreateLeftItemWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image highLightImage:(UIImage *)highLightImage target:(id)target selector:(SEL)sel;
@end
