//
//  AppDelegate+Add.h
//  RHGourmia
//
//  Created by 赵冰冰 on 16/4/13.
//  Copyright © 2016年 rihui. All rights reserved.
//

#import "AppDelegate.h"

typedef void(^PushBlock) (NSDictionary * userInfo);

@interface AppDelegate (Add)

@property (nonatomic, strong) PushBlock callback;

@property (nonatomic, strong) NSDictionary *notifycationDict;//记录通知栏里面的消息

//设置友盟推送
- (void)setRemoteDefaultsWithLaunchOptions:(NSDictionary *)launchOptions;

- (void)registrationNotice;

//登录成功之后查询
- (void)queryUsersDevice;

//处理推送消息
- (void)handlePushNotificationWithUserInfo:(NSDictionary *)userInfo;

@end
