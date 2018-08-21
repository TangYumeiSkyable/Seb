//
//  ACAddDeviceConnectController.h
//  supor
//
//  Created by Jun Zhou on 2017/11/16.
//  Copyright © 2017年 XYJ. All rights reserved.
//  提示进入设置中链接设备AP热点

#import <UIKit/UIKit.h>

@interface ACAddDeviceConnectController : UIViewController

@property (assign, nonatomic) NSInteger pageIdx;

@property (strong, nonatomic) NSDictionary *dataSourceDic;

@property (copy, nonatomic) NSString *domesticSsid;

@end
