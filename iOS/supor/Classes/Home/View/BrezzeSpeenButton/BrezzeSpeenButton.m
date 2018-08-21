//
//  BrezzeSpeenButton.m
//  supor
//
//  Created by 赵冰冰 on 16/6/21.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "BrezzeSpeenButton.h"

@implementation BrezzeSpeenButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return  CGRectMake(17 + 17, 0, contentRect.size.width - 17 - 17, contentRect.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return  CGRectMake(13.5, CGRectGetMidY(contentRect) - 8, 14, 14);
}

-(CGRect)backgroundRectForBounds:(CGRect)bounds
{
    CGFloat x = bounds.origin.x + 1;
    CGFloat y = bounds.origin.y ;
    CGFloat w = bounds.size.width - 2;
    CGFloat h = bounds.size.height - 2;
    return CGRectMake(x, y, w, h);
}

@end
