//
//  RHSubHomeItem.m
//  supor
//
//  Created by 赵冰冰 on 16/6/20.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHSubHomeItem.h"

@implementation RHSubHomeItem

- (NSString *)startTime {
    if (_startTime == nil) {
        return @"08:00";
    }
    return _startTime;
}

- (NSString *)unselected {
    if (_unselected == nil) {
        return @"device[]";
    }
    return _unselected;
}

- (NSString *)endTime {
    if (_endTime == nil) {
        return @"17:00";
    }
    return _endTime;
}

- (NSString *)selected {
    if (_selected == nil) {
        return @"device[]";
    }
    return _selected;
}

- (NSString *)weekDay{
    if (_weekDay == nil) {
        return @"week[1,2,3,4,5]";
    }
    return _weekDay;
}

- (NSString *)space {
    if (_space == nil) {
        return @"0-10㎡";
    }
    return _space;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    RHSubHomeItem * item = [[RHSubHomeItem alloc]init];
    item.workStatus = self.workStatus;
    item.weekDay = [self.weekDay mutableCopy];
    item.startTime = [self.startTime mutableCopy];
    item.endTime = [self.endTime mutableCopy];
    item.selected = [self.selected mutableCopy];
    item.unselected = [self.unselected mutableCopy];
    item.space = [self.space mutableCopy];
    return item;
}

@end
