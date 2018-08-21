//
//  AppDelegate.h
//  supor
//
//  Created by 赵冰冰 on 16/6/2.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AirAlertView.h"
#import "RHSubHomeItem.h"
#import <BLLetCore/BLLet.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/** selelcted language */
@property (nonatomic, strong) NSString *lan;

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) NSArray *deviceList;

@property (nonatomic, strong) RHSubHomeItem *wokeMode;

@property (nonatomic, strong) BLLet *let;

+ (instancetype)sharedInstance;

- (void)initializeLocationService;

- (void)setAlias:(NSString *)alias;

- (void)removeAlias:(NSString *)alias;

- (void)getWorkMode:(void (^)(RHSubHomeItem * wokeMode))finished failed:(void (^)(NSError * error))fail;

@end

