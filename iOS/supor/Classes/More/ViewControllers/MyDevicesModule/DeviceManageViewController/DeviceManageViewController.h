//
//  DeviceManageViewController.h
//  supor
//
//  Created by 刘杰 on 2018/4/19.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ACUserDevice;

@interface DeviceManageViewController : UIViewController

@property (nonatomic, strong) ACUserDevice *device;

@property (nonatomic, strong) NSDictionary *deviceDic;

@end
