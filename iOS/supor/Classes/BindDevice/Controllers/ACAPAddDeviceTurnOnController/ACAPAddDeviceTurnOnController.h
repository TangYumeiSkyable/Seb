//
//  ACAPAddDeviceTurnOnController
//  supor
//
//  Created by Jun Zhou on 2017/11/15.
//  Copyright © 2017年 XYJ. All rights reserved.
//  提示打开设备开关

#import <UIKit/UIKit.h>

@interface ACAPAddDeviceTurnOnController : UIViewController

/**
 currentPage Number
 用于控制页面上方当前页的UI显示
 */
@property (assign, nonatomic) NSInteger pageIdx;

/**
 设备相关属性字典
 */
@property (strong, nonatomic) NSDictionary *dataSourceDic;

@property (copy, nonatomic) NSString *domesticSsid;

@end
