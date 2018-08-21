//
//  RHAirQualityItem.h
//  supor
//
//  Created by 赵冰冰 on 16/6/20.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHAirQualityItem : NSObject<NSMutableCopying>

//pm2.5
@property (nonatomic, assign) long pm25;
@property (nonatomic, assign) long airQuality;
@property (nonatomic, assign) long tvoc;

@property (nonatomic, strong, readonly) NSString * airQualityLevel;

//对健康的影响
@property (nonatomic, strong, readonly) NSString * healthyAffectString;
//跑步建议
@property (nonatomic, strong, readonly) NSString * runingSuggestString;
//空气质量
@property (nonatomic, strong, readonly) NSString * airQualityString;

@property (nonatomic, assign) NSInteger  grade; // 取最大值

@property (nonatomic, assign) NSInteger grade1; // pm25
@property (nonatomic, assign) NSInteger grade2; // tvoc

-(void)refreshWithPM25;
-(void)refreshWithTVOC;
-(void)refreshMaxGrade;

@end
