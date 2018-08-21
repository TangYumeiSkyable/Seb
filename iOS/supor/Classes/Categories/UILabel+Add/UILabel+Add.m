//
//  UILabel+Add.m
//  supor
//
//  Created by 白云杰 on 2017/5/15.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "UILabel+Add.h"

@implementation UILabel (Add)

+ (CGSize)labelRectWithSize:(CGSize)size labelText:(NSString *)labelText Font:(UIFont *)font {
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    CGSize actualsize = [labelText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return actualsize;
}

@end
