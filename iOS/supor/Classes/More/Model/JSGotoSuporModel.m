//
//  JSGotoSuporModel.m
//  supor
//
//  Created by 赵冰冰 on 16/9/2.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "JSGotoSuporModel.h"

@implementation JSGotoSuporModel

-(void)toSupor:(int)value {
    [self sendMessage:NOTIFY_GOTOSUPOR withObject:@(value)];
}

@end
