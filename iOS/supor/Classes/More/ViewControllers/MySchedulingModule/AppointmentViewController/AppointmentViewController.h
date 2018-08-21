//
//  AppointmentViewController.h
//  supor
//
//  Created by 赵冰冰 on 16/6/30.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHBaseWebVC.h"

typedef NS_ENUM(NSUInteger, SchedulingFromType) {
    SchedulingFromMore = 0,
    SchedulingFromHome
};

@interface AppointmentViewController : RHBaseWebVC

@property (nonatomic, assign) SchedulingFromType lastControllerType;

@property (nonatomic, strong) NSString *deviceName;

@property (nonatomic, assign) long long deviceId;

@end
