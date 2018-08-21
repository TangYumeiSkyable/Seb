//
//  RHHomeItem.h
//  supor
//
//  Created by 赵冰冰 on 16/6/20.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHBaseItem.h"
#import "RHSubHomeItem.h"

@interface RHHomeItem : RHBaseItem<NSMutableCopying>
{
    @public
    NSInteger _speed;
}
@property (nonatomic, assign) NSInteger sleep;
@property (nonatomic, assign) long anion;//负离子
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *mDescription;//定时任务
@property (nonatomic, assign) NSInteger deviceId;//设备id
@property (nonatomic, assign) NSInteger deviceModel;
@property (nonatomic, assign) NSInteger deviceType;
@property (nonatomic, assign) NSInteger enable;
@property (nonatomic, assign) NSInteger error;
@property (nonatomic, assign) NSInteger filter_HEPA;
@property (nonatomic, assign) NSInteger filter_change1;// 复合滤网需更换滤网标志
@property (nonatomic, assign) NSInteger filter_change2;// NaneCapture更换滤网标志
@property (nonatomic, assign) NSInteger filter_change3;//
@property (nonatomic, assign) NSInteger filter_change4;//
@property (nonatomic, assign) NSInteger filter_initial;
@property (nonatomic, assign) NSInteger filter_activecarbon;
@property (nonatomic, assign) NSInteger filter_nano;
@property (nonatomic, assign) NSInteger flag; //如果flag > 0 有红点
@property (nonatomic, assign) NSInteger forbidden;
@property (nonatomic, assign) NSInteger hcho; //TVOC值
@property (nonatomic, assign) NSInteger light; //灯光
@property (nonatomic, assign) NSInteger model; //0：自动 1：睡眠 2：手动
@property (nonatomic, assign) NSInteger notify_pm25; //甲醛
@property (nonatomic, assign) NSInteger on_off; //开关按钮
@property (nonatomic, assign) NSInteger pm25; //pm25
@property (nonatomic, assign) NSInteger speed; //风速
@property (nonatomic, assign) NSInteger timePoint;
@property (nonatomic, assign) NSInteger pm25_level;

@property (nonatomic, strong) RHSubHomeItem * work_mode;//工作模式
@property (nonatomic, assign) BOOL isCurrent; //是否是当前展示的页面
@property (nonatomic, assign) long long userId; //用户id
@property (nonatomic, assign) long long ownerId; //设备拥有者
@property (nonatomic, assign) NSInteger index; //数组中的index
@property (nonatomic, strong) NSString *deviceName; //设备名称
@property (nonatomic, assign) long status;
//是否开启预约
@property (nonatomic, assign) BOOL openAppoint;
@property (nonatomic, assign) long long subDomainId;
//记录上一次的风速
@property (nonatomic, assign) NSInteger lastSpeed;
@property (nonatomic, assign) NSInteger last_on_off;
@property (nonatomic, assign) CGSize cellSize;

@property (nonatomic, strong) NSString *subDomainName;

@end
