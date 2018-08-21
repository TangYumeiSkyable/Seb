//
//  UIView+Extension.h
//  millHeater
//
//  Created by 赵冰冰 on 16/4/20.
//  Copyright © 2016年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

+ (id)loadFromNibNoOwner;

- (UIViewController *)findingSelfVC;


@end
