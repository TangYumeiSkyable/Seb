//
//  JSCityModel.m
//  supor
//
//  Created by 赵冰冰 on 16/6/23.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "JSCityModel.h"

@implementation JSCityModel

- (void)locCityChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_OCCHANGE_CITY  object:nil];
}

- (void)cityChange:(NSString *)para {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHANGE_CITY object:para];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
