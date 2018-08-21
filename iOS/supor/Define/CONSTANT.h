//
//  CONSTANT.h
//  millHeater
//
//  Created by 赵冰冰 on 16/4/18.
//  Copyright © 2016年 colin. All rights reserved.
//

/*
  57720c7b67e58ed708002712 appkey
 0awqkyxddrsnhgj9evcaibjjfeldqnjf App Master Secret
 */

#import "ACDeviceUtils.h"
#import "ACAccountManager.h"
#import "ACBindManager.h"
#import "ACWifiLinkManager.h"
#import "ACUserDevice.h"
#import "ACObject.h"
#import "ACMsg.h"
#import "ACServiceClient.h"
#import "RHSysUtil.h"
#import "ACServiceClient.h"
#import "RHHttpBase.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "ZSVProgressHUD.h"
#import "SVProgressHUD.h"
#import "Masonry.h"
#import "LanguageManager.h"
#import "DCPServiceUtils.h"

// category
#import "UIFont+font.h"
#import "UIColor+LJHex.h"
#import "UIColor+FlatUI.h"
#import "UIImage+FlatUI.h"
#import "UIImage+NewSize.h"
#import "UIView+Category.h"
#import "NSDate+category.h"
#import "UIColor+Classics.h"
#import "MBProgressHUD+MJ.h"
#import "SVProgressHUD+Add.h"
#import "UIImageView+WebCache.h"
#import "UIImagePickerController+statusbar.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

static const CGFloat standardFontSize = 17.0;
static NSString * const CONSTANT_UMENG_KEY = @"5aacc68db27b0a0a2b0000cf";

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height
#define kRatio (kMainScreenWidth / 320)
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)
#define LineColor [UIColor colorWithWhite:0 alpha:0.2]

#define WEAKSELF(ws) __weak typeof(self) ws = self
#define GETIMG(__name) [UIImage imageNamed:__name]

#define APPDELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate
#define GetLocalResStr(key) NSLocalizedString(key, nil)
#define isExist(obj) (obj!= nil && (![obj isKindOfClass:[NSNull class]]))
#define isStrExist(obj) (obj!= nil && (![obj isKindOfClass:[NSNull class]])

// 产品平台相关参数
/** 域名 **/
#define RHMAJORDOMAIN  @"groupeseb"
/** 端口 **/
#define RHMAJORDOMAINID  5133
/** wifi名 **/
//#define RHWIFILINKERNAME @"easylink"
/** 子域名 **/
#define RHSUBDOMAIN @"rowentaxl"
/** 子域ID **/
#define RHSUBDOMAINID 5376
/** 服务名 **/
#define RHService @"SEBService"
/** 服务名版本号 **/
#define RHServiceVersion 1


#ifdef DEBUG
#define RHLog(...) NSLog(__VA_ARGS__)
#else
#define RHLog(...)
#endif

#define UD_HOTLINE @"hotline_num"
#define UD_AFTERSALE @"aftersale"
#define UD_COOKIES  @"ud_cookies"
