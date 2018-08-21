//
//  ACDeviceUtils.h
//  supor
//
//  Created by Jun Zhou on 2017/11/15.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    
    CGSize  screenSize;
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    BOOL isIPhone;
    BOOL isIPhoneX;
    
    // 状态栏高度
    CGFloat statusBarHeight;
    
    // 底部安全区域高度
    CGFloat bottomSafeHeight;
    
    // tab栏高度(包含安全区域距离)
    CGFloat tabBarHeight;
    
    // 导航栏高度
    CGFloat navigationBarHeight;
    
    // 导航栏 & 状态栏 高度
    CGFloat navigationStatusBarHeight;
    
} ACDeviceStruct;

extern ACDeviceStruct DeviceUtils;


NSString * GetSubDomainWithSubDomainId(NSInteger subDomainId);

NSString * GetProductNameWithSubDomainId(NSInteger subDomainId);
