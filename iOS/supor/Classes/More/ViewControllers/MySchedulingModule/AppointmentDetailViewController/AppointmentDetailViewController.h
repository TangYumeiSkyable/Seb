//
//  AppointmentDetailViewController.h
//  supor
//
//  Created by 赵冰冰 on 16/7/1.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHBaseWebVC.h"

@protocol AppointmentDetailViewControllerDelegate <NSObject>

- (void)week:(NSString *)week repeat:(NSString *)repeat;

@end

@interface AppointmentDetailViewController : RHBaseWebVC

@property (nonatomic, strong) NSString *week;
@property (nonatomic, strong) NSString *repeat;

@property (nonatomic, weak) id <AppointmentDetailViewControllerDelegate> delegate;

@end
