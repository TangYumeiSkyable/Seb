//
//  MoreItem.h
//  supor
//
//  Created by huayiyang on 16/6/24.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHBaseItem.h"

@interface MoreItem : RHBaseItem

/**
 定时任务数
 */
@property (nonatomic,assign) long sumAppointment;

/**
 消息总数
 */
@property (nonatomic,assign) long sumMessage;

/**
 是否已读
 */
@property (nonatomic,assign) long readFlag0;

/**
 滤网状态
 */
@property (nonatomic,assign) long filterStatus;

@end
