//
//  NSTimer+Add.m
//  AirButler
//
//  Created by 赵冰冰 on 16/9/29.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "NSTimer+Add.h"

@implementation NSTimer (Add)

+ (void)updateTimer:(NSTimer *)timer {
    if (timer.userInfo) {
        void (^block)(NSTimer * timer) = timer.userInfo;
        block(timer);
    }
}

+ (NSTimer *)m_scheduledTimerWithTimeInterval:(NSTimeInterval)ti  block:(void (^)(NSTimer * mTimer))block {
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(updateTimer:) userInfo:[block copy] repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    return timer;
}

@end
