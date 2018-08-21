//
//  RHAccount.h
//  millHeater
//
//  Created by user on 16/5/3.
//  Copyright © 2016年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHAccount : NSObject<NSCoding>
@property (nonatomic, strong) NSString *user_phoneNumber;
@property (nonatomic, strong) NSString *user_password;
@property (nonatomic, strong) NSString *user_nickName;
@property (nonatomic, strong) NSString *userImageurl;
@property (nonatomic, strong) NSString *headerImagePath;
@property (nonatomic, assign) BOOL userStatus;
@property (nonatomic, assign) NSInteger user_ID;

@property (nonatomic, strong) NSString * longtidude;
@property (nonatomic, strong) NSString * latitude;
// xx省 xx市 xx区
@property (nonatomic, strong) NSString * cityName;
//定位的省
@property (nonatomic, strong) NSString * province;
//定位的市
@property (nonatomic, strong) NSString * city;
//定位的区
@property (nonatomic, strong) NSString * district;
//室外城市
@property (nonatomic, strong) NSString * outdoorCity;

@property (nonatomic, strong) NSDictionary * airDic;

+ (RHAccount *)accountWithDic:(NSDictionary *)dic;

@end
