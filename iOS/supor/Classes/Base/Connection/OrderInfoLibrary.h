//
//  OrderInfo.h
//  supor
//
//  Created by 赵冰冰 on 16/7/8.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, Order)
{
    OrderWindSpeed_1 = 0,//微风
    OrderWindSpeed_2,//中速
    OrderWindSpeed_3,//高速
    OrderWindSpeed_4,//极速
    OrderAuto, //自动
    OrderManual,
    OrderOn, //开启
    OrderOff, //关闭
    OrderSleep,//睡眠
//    OrderUnSleep,
    OrderLampOff,//灯光关
    OrderLamp_1, //灯光若
    OrderLamp_2, //灯光强
    OrderAnion_off, //负离子关
    OrderAnio_on, //负离子开
    OrderQueryPM25
};


@interface OrderInfoLibrary : NSObject

/**
 *  首页通用的控制接口
 *
 *  @param deviceId    设备ID
 *  @param msgCode     msgCode
 *  @param orderType   指令种类
 *  @param subDomainId 子域
 *  @param callback    
 */
+(void)control:(NSInteger )deviceId msgCode:(NSInteger)msgCode OrderType:(Order)orderType  subDomian:(NSInteger)subDomainId callback:(void (^)(ACDeviceMsg *responseMsg, NSError *error))callback;


@end
