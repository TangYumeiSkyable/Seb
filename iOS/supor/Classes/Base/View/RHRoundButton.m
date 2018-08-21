//
//  RHRoundButton.m
//  millHeater
//
//  Created by 赵冰冰 on 16/4/18.
//  Copyright © 2016年 colin. All rights reserved.
//

#import "RHRoundButton.h"
#import "UIImage+FlatUI.h"
@implementation RHRoundButton

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    UIImage * image = [UIImage imageWithColor:backgroundColor cornerRadius:3];
    [self setBackgroundImage:image forState:UIControlStateNormal];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor clearColor].CGColor;
}
@end
