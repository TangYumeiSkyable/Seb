//
//  ShareDeviceViewController.h
//  supor
//
//  Created by 刘杰 on 2018/4/21.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ACUserDevice;

@interface ShareDeviceViewController : UIViewController

@property (nonatomic, strong) ACUserDevice *device;

@property (nonatomic, strong) NSDictionary *deviceInfoDic;

@end
