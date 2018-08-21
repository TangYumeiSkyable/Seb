//
//  RHHttpBase.h
//  millHeater
//
//  Created by 赵冰冰 on 16/5/4.
//  Copyright © 2016年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHHttpBase : NSObject

#define http_ (RHHttpBase *)[RHHttpBase sharedInstance]

+(instancetype)sharedInstance;

-(void)requestWithMessageName:(NSString *)messageName callback:(void (^)(ACMsg *responseObject, NSError *error))callback andKeyValues:(id)obj,...NS_REQUIRES_NIL_TERMINATION;
-(void)requestWithMessageName:(NSString *)messageName params:(NSDictionary *)params callback:(void (^)(ACMsg *responseObject, NSError *error))callback;

-(NSTimeZone *)timezone;

@end
