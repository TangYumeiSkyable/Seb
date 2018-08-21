//
//  RHBaseItem.m
//  millHeater
//
//  Created by 赵冰冰 on 16/5/3.
//  Copyright © 2016年 colin. All rights reserved.
//

#import "RHBaseItem.h"

@implementation RHBaseItem

+ (id)initWithDict:(NSDictionary *)dict {
    return [[self class] mj_objectWithKeyValues:dict];
}
+ (NSArray *)initWithArray:(NSArray *)data {
    return [self mj_objectArrayWithKeyValuesArray:data];
}
@end
