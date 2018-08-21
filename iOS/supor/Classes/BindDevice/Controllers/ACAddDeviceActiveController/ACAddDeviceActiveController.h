//
//  ACAddDeviceActiveController.h
//  supor
//
//  Created by Jun Zhou on 2017/11/16.
//  Copyright © 2017年 XYJ. All rights reserved.
//  提示让设备进入配网状态

#import <UIKit/UIKit.h>

@interface ACAddDeviceActiveController : UIViewController

@property (assign, nonatomic) NSInteger pageIdx;

@property (strong, nonatomic) NSDictionary *dataSourceDic;

@property (copy, nonatomic) NSString *domesticSsid;

@end
