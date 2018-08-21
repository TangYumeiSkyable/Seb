//
//  JSTimerModel.m
//  supor
//
//  Created by 赵冰冰 on 16/7/1.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "JSTimerModel.h"

@implementation JSTimerModel

-(void)openTask:(NSString *)str_device :(NSString *)str_task
{
    NSDictionary * dict = @{@"deviceId" : str_device, @"taskId" : str_task};
    [self sendMessage:NOTIFY_OPEN_TASK withObjectDict:dict];
}

-(void)closeTask:(NSString *)str_deviceId :(NSString *)str_task
{
    NSDictionary * dict = @{@"deviceId" : str_deviceId, @"taskId" : str_task};
    [self sendMessage:NOTIFY_CLOSE_TASK withObjectDict:dict];
}

-(void)modifyTask:(NSString *)str_deviceId :(NSString *)name :(NSString *)model :(NSString *)timePoint :(NSString *)endTime
{
    NSDictionary * dict = @{@"deviceId" : str_deviceId, @"deviceName": name, @"model":model, @"timePoint" : timePoint, @"endTime" : endTime};
    [self sendMessage:NOTIFY_MODIFY_TASK withObjectDict:dict];
}

-(void)pageChangeM:(NSString *)pagestr :(NSString *)str_deviceId :(NSString *)deviceName :(NSString *)str_taskId
{
    NSArray * arr = @[pagestr, str_deviceId, deviceName, str_taskId];
    [self sendMessage:NOTIFY_MODIFY_APPOINT withObjectArray:arr];
}

-(void)addTask:(NSString *)str_deviceId :(NSString *)name :(NSString *)model :(NSString *)timePoint :(NSString *)endTime 
{
    [self sendMessage:NOTIFY_ADDTASK withObjectArray:@[str_deviceId, name, model, timePoint, endTime]];
}

-(void)returnRepeat:(NSString *)week :(NSString *)repeat
{
    [self sendMessage:NOTIFY_SET_TIME withObjectArray:@[week, repeat]];
}

-(void)delTimer:(NSString *)deviceId :(NSString *)taskId
{
    [self sendMessage:NOTIFY_DELETE_APPOINT withObjectArray:@[deviceId, taskId]];
}

//1.列表 2.新建 3.修改 4.星期
-(void)pageChange:(NSString *)index
{
    [self sendMessage:NOTIFY_ADD_APPOINT withObject:index];
}

@end
