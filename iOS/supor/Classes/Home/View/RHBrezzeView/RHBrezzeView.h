//
//  RHBrezzeView.h
//  supor
//
//  Created by 赵冰冰 on 16/6/27.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrezzeSpeenButton.h"
@protocol RHBrezzeViewDelegate <NSObject>

@optional
-(void)brezzeClicked:(BrezzeSpeenButton *)btn;
-(void)brezzeViewCanceled;

@end
@interface RHBrezzeView : UIView

-(id)initWithFrame:(CGRect)frame;
-(void)showAtPoint:(CGPoint)point;
-(void)dismiss;
-(void)close;

@property (nonatomic, assign, readonly) BOOL showing;
@property (nonatomic, assign) id <RHBrezzeViewDelegate> delegate;

@property (nonatomic, strong) BrezzeSpeenButton * brezzeBtn;

@end
