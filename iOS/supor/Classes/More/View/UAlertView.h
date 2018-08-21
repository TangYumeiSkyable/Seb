//
//  UAlertView.h
//  supor
//
//  Created by 赵冰冰 on 2017/5/9.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UAlertView;
@protocol UAlertViewDelegate <NSObject>
- (void)alertView:(UAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface UAlertView:UIView
@property (nonatomic, weak) id <UAlertViewDelegate> delegate;
@property (nonatomic, assign) NSInteger alertTag;
- (instancetype)initWithTitle:(NSString *)title msg:(NSString *)msg cancelTitle:(NSString *)cancelTitle okTitle:(NSString *)okTitle;
- (void)show;
- (void)showInView:(UIView *)view;
- (void)setOKButtonFont:(UIFont *)okFont andCancelButtonFont:(UIFont *)cancelFont;
- (void)setOKButtonColor:(UIColor *)okColor andCancelButtonColor:(UIColor *)cancelColor;
@end
