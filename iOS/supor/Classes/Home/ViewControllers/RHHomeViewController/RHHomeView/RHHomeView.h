//
//  RHHomeView.h
//  supor
//
//  Created by 赵冰冰 on 16/6/17.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHBrezzeTable.h"
#import "BrezzeSpeenButton.h"
@class RHHomeItem;
@class RHHomeView;
@protocol RHHomeViewDelegate <NSObject>
@optional

- (void)switchClick;
- (void)anionClick;
- (void)lightClick;
- (void)gotoFilterVC;
- (void)modeChanged:(NSInteger)idx;
- (void)gotoMore;
- (void)gotoAppointmentVC;
- (void)gotoAirQualityVC;
- (void)gotoCountry;

@end

@interface RHHomeView : UIView
@property (nonatomic, weak) id <RHHomeViewDelegate> delegate;
-(void)refreshWithoutGif:(RHHomeItem *)homeItem;
-(void)refreshWithHomeItem:(RHHomeItem *)homeItem;
-(void)playGifWithHomeItem:(RHHomeItem *)homeItem;
-(void)refreshButtons:(RHHomeItem *)homeItem;
-(void)refreshButtonsAndGifImage:(RHHomeItem *)homeItem;
-(void)homeViewHidden;
- (void)refreshPM:(RHHomeItem *)homeItem;
@end
