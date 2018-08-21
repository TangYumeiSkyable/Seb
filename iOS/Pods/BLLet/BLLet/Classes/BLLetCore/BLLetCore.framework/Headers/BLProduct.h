//
//  BLProduct.h
//  BLLetCore
//
//  Created by zhujunjie on 2017/12/20.
//  Copyright © 2017年 朱俊杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLConfigParam.h"

@interface BLProduct : NSObject

/**
 Get family controller with global config
 
 @param configParam         Global config params
 @return                    Family controller Object
 */
+ (nullable instancetype)sharedWithConfigParam:(nullable BLConfigParam *)configParam;

/**
 Product Http Post Request
 
 @param urlPath url path without domain
 @param head request head
 @param body request body
 @param completionHandler return
 */
- (void)productHttpPost:(nonnull NSString *)urlPath head:(nullable NSDictionary *)head body:(nullable NSDictionary *)body completionHandler:(nonnull void (^)(NSData *__nonnull data, NSError *__nullable error))completionHandler;

@end
