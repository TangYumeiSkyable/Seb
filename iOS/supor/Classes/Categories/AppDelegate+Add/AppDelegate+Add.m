//
//  AppDelegate+Add.m
//  RHGourmia
//
//  Created by 赵冰冰 on 16/4/13.
//  Copyright © 2016年 rihui. All rights reserved.
//


#define IOS10 (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max)?(YES):(NO)

#import "AppDelegate+Add.h"
#import "UMessage.h"
#import <objc/runtime.h>
#import "ACloudLib.h"
#import "RHBaseNavgationController.h"
#import "RHHomeViewController.h"
#import "SuporMallViewController.h"

#if IOS10
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@property (nonatomic, assign) BOOL hanlePush;

@end

@implementation AppDelegate (Add)

#pragma mark - runtime add property
- (void)setHanlePush:(BOOL)hanlePush {
    objc_setAssociatedObject(self, @selector(hanlePush), @(hanlePush), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)hanlePush {
    return objc_getAssociatedObject(self, @selector(hanlePush));
}

- (void)setNotifycationDict:(NSDictionary *)notifycationDict {
    objc_setAssociatedObject(self, @selector(notifycationDict), notifycationDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)notifycationDict {
    return objc_getAssociatedObject(self, @selector(notifycationDict));
}

- (void)setCallback:(PushBlock)callback {
    objc_setAssociatedObject(self, @selector(callback), callback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (PushBlock)callback {
    return objc_getAssociatedObject(self, @selector(callback));
}

#pragma mark - Public Methods
- (void)setRemoteDefaultsWithLaunchOptions:(NSDictionary *)launchOptions {
    [UMessage startWithAppkey:CONSTANT_UMENG_KEY launchOptions:launchOptions];
    [UMessage setLogEnabled:YES];
}

- (void)registrationNotice {
    [UMessage registerForRemoteNotifications];
    
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        UNAuthorizationOptions types10 = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                
            } else {
                
            }
        }];
    }
}

- (void)queryUsersDevice {
    self.window.backgroundColor = [UIColor whiteColor];
    RHHomeViewController * homeVC = [[RHHomeViewController alloc] init];
    RHBaseNavgationController * nc = [[RHBaseNavgationController alloc] initWithRootViewController:homeVC];
    self.window.rootViewController = nc;
    [self.window makeKeyAndVisible];
    //表示点击通知栏进入
    
    
    NSString *str = nil;
    if (self.notifycationDict == nil) {
        str = @"";
    } else {
        str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self.notifycationDict options: NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    }
    
    if (!IOS10) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self handlePushNotificationWithUserInfo:[self.notifycationDict objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
            self.notifycationDict = nil;
        });
    }
}

#pragma mark -推送的代理
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UMessage registerDeviceToken:deviceToken];
    NSString *fullDeviceToken = [NSString stringWithFormat:@"%@",deviceToken];
    NSString *deviceTokenStr = [[fullDeviceToken substringWithRange:NSMakeRange(1, [fullDeviceToken length]-2)] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@", deviceTokenStr);
    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
    //如果注册成功，可以删掉这个方法
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

- (void)handlePushNotificationWithUserInfo:(NSDictionary *)userInfo {
    
    if (userInfo == nil || [userInfo isKindOfClass:[NSNull class]] || ![ACAccountManager isLogin]) {
        return;
    }
    
    NSNumber *n = userInfo[@"notifyType"];
    __block ACUserDevice *mDevice = nil;
    
    if (n.integerValue == 0) {
        [ACBindManager listDevicesWithStatusCallback:^(NSArray *devices, NSError *error) {
            
            if (error == nil) {
                
                if (devices.count > 0) {
                    NSInteger deviceId  = [userInfo[@"deviceId"] integerValue];
                    
                    
                    for (ACUserDevice *device in devices) {
                        
                        if (deviceId == device.deviceId) {
                            mDevice = device;
                            break;
                        }
                    }
                    NSString *msg = nil;
                    if (mDevice) {
                        msg = [NSString stringWithFormat:GetLocalResStr(@"airpurifier_push_lv_alert_content_ios"), mDevice.deviceName,[userInfo objectForKey:@"filterName"], userInfo[@"cost"]];
                    } else {
                        msg = [NSString stringWithFormat:@"您的%@已经消耗%@%%以上,为保障净化质量,请及时更换",[userInfo objectForKey:@"filterName"], userInfo[@"cost"]];
                    }
                    
                    AirAlertView * alert = [AirAlertView initCloseWithTitle:msg
                                                                settingTime:nil
                                                                     okText:GetLocalResStr(@"airpurifier_push_alert_lv_yes")
                                                                 cancelText:GetLocalResStr(@"airpurifier_push_alert_pm_no")];
                    alert.indexChanged = ^(NSInteger idx){
                        if (idx == 0) {
                            RHLog(@"不再提醒");
                            
                            ACObject *profile = [[ACObject alloc] init];
                            [profile putBool:@"notifyFlg2" value:NO];
                            [ACAccountManager setUserProfile:profile callback:^(NSError *err) {
                                if (err == nil) {
                                    RHLog(@"修改成功");
                                } else {
                                    [ZSVProgressHUD showErrorWithStatus:TIPS_FAILED];
                                }
                            }];
                        } else {
                            RHLog(@"webview商城页面");
                            SuporMallViewController *mallVC = [[SuporMallViewController alloc]init];
                            mallVC.fromType = 1;
                            UINavigationController *mallNC = [[UINavigationController alloc]initWithRootViewController:mallVC];
                            UINavigationController *currentNC = (UINavigationController *)self.window.rootViewController;
                            [currentNC presentViewController:mallNC animated:YES completion:nil];
                        }
                    };
                    [alert show];
                }
            }
        }];
    }
    
    if (n.integerValue == 1) {
        
        NSInteger tag = [userInfo[@"hcho"] integerValue];
        
        NSString * hcho = @"";
        if (tag == 1) {
            hcho = GetLocalResStr(@"airpurifier_push_home_you_ios");
        }else if (tag == 2){
            hcho = GetLocalResStr(@"airpurifier_push_show_poor_text_ios");
        }else if (tag == 3){
            hcho = GetLocalResStr(@"airpurifier_push_qing_ios");
        }else if (tag == 4){
            hcho = GetLocalResStr(@"airpurifier_push_zhong_ios");
        }else if (tag == 5){
            hcho = GetLocalResStr(@"airpurifier_push_zhongdu_ios");
        }
        
        AirAlertView * alert = [AirAlertView initWithTitle:GetLocalResStr(@"airpurifier_push_pm_alert_title_ios")
                                                        pm:[NSString stringWithFormat:@"%@", userInfo[@"PM25"]]
                                                     oxide:hcho
                                                    detail:GetLocalResStr(@"airpurifier_push_pm_alert_content_ios")];
        alert.indexChanged = ^(NSInteger idx){
            if (idx == 0) {
                RHLog(@"不再更换");
                ACObject * profile = [[ACObject alloc]init];
                [profile putBool:@"notifyFlg1" value:NO];
                [ACAccountManager setUserProfile:profile callback:^(NSError *err) {
                    if (err == nil) {
                        RHLog(@"修改成功");
                    } else {
                        [ZSVProgressHUD showErrorWithStatus:TIPS_FAILED];
                    }
                }];
            } else {
                NSString *deviceID = [userInfo objectForKey:@"deviceId"];
                [ACBindManager listDevicesWithStatusCallback:^(NSArray *devices, NSError *error) {
                    if (error == nil) {
                        if (devices.count > 0) {
                            NSInteger deviceId  = [userInfo[@"deviceId"] integerValue];
                            ACUserDevice * mDevice = nil;
                            for (ACUserDevice * device in devices) {
                                if (deviceId == device.deviceId) {
                                    mDevice = device;
                                    break;
                                }
                            }
                            [self openAirCleaner:deviceID.longLongValue value:1 command:@"on_off" subDomainName:mDevice.subDomain];
                        }
                    }
                }];
            }
        };
        [alert show];
    }
    
    if (n.integerValue == 2) {
        [ACBindManager listDevicesWithStatusCallback:^(NSArray *devices, NSError *error) {
            if (error == nil) {
                if (devices.count > 0) {
                    NSInteger deviceId  = [userInfo[@"deviceId"] integerValue];
                    ACUserDevice * mDevice = nil;
                    for (ACUserDevice * device in devices) {
                        if (deviceId == device.deviceId) {
                            mDevice = device;
                            break;
                        }
                    }
                    
                    NSString * msg = nil;
                    if (mDevice) {
                        msg = [NSString  stringWithFormat:GetLocalResStr(@"airpurifier_push_msg"),userInfo[@"time"]];
                    } else {
                        msg = [NSString  stringWithFormat:GetLocalResStr(@"airpurifier_push_msg"),userInfo[@"time"]];
                    }
                    
                    AirAlertView * alert = [AirAlertView initWithTitle:msg
                                                           settingTime:GetLocalResStr(@"airpurifier_more_show_setbusinesstime_text")
                                                                okText:GetLocalResStr(@"airpurifier_push_alert_pm_no")
                                                            cancelText:GetLocalResStr(@"airpurifier_push_alert_pm_yes")];
//                    __weak AirAlertView * weakAlert = alert; 
                    alert.indexChanged = ^(NSInteger idx){
                        if (idx == 1) {
                            RHLog(@"不再更换");
                            
                            ACObject * profile = [[ACObject alloc]init];
                            [profile putBool:@"notifyFlg3" value:NO];
                            
                            [ACAccountManager setUserProfile:profile callback:^(NSError *err) {
                                if (err == nil) {
                                    RHLog(@"修改成功");
                                } else {
                                    [ZSVProgressHUD showErrorWithStatus:TIPS_FAILED];
                                }
                            }];
                            
                        } else if(idx == 0) {
                            //                RHLog(@"开启空气净化器");
                            NSString * deviceIdsStr = [userInfo objectForKey:@"deviceId"];
                            NSArray * deviceArr = [deviceIdsStr componentsSeparatedByString:@","];
                            for (NSString * deviceIdStr in deviceArr) {
                                [self openAirCleaner:deviceIdStr.integerValue value:1 command:@"on_off" subDomainName:mDevice.subDomain];
                            }
                        } else if (idx == -1){
                            RHLog(@"h5去设置上班时间页面");
                        }
                    };
                    [alert show];
                }
            }
        }];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessage setAutoAlert:NO];
    RHLog(@"userinfo is %@", userInfo);
    
    if (self.window.rootViewController == nil) {
        self.hanlePush = YES;
    } else {
        [self handlePushNotificationWithUserInfo:userInfo];
    }
}

#pragma mark - iOS10UserNotificaitons
#if IOS10
//应用在前台接受到推送
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    RHLog(@"ios 10 forward notification is %@", response);
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    [self handlePushNotificationWithUserInfo:userInfo];
}

//点击通知栏进入
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    RHLog(@"ios10 background notification is %@", notification);
    NSDictionary * userInfo = notification.request.content.userInfo;
    [self handlePushNotificationWithUserInfo:userInfo];
}
#endif

- (void)openAirCleaner:(long long)deviceId value:(NSInteger)value command:(NSString *)commond subDomainName:(NSString *)subDomainName {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD show];
    
    [http_ requestWithMessageName:@"controlDeviceInfo" callback:^(ACMsg *responseObject, NSError *error) {
        [SVProgressHUD dismiss];
        if (error == nil) {
            
        } else {
            if (error.code == 3807) {
                [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_moredevice_show_devicenotonline_text")];
            } else {
                [ZSVProgressHUD showSimpleText:TIPS_FAILED_CONTROL];
            }
        }
    } andKeyValues:@"deviceId", @(deviceId), @"value" , @(value), @"commend", commond, @"sn", @(1), @"subDomainName", subDomainName,nil];
}

@end

