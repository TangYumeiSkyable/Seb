//
//  RHSubHomeItem.h
//  supor
//
//  Created by 赵冰冰 on 16/6/20.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHBaseItem.h"
#import "RHSubHomeItem.h"

@interface RHSubHomeItem : RHBaseItem<NSMutableCopying>

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *unselected;
@property (nonatomic, assign) long workStatus;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *selected;
@property (nonatomic, strong) NSString *weekDay;
@property (nonatomic, strong) NSString *space;

@end
