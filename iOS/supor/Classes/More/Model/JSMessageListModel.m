//
//  JSMessageListModel.m
//  supor
//
//  Created by 赵冰冰 on 16/6/30.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "JSMessageListModel.h"

@implementation JSMessageListModel

-(void)setReadFlg:(NSString *)msg
{
    [self sendMessage:NOTIFY_SETREADFLAG withObject:msg];
}

-(void)getMessage:(NSString *)msg
{
    [self sendMessage:NOTIFY_MESSAGE_ADVISER withObject:msg];
}

-(void)openAirCleaner:(NSString *)msg
{
    [self sendMessage:NOTIFY_OPEN_AIR withObject:msg];
}

-(void)toSupor
{
    [self sendMessage:NOTIFY_GOTOSUPOR withObject:nil];
}

@end
