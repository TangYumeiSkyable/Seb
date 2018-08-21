//
//  RHLeftButton.m
//  supor
//
//  Created by 赵冰冰 on 16/6/20.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHLeftButton.h"

@implementation RHLeftButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(27 / 2.0 + 3, 0, contentRect.size.width - 27 / 2.0 - 3, contentRect.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, CGRectGetMidY(contentRect) - 15 / 4.0, 27 / 2.0, 15 / 2.0);
}
@end
