//
//  RenameViewController.h
//  supor
//
//  Created by 刘杰 on 2018/4/19.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RenameResultBlock)(NSString *);

@class ACUserDevice;


typedef NS_ENUM(NSInteger, RenameType) {
    RenameNicknameType,
    RenameDeviceNameType,
    RenameShareDeviceWithEmailType
};

@interface RenameViewController : UIViewController

@property (nonatomic, assign) RenameType renameType;

@property (nonatomic, strong) ACUserDevice *device;

@property (nonatomic, copy) RenameResultBlock renameBlock;

@end
