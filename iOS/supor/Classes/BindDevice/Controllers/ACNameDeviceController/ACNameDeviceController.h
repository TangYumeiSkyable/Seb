//
//  ACNameDeviceController.h
//  supor
//
//  Created by Jun Zhou on 2017/11/23.
//  Copyright © 2017年 XYJ. All rights reserved.
//  设备重命名页面

#import <UIKit/UIKit.h>

@interface ACNameDeviceController : UIViewController

@property (assign, nonatomic) NSInteger pageIdx;

@property (strong, nonatomic) NSDictionary *dataSourceDic;

@property (copy, nonatomic) NSString *domesticSsid;

@property (strong, nonatomic) ACUserDevice *device;

@end
