//
//  RHSysUtil.h
//  millHeater
//
//  Created by 赵冰冰 on 16/4/20.
//  Copyright © 2016年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^IndexChanged)(NSInteger index);
@interface RHSysUtil : NSObject
#define sys (RHSysUtil *)[RHSysUtil shareInstance]

+(instancetype)shareInstance;
@property (nonatomic, copy) IndexChanged block;//actionsheet的block
@property (nonatomic, copy) IndexChanged alertBlock;//alertView的block
-(void)showActionSheetInViewControlelr:(UIViewController *)vc titles:(NSArray *)titles cancelTitle:(NSString *)canceltitle destructiveIndex:(NSInteger)index;
-(void)showAlertInViewControlelr:(UIViewController *)vc title:(NSString *)title message:(NSString *)msg titles:(NSArray *)titles cancelTitle:(NSString *)canceltitle;
-(id)loadFromStoryboard:(NSString *)storyName andId:(NSString *)storyId;
-(NSString *)tranfromHourToTimeStringWithHour:(CGFloat)hour;

@end
