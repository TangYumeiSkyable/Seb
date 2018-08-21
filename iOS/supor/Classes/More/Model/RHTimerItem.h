//
//  RHTimerItem.h
//  supor
//
//  Created by 赵冰冰 on 16/7/1.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHBaseItem.h"

@interface RHTimerItem : RHBaseItem

@property (nonatomic, strong) NSString * mDescription;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) long long status;
@property (nonatomic, assign) long long taskFlag;
@property (nonatomic, strong) NSString * taskId;
@property (nonatomic, strong) NSString * timeCycle;
@property (nonatomic, strong) NSString * timePoint;

@property (nonatomic, strong) NSString * timeStamp;
@property (nonatomic, assign, readonly) BOOL isTop;//是不是上半段
@property (nonatomic, assign) long long deviceId;

//2016-07-08 00:00:00 开始时间和结束时间 用于check重叠
@property (nonatomic, strong) NSString *  mEndTime;
@property (nonatomic, strong) NSString *  mTimePoint;

@property (nonatomic, strong) NSString * intTimePoint;
@property (nonatomic, strong) NSString * intEndTime;

/**
 *  两个timer中至少有一个不是once
 *
 *  @param startTime 开始时间
 *  @param endTime   结束时间
 *
 *  @return 是否可以添加新的timer
 */
-(BOOL)containTimeSlotWithStartTime:(NSString *)startTime andEndTime:(NSString *)endTime;
/**
 *  两个timer都是once
 *
 *  @param startTime 开始时间
 *  @param endTime   结束时间
 *
 *  @return 是否可以添加新的timer
 */
-(BOOL)onceContainTimeSlotWithStartTime:(NSString *)startTime andEndTime:(NSString *)endTime;

/**
 *  两个timer中一个是once一个不是once
 *
 *  @param startTime 开始时间
 *  @param endTime   结束时间
 *
 *  @return 是否可以添加新的timer
 */


-(BOOL)containTimeSlotWithStartTime:(NSString *)startTime andEndTime:(NSString *)endTime selfStartTime:(NSString *)selfStartTime selfEndTime:(NSString *)selfEndTime;


-(BOOL)newContainTimeSlotWithStartTime:(NSString *)startTime adnEndTime:(NSString *)endTime andRepeat:(NSString *)repeat andTaskId:(NSString *)taskId andIsSelf:(BOOL)isSelf andDeviceId:(NSInteger)deviceId;

//循环的所有时间
-(NSArray *)weeksArray;
//获取今天是周几
-(NSString *)getWeekdays;
//根据时间戳获取星期
+(NSString *)getWeekdayWithTimePoint:(NSString *)timePoint;

-(NSMutableArray *)assembleTimeLinesWithTimePoint:(NSString *)startTime andEndTime:(NSString *)endTime;

-(BOOL)checkWithItem:(RHTimerItem *)aItem;

@end
