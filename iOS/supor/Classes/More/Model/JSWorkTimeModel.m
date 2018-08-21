//
//  JSWorkTimeModel.m
//  supor
//
//  Created by 赵冰冰 on 16/6/29.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "JSWorkTimeModel.h"

@implementation JSWorkTimeModel

-(void)noDeviceToast
{
    [self sendMessage:NOTIFY_SHOW_TOAST withObject:nil];
}

-(void)modifySaved:(NSString *)str
{
    [self sendMessage:NOTIFY_MODIFY_SAVED withObject:str];
}

-(void)returnRepeat:(NSString *)week :(NSString *)repeat
{
    NSDictionary * dict = @{@"week" : week , @"repeat" : repeat};
    [self sendMessage:NOTIFY_RETURN_REPEAT withObjectDict:dict];
}

-(void)pageChange:(NSString *)page
{
    [self sendMessage:NOTIFY_REPEAT withObject:page];
}

@end
