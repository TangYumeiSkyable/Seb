//
//  AlertView.h
//  supor
//
//  Created by 赵冰冰 on 16/6/28.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AirAlertBlock) (NSInteger idx);
@interface AirAlertView : UIView

+(id)initWithTitle:(NSString *)title pm:(NSString *)pm oxide:(NSString *)oxide detail:(NSString *)detail;

+(id)initWithTitle:(NSString *)title settingTime:(NSString *)settingTime okText:(NSString *)oktext cancelText:(NSString *)cancelText;

+(id)initCloseWithTitle:(NSString *)title settingTime:(NSString *)settingTime okText:(NSString *)oktext cancelText:(NSString *)cancelText;

-(void)show;
-(void)dismiss;

@property (nonatomic, copy) AirAlertBlock indexChanged;

@end
