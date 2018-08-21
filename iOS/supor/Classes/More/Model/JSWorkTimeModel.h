//
//  JSWorkTimeModel.h
//  supor
//
//  Created by 赵冰冰 on 16/6/29.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "JSBaseModel.h"

@protocol JSWorkTimeDelegate  <JSExport>

-(void)pageChange:(NSString *)page;
-(void)returnRepeat:(NSString *)week :(NSString *)repeat;
-(void)modifySaved:(NSString *)str;
-(void)noDeviceToast;

@end

@interface JSWorkTimeModel : JSBaseModel<JSWorkTimeDelegate>

@end
