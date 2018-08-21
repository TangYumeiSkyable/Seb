//
//  RHAccountTool.m
//  millHeater
//
//  Created by user on 16/5/3.
//  Copyright © 2016年 colin. All rights reserved.
//

#import "RHAccountTool.h"
#define RHAccountPath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation RHAccountTool
+ (void)saveAccount:(RHAccount *)account {
    [NSKeyedArchiver archiveRootObject:account toFile:RHAccountPath];
}

+ (RHAccount *)account {
    RHAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:RHAccountPath];
    return account ;
}

+ (RHAccount *)cleanAccount {
    RHAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:RHAccountPath];
    account.user_phoneNumber = nil;
    account.user_nickName = nil;
    account.user_password = nil;
    account.userImageurl = nil;
    account.userStatus = NO;
    account.user_ID = 0;
    account.headerImagePath = nil;
    
    account.longtidude = nil;
    account.latitude = nil;
    account.outdoorCity = nil;
    account.cityName = nil;
    account.province = nil;
    account.city  = nil;
    account.district = nil;
    account.airDic = @{};
    
    [RHAccountTool saveAccount:account];
    [ACAccountManager logout];
    return account;
}

@end
