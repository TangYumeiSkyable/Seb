//
//  RHHttpBase.m
//  millHeater
//
//  Created by 赵冰冰 on 16/5/4.
//  Copyright © 2016年 colin. All rights reserved.
//

#import "RHHttpBase.h"
#import "AppDelegate.h"
#import "ACAccountManager.h"
#import "ACloudLib.h"
#import "DCPServiceUtils.h"

@implementation RHHttpBase

-(NSTimeZone *)timezone
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    return zone;
}

+(instancetype)sharedInstance
{
    static RHHttpBase * instance = nil;
    if (instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[RHHttpBase alloc]init];
        });
    }
    return instance;
}

-(void)requestWithMessageName:(NSString *)messageName params:(NSDictionary *)params callback:(void (^)(ACMsg *responseObject, NSError *error))callback
{
    RHLog(@"请求地址:%@,请求字典是:%@",messageName,params);
    ACMsg * msg = [[ACMsg alloc]init];
    msg.context = [ACContext generateContextWithSubDomain:RHSUBDOMAIN];
    [msg setName:messageName];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString * key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [msg put:key value:obj];
    }];
    [msg put:DCPServiceParamTokenName value:[DCPServiceUtils getDcpToken]];
    
    ACServiceClient * service = [[ACServiceClient alloc] initWithHost:[ACloudLib getHost] service:RHService version:1];
    [service sendToService:msg callback:^(ACMsg *res, NSError *err) {
        if(err == nil){
            NSDictionary *data = [res getObjectData];
            RHLog(@"请求成功结果是:%@", data);
        }else{
            RHLog(@"请求失败：error = %@", err);
        }
        callback(res, err);
    }];
    
}

-(void)requestWithMessageName:(NSString *)messageName callback:(void (^)(ACMsg *responseObject, NSError *error))callback andKeyValues:(id)obj,...NS_REQUIRES_NIL_TERMINATION
{
    //组装请求字典
    NSDictionary * params = nil;
    if(obj){
        NSMutableArray * keys = [[NSMutableArray alloc]init];
        [keys addObject:obj];
        NSMutableArray * values = [[NSMutableArray alloc]init];
        
        va_list p;
        va_start(p, obj);
        
        int i = 0;
        while((obj = va_arg(p, NSObject *))){
            if(i % 2 == 1){
                [keys addObject:obj];
            }else{
                [values addObject:obj];
            }
            i++;
        }
        va_end(p);
        if(i % 2 == 0){
            RHLog(@"keys = %@", keys);
            RHLog(@"values = %@", values);
            NSException * exp = [NSException exceptionWithName: [NSString stringWithFormat:@"--------%@  request err", messageName] reason:[NSString stringWithFormat:@"第 %d个参数参入错误", (i + 1)] userInfo:nil];
            @throw exp;
            return;
        }else{
            params = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];
        }
    }
    ACMsg * msg = [[ACMsg alloc]init];
    msg.context = [ACContext generateContextWithSubDomain:RHSUBDOMAIN];
    [msg setName:messageName];
    
    [params enumerateKeysAndObjectsUsingBlock:^(NSString * key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [msg put:key value:obj];
    }];
    [msg put:DCPServiceParamTokenName value:[DCPServiceUtils getDcpToken]];
    ACServiceClient * service = [[ACServiceClient alloc]initWithHost:[ACloudLib getHost] service:RHService version:1];
    [service sendToService:msg callback:^(ACMsg *res, NSError *err) {
        if(err == nil){

            ACObject * obj = [res getACObject:@"actionData"];
            NSDictionary * data = [obj getObjectData];
            RHLog(@"请求成功结果是:%@", data);
        }else{
            RHLog(@"请求失败：error = %@", err);
        }
        callback(res, err);
    }];
}


@end
