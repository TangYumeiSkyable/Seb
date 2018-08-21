//
//  UIImage+NewSize.m
//  supor
//
//  Created by 刘杰 on 2018/4/10.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "UIImage+NewSize.h"

@implementation UIImage (NewSize)

- (UIImage *)imageWithSize:(CGSize)size {
    CGRect rect = (CGRect){0.f, 0.f, size};
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRect:rect].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageWithRoundedCornersSize:(CGSize)sizeToFit cornerRadius:(CGFloat)radius {
    CGRect rect = (CGRect){0.f, 0.f, sizeToFit};
    UIGraphicsBeginImageContextWithOptions(sizeToFit, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:rect];
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}
@end
