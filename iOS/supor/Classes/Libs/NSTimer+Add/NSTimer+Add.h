//
//  NSTimer+Add.h
//  AirButler
//
//  Created by 赵冰冰 on 16/9/29.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Add)

+ (NSTimer *)m_scheduledTimerWithTimeInterval:(NSTimeInterval)ti  block:(void (^)(NSTimer * mTimer))block;

@end
