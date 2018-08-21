//
//  RHScanView.h
//  supor
//
//  Created by 赵冰冰 on 16/6/22.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RHSanViewDelegate <NSObject>

-(void)scanScuess:(NSString *)qrcode;

-(void)scanFailure:(NSString *)failed;

@end

@interface RHScanView : UIView

@property (nonatomic, assign) id <RHSanViewDelegate> delegate;

//开始扫描
-(void)startScan;
//结束扫描
-(void)stopScan;

@end
