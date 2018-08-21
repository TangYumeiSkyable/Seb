//
//  JSTimerModel.h
//  supor
//
//  Created by 赵冰冰 on 16/7/1.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "JSBaseModel.h"

@protocol JSTimerModel <JSExport>

-(void)delTimer:(NSString *)deviceId :(NSString *)taskId;
-(void)pageChange:(NSString *)index;
-(void)returnRepeat:(NSString *)week :(NSString *)repeat;
-(void)addTask:(NSString *)str_deviceId :(NSString *)name :(NSString *)model :(NSString *)timePoint :(NSString *)endTime;
-(void)pageChangeM:(NSString *)pagestr :(NSString *)str_deviceId :(NSString *)deviceName :(NSString *)str_taskId;
-(void)modifyTask:(NSString *)str_deviceId :(NSString *)name :(NSString *)model :(NSString *)timePoint :(NSString *)endTime;
-(void)openTask:(NSString *)str_device :(NSString *)str_task;
-(void)closeTask:(NSString *)str_deviceId :(NSString *)str_task;

@end

@interface JSTimerModel : JSBaseModel<JSTimerModel>

@end
