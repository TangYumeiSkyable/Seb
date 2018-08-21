//
//  JSSelectTimerModel.m
//  supor
//
//  Created by 赵冰冰 on 16/7/6.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "JSSelectTimerModel.h"

@implementation JSSelectTimerModel

- (void)setTime:(NSString *)time {
    [self sendMessage:NOTIFY_PERSON_SELECTTIMER withObject:time];
}

-(void)cancle {
    [self sendMessage:NOTIFY_PERSON_CANCELTIMER  withObject:nil];
}

@end
