//
//  RHHomeItem.m
//  supor
//
//  Created by 赵冰冰 on 16/6/20.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHHomeItem.h"

@implementation RHHomeItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"mDescription" : @"description"};
}

- (NSInteger)sleep {
    if (self.model == 1) {
        return 1;
    } else {
        return 0;
    }
}

- (void)setOn_off:(NSInteger)on_off {
    if (_on_off != on_off) {
        self.last_on_off = _on_off;
        _on_off = on_off;
    }
}

- (NSInteger)lastSpeed {
    if (_lastSpeed == 0) {
        return 1;
    }
    return _lastSpeed;
}

- (void)setSpeed:(NSInteger)speed {
    if (_speed != speed) {
        
        //如果风速等于0 那么还需要记录上次的风速
        if (_speed != 0) {
            self.lastSpeed = _speed;
        }
        _speed = speed;
    }
}

- (NSString *)subDomainName {
    if (_subDomainName == nil) {
        _subDomainName = @"";
    }
    return _subDomainName;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    RHHomeItem *item = [[RHHomeItem alloc] init];
    item.sleep = self.sleep;
    item.anion = self.anion;
    item.city = [self.city mutableCopy];
    item.mDescription = [self.mDescription mutableCopy];
    
    item.deviceId = self.deviceId;
    item.deviceModel = self.deviceModel;
    item.deviceType = self.deviceType;
    
    item.enable = self.enable;
    item.error = self.error;
    item.filter_HEPA = self.filter_HEPA;
    item.filter_change1 = self.filter_change1;
    item.filter_change2 = self.filter_change2;
    item.filter_change3 = self.filter_change3;
    item.filter_change4 = self.filter_change4;
    item.filter_initial = self.filter_initial;
    item.filter_nano = self.filter_nano;
    item.filter_activecarbon = self.filter_activecarbon;
    item.flag = self.flag;
    
    item.forbidden = self.forbidden;
    item.hcho = self.hcho;
    item.light = self.light;
    item.model = self.model;
    item.notify_pm25 = self.notify_pm25;
    
    item.on_off = self.on_off;
    item.pm25 = self.pm25;
    item.speed = self.speed;
    item.timePoint = self.timePoint;
    
    item.work_mode = [self.work_mode mutableCopy];
    item.isCurrent = self.isCurrent;
    item.userId = self.userId;
    item.ownerId = self.ownerId;
    item.index = self.index;
    item.deviceName = [self.deviceName mutableCopy];
    item.openAppoint = self.openAppoint;
    item.subDomainId = self.subDomainId;
    item.cellSize = self.cellSize;
    item.lastSpeed = self.lastSpeed;
    item.last_on_off = self.last_on_off;
    item.error = self.error;
    item.status = self.status;
    item.pm25_level = self.pm25_level;
    item.subDomainName = self.subDomainName;
    
    return item;
}

@end
