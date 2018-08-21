//
//  JSSelectTimerModel.h
//  supor
//
//  Created by 赵冰冰 on 16/7/6.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "JSBaseModel.h"


@protocol JSSelectTimerModel <JSExport>

-(void)setTime:(NSString *)time;

-(void)cancle;

@end

@interface JSSelectTimerModel : JSBaseModel<JSSelectTimerModel>

@end
