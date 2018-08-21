  //
//  AppDelegate.m
//  supor
//
//  Created by 赵冰冰 on 16/6/2.
//  Copyright © 2016年 XYJ. All rights reserved.
//
/*
 936518494@qq.com
 Cjp123456
 */
NSString * umengMsgAliasType2 = @"ablecloud";
static NSString *SDK_LICENSE = @"oaVRcfPDkQY9BHhNsGIxhIB3Y3czFvIoTbkNipMau/+bRfmjdxzJoseZKIlZ6fZPX/gpWgAAAABFbg1krj9iOj6mroFHBTBuiy7UlYtGpIc69fHLLpFEhkMR/aNoBz0DzLDggwndlCjaGPhRBbELuvc5tKGYQywMsEkbxXTfoUSQjDzWcfVjcAAAAAA=";

#import "AppDelegate.h"
#import "RHBaseNavgationController.h"
#import "LoginViewController.h"
#import "RootViewController.h"

#import <dlfcn.h>
#import <Fabric/Fabric.h>
#import <UMMobClick/MobClick.h>
#import <Crashlytics/Crashlytics.h>
#import <CoreLocation/CoreLocation.h>
#import "IQKeyboardManager/IQKeyboardManager.h"

#import "UMessage.h"
#import "ACloudLib.h"
#import "UAlertView.h"
#import "RHAccountTool.h"
#import "AFHTTPSessionManager.h"

#import "NSBundle+Language.h"
#import "AppDelegate+Add.h"

@interface AppDelegate ()<CLLocationManagerDelegate, UAlertViewDelegate, UIApplicationDelegate>
{
    CLLocationManager *_locationManager;
    int number1; //The number of times a user starts an application
}

@property (assign, nonatomic) BOOL isJumpRoot;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];
    // IQKeyboardManager
    [IQKeyboardManager sharedManager].canAdjustAdditionalSafeAreaInsets = true;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [RootViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self getSettingJson];
    self.notifycationDict = launchOptions;
    
    // 设置导航栏样式
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor classics_blue] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *dict = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:dict];
    
#ifdef DEBUG
    [ACloudLib setMode:ACLoudLibModeTest Region:ACLoudLibRegionChina];
    NSLog(@"中国测试环境");
    [ACloudLib setMode:ACLoudLibModeRouter Region:ACLoudLibRegionCentralEurope];
#else
    [ACloudLib setMode:ACLoudLibModeRouter Region:ACLoudLibRegionCentralEurope];
    NSLog(@"欧洲正式环境");
#endif
    [ACloudLib setMajorDomain:RHMAJORDOMAIN majorDomainId:RHMAJORDOMAINID];
    
    // 配置友盟推送
    [self setRemoteDefaultsWithLaunchOptions:launchOptions];
    // 初始化缓存账号信息
    RHAccount *account = [RHAccountTool account];
    if (account == nil) {
        account = [RHAccount new];
    }
    [RHAccountTool saveAccount:account];
    
    [DCPServiceUtils setDCPTokenInvalidCallback:^{
        RHBaseNavgationController *loginNC = [[RHBaseNavgationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        self.window.backgroundColor = [UIColor whiteColor];
        self.window.rootViewController = loginNC;
        [self.window makeKeyAndVisible];
    }];
    [self loadAppSdk];
    [self adaptive_iOS11];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if ([version floatValue]>=10.3) {
        [self appLaunchNumber];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

// Processing logic
- (void)appLaunchNumber
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //Gets the current APP version
    //获取当前APP版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //  Take out the local storage first
    number1 = (int)[userDefault integerForKey:@"numberCount"];
    //  First run
    if (number1 == 0) {
        
        number1 = 1;
        [userDefault setObject:appCurVersion forKey:@"appCurVersion"];
    }
    // Run after the first time
    else {
        //Determine if the version is updated
        //判断版本是否更新
        if (![appCurVersion isEqualToString:[userDefault objectForKey:@"appCurVersion"]]) {
            [userDefault removeObjectForKey:@"numberCount"];
        }
        number1++;
    }
    [userDefault setInteger:number1 forKey:@"numberCount"];
}


#pragma mark - UAlertViewDelegate
- (void)alertView:(UAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self exitApplication];
    } else {
        NSString *appstoreLinkString = [NSString stringWithFormat:@"https://itunes.apple.com/app/pure-air/id1350742593?ls=1&mt=8"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreLinkString]];
    }
}

- (void)exitApplication {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (manager == nil || newLocation == nil) {
        return;
    }
    
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary * userInfo = @{@"manager" : manager, @"newLocation" : newLocation};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LOCATION  object:nil userInfo:userInfo];
        });
    } else {
        NSDictionary * userInfo = @{@"manager" : manager, @"newLocation" : newLocation};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LOCATION  object:nil userInfo:userInfo];
    }
}

#pragma mark - Public Methods
+ (instancetype)sharedInstance {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)initializeLocationService {
    if (_locationManager != nil) {
        _locationManager = nil;
    }
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
}

- (void)setAlias:(NSString *)alias {
    [UMessage addAlias:alias
                  type:umengMsgAliasType2
              response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                  if (responseObject) {
                      RHLog(@"add alias success");
                  } else {
                      RHLog(@"add alias fail");
                  }
              }];
}

- (void)removeAlias:(NSString *)alias {
    [UMessage removeAlias:alias
                     type:umengMsgAliasType2
                 response:^(id responseObject, NSError *error) {
                     if(responseObject) {
                         RHLog(@"remove alias success");
                     } else {
                         RHLog(@"remove alias fail");
                     }
                 }];
}

- (void)getWorkMode:(void (^)(RHSubHomeItem * wokeMode))finished failed:(void (^)(NSError * error))fail {
    [ACAccountManager getUserProfile:^(ACObject *profile, NSError *error) {
        
        if (error == nil) {
            
            NSDictionary * dict = [profile getObjectData];
            NSString * json = dict[@"work_model"];
            
            NSData * data = nil;
            @try {
                data = [json dataUsingEncoding:NSUTF8StringEncoding];
            }
            @catch (NSException *exception) {
                
            }
            if (data) {
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                RHSubHomeItem * subItem = [RHSubHomeItem initWithDict:dic];
                finished(subItem);
            } else {
                finished(nil);
            }
        } else {
            fail(error);
        }
    }];
}

#pragma mark - Private Methods
- (void)getSettingJson {
    
    WEAKSELF(ws);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (ws.isJumpRoot == YES) return;
        ws.isJumpRoot = YES;
        [self adpatLanguage];
    });
    
    NSString *str1 = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *urlStr = [NSString stringWithFormat:@"https://sebplatform.api.groupe-seb.com/assets/PRO_AIR/app/database/ios/%@/settings.json", str1];

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *personInfo = responseObject;
             
             if ([personInfo[@"must_upgrade"] integerValue] == 1) {
                 [self goToUpdateApp];
             } else {
                 NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                 NSString *paths = [path objectAtIndex:0];
                 NSString *filepath = [paths stringByAppendingPathComponent:@"setting.json"];
                 [personInfo writeToFile:filepath atomically:YES];
                 
                 if (ws.isJumpRoot == YES) return;
                 ws.isJumpRoot = YES;
                 [self adpatLanguage];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (ws.isJumpRoot == YES) return;
             ws.isJumpRoot = YES;
             [self adpatLanguage];
         }];
}

- (void)goToUpdateApp {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    UAlertView *alert = [[UAlertView alloc] initWithTitle:GetLocalResStr(@"airpurifier_more_show_updatedevice_title")
                                                      msg:GetLocalResStr(@"airpurifier_update_tip_msg_start")
                                              cancelTitle:GetLocalResStr(@"airpurifier_update_tip_quit")
                                                  okTitle:GetLocalResStr(@"airpurifier_update_tip_goto")];
    alert.delegate = self;
    [alert show];
}

- (void)adpatLanguage {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AppleLanguages"];
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    RHLog(@"Country Code is %@", [currentLocale objectForKey:NSLocaleCountryCode]);
    RHLog(@"Language Code is %@", [currentLocale objectForKey:NSLocaleLanguageCode]);
    // get sandbox setting.json
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *paths = [path objectAtIndex:0];
    NSString *filepath = [paths stringByAppendingPathComponent:@"setting.json"];
    NSDictionary *dataDic = [[NSDictionary alloc] initWithContentsOfFile:filepath];
    // judge and determine whether to use language.plist
    if (dataDic.count == 0 || !dataDic) {
        dataDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Language" ofType:@"plist"]];
    }
    
    NSArray *langArr = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *systemLanguage = langArr.firstObject;
    RHLog(@"systemLanguage：%@",systemLanguage);
    
    NSString *country = [currentLocale objectForKey:NSLocaleCountryCode];
    // through the markets
    for (NSDictionary *marketsDic in (NSArray *)dataDic[@"markets"]) {
        NSArray *nameArr = [marketsDic[@"name"] componentsSeparatedByString:@"_"];
        if ([nameArr.lastObject isEqualToString:country]) {
            // through the availableLanguage
            for (NSString *availableLanguage in (NSArray *)marketsDic[@"available_lang"]) {
                @autoreleasepool {
                    NSString *tempLangeuage = @"";
                    // according to the national, change the language signal
                    if ([country isEqualToString:@"BE"]) {
                        tempLangeuage = [availableLanguage stringByAppendingString:[NSString stringWithFormat:@"-%@",country]];
                    } else if ([country isEqualToString:@"HK"]) {
                        tempLangeuage = [availableLanguage isEqualToString:@"zh"] ? @"zh-Hant-HK" : availableLanguage;
                    } else {
                        tempLangeuage = availableLanguage;
                    }
                    // use availabelLanguage
                    if ([tempLangeuage isEqualToString:systemLanguage] &&
                        [self isLanguagePackageContainAvailableLanguage:tempLangeuage]) {
                        
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AppleLanguages"];
                        NSArray *lans = @[tempLangeuage];
                        [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
                        [DCPServiceUtils setMarket:marketsDic[@"name"]];
                        [DCPServiceUtils setLanguage:tempLangeuage];
                        [NSBundle setLanguage:(NSString *)lans.firstObject];
                        [self showViewController];
                        return;
                    }
                }
            }
            // use defaultLanguage
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AppleLanguages"];
            NSString *defaultLanguage = marketsDic[@"default_lang"];
            NSArray *lans = @[defaultLanguage];
            [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
            [DCPServiceUtils setMarket:marketsDic[@"name"]];
            [DCPServiceUtils setLanguage:marketsDic[@"default_lang"]];
            if ([defaultLanguage isEqualToString:@"es"]) {
                [NSBundle setLanguage:[defaultLanguage stringByAppendingString:@"-ES"]];
            } else {
                [NSBundle setLanguage:(NSString *)lans.firstObject];
            }
            
            [self showViewController];
            return;
        }
    }
    // use English
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AppleLanguages"];
    NSArray *lans = @[@"en"];
    [DCPServiceUtils setMarket:dataDic[@"fallback_market"]];
    [DCPServiceUtils setLanguage:@"en"];
    [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
    [NSBundle setLanguage:(NSString *)lans.firstObject];
    [self showViewController];
    return;
}

- (BOOL)isLanguagePackageContainAvailableLanguage:(NSString *)target {
    NSArray *languagePackage = @[@"fr", @"de", @"es-ES", @"it", @"en", @"nl", @"fr-BE", @"nl-BE", @"zh-Hant-HK"];
    for (NSString *obj in languagePackage) {
        if ([obj isEqualToString:target]) {
            return YES;
        }
    }
    return NO;
}

- (void)loadAppSdk {
    self.let = [BLLet sharedLetWithLicense:SDK_LICENSE];  // Init AppSdk
    self.let.debugLog = BL_LEVEL_ALL;     // Set App SDK debug log level
    [self.let.controller setSDKRawDebugLevel:BL_LEVEL_ALL];   // Set DNA SDK Debug log level
}

- (void)showViewController {
    if ([ACAccountManager isLogin]) {
        [ACAccountManager getUserProfile:^(ACObject *profile, NSError *error) {
            if (error) {
                return;
            } else {
                NSDictionary *dataDic = [profile getObjectData];
                NSString *avatar = dataDic[@"_avatar"];
                RHAccount *account = [RHAccountTool account];
                account.userImageurl = avatar;
                [RHAccountTool saveAccount:account];
            }
        }];
        [self queryUsersDevice];
    } else {
        RHBaseNavgationController *loginNC = [[RHBaseNavgationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        self.window.backgroundColor = [UIColor whiteColor];
        self.window.rootViewController = loginNC;
        [self.window makeKeyAndVisible];
    }
}

- (void)adaptive_iOS11 {
    if (@available(iOS 11,*)) {
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UIWebView appearance].scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}

@end
