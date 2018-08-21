
//
//  UAlertView.m
//  supor
//
//  Created by 赵冰冰 on 2017/5/9.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "UAlertView.h"
#import "UIImage+FlatUI.h"
#import "MBProgressHUD.h"

@implementation UAlertView
{
    UILabel * _titleLabel;
    UILabel * _msgLabel;
    UIButton * _cancel;
    UIButton * _ok;
    __weak MBProgressHUD * _hud;
}

- (void)setOKButtonFont:(UIFont *)okFont andCancelButtonFont:(UIFont *)cancelFont
{
    _ok.titleLabel.font = okFont;
    _cancel.titleLabel.font = cancelFont;
}

- (void)setOKButtonColor:(UIColor *)okColor andCancelButtonColor:(UIColor *)cancelColor {
    
    UIImage * cancelImage = [UIImage imageWithColor:cancelColor cornerRadius:20];
    [_cancel setBackgroundImage:cancelImage forState:UIControlStateNormal];
    
    UIImage * okImage = [UIImage imageWithColor:okColor cornerRadius:20];
    [_ok setBackgroundImage:okImage forState:UIControlStateNormal];
    
}

- (void)ok
{
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:1];
    }

    self.alpha = 1;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.01;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        [_hud hide:YES];
    }];
}

- (void)cancel
{
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:0];
    }
 
    self.alpha = 1;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.01;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        [_hud hide:YES];
     
    }];
}

- (void)show
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:NO];
    hud.mode = MBProgressHUDModeCustomView;
    hud.margin = 0;
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [UIColor clearColor];
    _hud = hud;
    NSString * title = _titleLabel.text;
    NSString * msg = _msgLabel.text;
    
    CGFloat h = [title boundingRectWithSize:CGSizeMake(kMainScreenWidth - 80, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _titleLabel.font} context:nil].size.height;
    if (h < 30) {
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    CGFloat h2 = [msg boundingRectWithSize:CGSizeMake(kMainScreenWidth - 80, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _msgLabel.font} context:nil].size.height;
    if (h2 < 25) {
        _msgLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        _msgLabel.textAlignment = NSTextAlignmentLeft;
    }
    h += h2;
    h += 20 + 45 + 20 + 20 + 20 + 8;
    self.frame = CGRectMake(0, 0, kMainScreenWidth - 40, h);
    [self layoutIfNeeded];
    self.backgroundColor = [UIColor whiteColor];
    hud.customView = self;
    self.alpha = 0;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

- (void)showInView:(UIView *)view {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
    hud.mode = MBProgressHUDModeCustomView;
    hud.margin = 0;
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [UIColor clearColor];
    _hud = hud;
    NSString * title = _titleLabel.text;
    NSString * msg = _msgLabel.text;
    
    CGFloat h = [title boundingRectWithSize:CGSizeMake(kMainScreenWidth - 80, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _titleLabel.font} context:nil].size.height;
    if (h < 30) {
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    CGFloat h2 = [msg boundingRectWithSize:CGSizeMake(kMainScreenWidth - 80, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _msgLabel.font} context:nil].size.height;
    if (h2 < 25) {
        _msgLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        _msgLabel.textAlignment = NSTextAlignmentLeft;
    }
    h += h2;
    h += 20 + 45 + 20 + 20 + 20 + 8;
    self.frame = CGRectMake(0, 0, kMainScreenWidth - 40, h);
    [self layoutIfNeeded];
    self.backgroundColor = [UIColor whiteColor];
    hud.customView = self;
    self.alpha = 0;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];

    
}

- (instancetype)initWithTitle:(NSString *)title msg:(NSString *)msg cancelTitle:(NSString *)cancelTitle okTitle:(NSString *)okTitle;
{
    if (self = [super init]) {
        RHBorderRadius(self, 16, 1, [UIColor classics_gray]);
        UILabel * titleLabel = [UILabel new];
        titleLabel.text = title;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont fontWithName:Regular size:21];
        [titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UILabel * msgLabel = [UILabel new];
        msgLabel.text = msg;
        msgLabel.lineBreakMode = NSLineBreakByWordWrapping;
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.numberOfLines = 0;
        msgLabel.font = [UIFont fontWithName:Regular size:18];
        [msgLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [msgLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self addSubview:msgLabel];
        _msgLabel = msgLabel;
        
        UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [cancel setTitle:cancelTitle forState:UIControlStateNormal];
        UIImage * cancelImage = [UIImage imageWithColor:[UIColor classics_blue] cornerRadius:20];
        [cancel setBackgroundImage:cancelImage forState:UIControlStateNormal];
        [self addSubview:cancel];
        _cancel = cancel;
        
        UIButton * ok = [UIButton buttonWithType:UIButtonTypeCustom];
  
        [ok setTitle:okTitle forState:UIControlStateNormal];
        UIImage * okImage = [UIImage imageWithColor:[UIColor classics_black] cornerRadius:20];
        [ok setBackgroundImage:okImage forState:UIControlStateNormal];
        [self addSubview:ok];
        _ok = ok;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(20);
        }];
        
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(titleLabel);
            make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(15);
        }];
        
        if (okTitle) {
            
            [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(titleLabel);
                make.bottom.mas_equalTo(self).with.offset(-20);
                make.height.mas_equalTo(40);
                make.top.mas_equalTo(msgLabel.mas_bottom).with.offset(20);
            }];
            
            [ok mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(titleLabel);
                make.bottom.mas_equalTo(-20);
                make.top.mas_equalTo(cancel);
                make.left.mas_equalTo(cancel.mas_right).with.offset(RATIO(36));
                make.width.mas_equalTo(cancel);
                make.height.mas_equalTo(44);
            }];
            
        }else{
            
            [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(titleLabel);
                make.bottom.mas_equalTo(self).with.offset(-20);
                make.height.mas_equalTo(44);
                make.top.mas_equalTo(msgLabel.mas_bottom).with.offset(20);
                make.right.mas_equalTo(titleLabel);
            }];
        }
        
        BTN_ADDTARGET(ok, @selector(ok));
        BTN_ADDTARGET(cancel, @selector(cancel));
    }
    return self;
}

@end
