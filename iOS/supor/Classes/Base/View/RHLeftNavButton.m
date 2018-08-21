//
//  RHLeftNavButton.m
//  supor
//
//  Created by 赵冰冰 on 16/8/9.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHLeftNavButton.h"

@implementation RHLeftNavButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(27 / 2.0 + 3, 0, contentRect.size.width - 27 / 2.0 - 3, contentRect.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, CGRectGetMidY(contentRect) - 11 * 59 / 33 / 2, 11, 11 * 59 / 33);
}

@end
