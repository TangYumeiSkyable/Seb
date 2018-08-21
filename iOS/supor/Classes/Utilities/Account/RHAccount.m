//
//  RHAccount.m
//  millHeater
//
//  Created by user on 16/5/3.
//  Copyright © 2016年 colin. All rights reserved.
//

#import "RHAccount.h"

@implementation RHAccount
+ (RHAccount *)accountWithDic:(NSDictionary *)dic {
    RHAccount *account = [[RHAccount alloc] init];
    account.user_phoneNumber = dic[@"user_phoneNumber"];
    account.user_password = dic[@"user_password"];
    account.user_nickName = dic[@"user_nickName"];
    account.userImageurl = dic[@"userImageurl"];
    account.userStatus = [dic[@"userStatus"] boolValue];
    account.user_ID = [dic[@"user_ID"] integerValue];
    account.headerImagePath = dic[@"headerImagePath"];
    return account ;
}

- (NSString *)city {
    if (isExist(_city) && (_city.length != 0)) {
        return _city;
    }
    return @"--";
}

- (NSString *)longtidude {
    if (isExist(_longtidude) && (_longtidude.length != 0)) {
        return _longtidude;
    }
    return @"39.26";
}

- (NSString *)latitude {
    if (isExist(_latitude) && (_latitude.length != 0)) {
        return _latitude;
    }
    return @"115.25";
}

- (NSString *)outdoorCity {
    if (_outdoorCity == nil || [_outdoorCity isEqualToString:@""] || (_outdoorCity == (NSString *)[NSNull null])) {
        return @"--";
    }
    return _outdoorCity;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.user_phoneNumber forKey:@"user_phoneNumber"];
    [aCoder encodeObject:self.user_password forKey:@"user_password"];
    [aCoder encodeObject:self.user_nickName forKey:@"user_nickName"];
    [aCoder encodeObject:self.userImageurl forKey:@"userImageurl"];
    [aCoder encodeBool:self.userStatus forKey:@"userStatus"];
    [aCoder encodeInteger:self.user_ID forKey:@"user_ID"];
    [aCoder encodeObject:self.headerImagePath forKey:@"headerImagePath"];
    
    @try {
        
        [aCoder encodeObject:self.longtidude forKey:@"longtidude"];
        [aCoder encodeObject:self.latitude forKey:@"latitude"];
        [aCoder encodeObject:self.cityName forKey:@"cityName"];
        
    }
    @catch (NSException *exception) {
        
    }
    
    @try {
        [aCoder encodeObject:self.city forKey:@"city"];
    }
    @catch (NSException *exception) {
        
    }
    
    @try {
       [aCoder encodeObject:self.province forKey:@"province"];
    }
    @catch (NSException *exception) {
        
    }
    
    @try {
        [aCoder encodeObject:self.district forKey:@"district"];
    }
    @catch (NSException *exception) {
        
    }
    
    @try {
        [aCoder encodeObject:self.outdoorCity forKey:@"outdoorCity"];
    }
    @catch (NSException *exception) {
        
    }
    
    @try {
        [aCoder encodeObject:self.airDic forKey:@"airDic"];
    }
    @catch (NSException *exception) {
        
    }
    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self ) {
        self.user_phoneNumber = [aDecoder decodeObjectForKey:@"user_phoneNumber"];
        self.user_password = [aDecoder decodeObjectForKey:@"user_password"];
        self.user_nickName = [aDecoder decodeObjectForKey:@"user_nickName"];
        self.userImageurl = [aDecoder decodeObjectForKey:@"userImageurl"];
        self.userStatus = [aDecoder decodeBoolForKey:@"userStatus"];
        self.user_ID = [aDecoder decodeIntegerForKey:@"user_ID"];
        self.headerImagePath = [aDecoder decodeObjectForKey:@"headerImagePath"];
        
        @try {
            self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
            self.longtidude = [aDecoder decodeObjectForKey:@"longtidude"];
            self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        @try {
            self.city = [aDecoder decodeObjectForKey:@"city"];
        }
        @catch (NSException *exception) {
            
        }
        
        @try {
            self.province = [aDecoder decodeObjectForKey:@"province"];
        }
        @catch (NSException *exception) {
            
        }
        
        @try {
            self.district = [aDecoder decodeObjectForKey:@"district"];
        }
        @catch (NSException *exception) {
            
        }
        
        @try {
            self.outdoorCity = [aDecoder decodeObjectForKey:@"outdoorCity"];
        }
        @catch (NSException *exception) {
            
        }
       
        @try {
            self.airDic = [aDecoder decodeObjectForKey:@"airDic"];
        }
        @catch (NSException *exception) {
            
        }
      
        
    }
    return self;
}

- (NSString *)description {
    NSString * str = [NSString stringWithFormat:@"%p[%@]", self, [self mj_JSONString]];
    return str;
}

@end
