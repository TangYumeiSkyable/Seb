//
//  HomeAlert.h
//  supor
//
//  Created by 赵冰冰 on 16/9/18.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeAlert : UIView

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * msg;
@property (nonatomic, assign) BOOL isOpen;

+(void)showWithTitle:(NSString *)title andMsg:(NSString *)msg andButtonTitles:(NSArray *)buttonTitles carriers:(UIView *)carriers block:(void (^)(NSInteger idx))aBlock;
+(void)dismiss;
//+(instancetype)sharedInstance;

@property (nonatomic, copy) void (^block)(NSInteger idx);

@end
