//
//  ACAddDeviceConnectDomesticController.h
//  supor
//
//  Created by Jun Zhou on 2017/11/16.
//  Copyright © 2017年 XYJ. All rights reserved.
//  输入wifi密码，设备开始联网、连云
//  多个界面在同一个控制器中

#import <UIKit/UIKit.h>

@interface ACAddDeviceConnectDomesticController : UIViewController

@property (assign, nonatomic) NSInteger pageIdx;

@property (strong, nonatomic) NSDictionary *dataSourceDic;

@property (copy, nonatomic) NSString *domesticSsid;

@end
