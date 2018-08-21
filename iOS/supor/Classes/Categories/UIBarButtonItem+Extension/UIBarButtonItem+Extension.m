//
//  UIBarButtonItem+Extension.m
//  millHeater
//
//  Created by 赵冰冰 on 16/4/20.
//  Copyright © 2016年 colin. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "RHLeftNavButton.h"
@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)mCreateLeftItemWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image highLightImage:(UIImage *)highLightImage target:(id)target selector:(SEL)sel {
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:button];
    return left;
}

+ (UIBarButtonItem *)createLeftItemWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image highLightImage:(UIImage *)highLightImage target:(id)target selector:(SEL)sel {
    RHLeftNavButton * button = [[RHLeftNavButton alloc]initWithFrame:CGRectMake(0, 0, 70, 44)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:button];
    return left;
}

+ (UIBarButtonItem *)createRightItemWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image highLightImage:(UIImage *)highLightImage target:(id)target selector:(SEL)sel {
    UIButton * button = [[UIButton alloc]initWithFrame:frame];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:button];
    return left;
}

@end
