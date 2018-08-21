//
//  UIImage+NewSize.h
//  supor
//
//  Created by 刘杰 on 2018/4/10.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NewSize)

- (UIImage *)imageWithSize:(CGSize)size;

- (UIImage *)imageWithRoundedCornersSize:(CGSize)sizeToFit cornerRadius:(CGFloat)radius;

@end
