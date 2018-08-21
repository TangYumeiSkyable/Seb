//
//  JSBaseModel.m
//  supor
//
//  Created by 赵冰冰 on 16/6/29.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "JSBaseModel.h"

@implementation JSBaseModel

- (void)sendMessage:(NSString *)sendMessage withObject:(id)obj {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:sendMessage object:obj];
    });
}

- (void)sendMessage:(NSString *)sendMessage withObjectDict:(NSDictionary *)dict {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:sendMessage object:dict];
    });
  
}

- (void)sendMessage:(NSString *)sendMessage withObjectArray:(NSArray *)array {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:sendMessage object:array];
    });
}

@end
