//
//  RHAccountTool.h
//  millHeater
//
//  Created by user on 16/5/3.
//  Copyright © 2016年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RHAccount.h"

@interface RHAccountTool : NSObject

+ (void)saveAccount:(RHAccount *)account;

+ (RHAccount *)account;

+ (RHAccount *)cleanAccount;

@end
