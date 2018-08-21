//
//  ACDeviceUtils.m
//  supor
//
//  Created by Jun Zhou on 2017/11/15.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "ACDeviceUtils.h"

ACDeviceStruct DeviceUtils;

/**
 * GCC的扩展语法（黑魔法），由它修饰过的函数，会在main函数之前调用。原理是在ELF的.ctors段增加一条函数引用
 * 加载器在执行main函数前，检查.ctror section，并执行里面的函数。
 * 如果有多个attribute((constructor))修饰的函数有依赖，他们调用顺序是不确定的
 *
 */

__attribute__ ((constructor)) static void initialize_ACDeviceUtils () {
    
    DeviceUtils.screenWidth         = [UIScreen mainScreen].bounds.size.width;
    DeviceUtils.screenHeight        = [UIScreen mainScreen].bounds.size.height;
    DeviceUtils.screenSize          = [UIScreen mainScreen].bounds.size;
    
    DeviceUtils.isIPhone            = [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"];
    DeviceUtils.isIPhoneX           = (DeviceUtils.isIPhone && DeviceUtils.screenHeight == 812);
    
    DeviceUtils.statusBarHeight           = (DeviceUtils.isIPhoneX ? 44 : 20);
    DeviceUtils.bottomSafeHeight          = (DeviceUtils.isIPhoneX ? 34 : 0);
    DeviceUtils.tabBarHeight              = 49 + DeviceUtils.bottomSafeHeight;
    DeviceUtils.navigationBarHeight       = 44;
    DeviceUtils.navigationStatusBarHeight = DeviceUtils.navigationBarHeight + DeviceUtils.statusBarHeight;
}

static NSDictionary<NSNumber *, NSString *> *subDomainIdSubDomainictionary;

NSString * GetSubDomainWithSubDomainId(NSInteger subDomainId) {
    if (subDomainIdSubDomainictionary.count == 0) {
        subDomainIdSubDomainictionary = @{
                                          @(5376) : @"rowentaxl",
                                          @(5561) : @"rowentaxs",
                                          @(5135) : @"test",
                                          @(6495) : @"rowentaxlus",
                                          @(6496) : @"rowentaxsus",
                                          @(6497) : @"tefalxl",
                                          @(6498) : @"tefalxs",
                                          };
    }
    return subDomainIdSubDomainictionary[@(subDomainId)];
}

static NSDictionary<NSNumber *, NSString *> *nameSubDomainictionary;

NSString * GetProductNameWithSubDomainId(NSInteger subDomainId) {
    if (nameSubDomainictionary.count == 0) {
        nameSubDomainictionary = @{
                                          @(5376) : @"Intense Pure Air XL Connect",
                                          @(5561) : @"Intense Pure Air Connect",
                                          @(5135) : @"product",
                                          @(6495) : @"Rowenta XL US",
                                          @(6496) : @"rowenta XS US",
                                          @(6497) : @"Tefal XL",
                                          @(6498) : @"Tefal XS",

                                          };
    }
    return nameSubDomainictionary[@(subDomainId)];
}
