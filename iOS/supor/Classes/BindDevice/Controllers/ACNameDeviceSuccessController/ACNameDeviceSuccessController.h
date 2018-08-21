//
//  ACNameDeviceSuccessController.h
//  supor
//
//  Created by Jun Zhou on 2017/11/23.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACNameDeviceSuccessController : UIViewController

@property (assign, nonatomic) NSInteger pageIdx;
@property (strong, nonatomic) NSDictionary *dataSourceDic;
@property (copy, nonatomic) NSString *domesticSsid;
@property (strong, nonatomic) ACUserDevice *device;

@end
