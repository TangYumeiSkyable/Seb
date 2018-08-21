//
//  NSDate+category.m
//  supor
//
//  Created by 刘杰 on 2018/5/2.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "NSDate+category.h"

@implementation NSDate (category)

+ (NSString *)getCurrentTimeStamp {
    return [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970] * 1000];
}

@end
