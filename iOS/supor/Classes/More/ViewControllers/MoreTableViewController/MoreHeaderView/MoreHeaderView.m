//
//  MoreHeaderView.m
//  supor
//
//  Created by 刘杰 on 2018/5/3.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "MoreHeaderView.h"

@interface MoreHeaderView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *separateView;

@end

@implementation MoreHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:self.backButton];
    [self.backgroundImageView addSubview:self.titleLabel];
    [self.backgroundImageView addSubview:self.avatarButton];
    [self.backgroundImageView addSubview:self.accountLabel];
    [self addSubview:self.schedulingButton];
    [self addSubview:self.separateView];
    [self addSubview:self.messageButton];
}

#pragma mark - Lazyload Methods
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_avatar_bg"]];
        _backgroundImageView.userInteractionEnabled = YES;
    }
    return _backgroundImageView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = GetLocalResStr(@"airpurifier_login_cookies_more");
        _titleLabel.textColor = LJHexColor(@"#f2f2f2");
        _titleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)avatarButton {
    if (!_avatarButton) {
        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_avatarButton setBackgroundImage:[UIImage imageNamed:@"img_big_avator"] forState:UIControlStateNormal];
    }
    return _avatarButton;
}

- (UILabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.textColor = LJHexColor(@"#f2f2f2");
        _accountLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        _accountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _accountLabel;
}

- (RHMoreButton *)schedulingButton {
    if (!_schedulingButton) {
        _schedulingButton = [[RHMoreButton alloc] init];
        _schedulingButton.titleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        _schedulingButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_schedulingButton setTitle:GetLocalResStr(@"airpurifier_more_show_myorder_text") forState:UIControlStateNormal];
        [_schedulingButton setTitleColor:LJHexColor(@"#36424a") forState:UIControlStateNormal];
        [_schedulingButton setTitleColor:[UIColor classics_blue] forState:UIControlStateHighlighted];
        [_schedulingButton setImage:[UIImage imageNamed:@"ico_clock_nor"] forState:UIControlStateNormal];
        [_schedulingButton setImage:[UIImage imageNamed:@"ico_clock_sel"] forState:UIControlStateHighlighted];
        [_schedulingButton setImage:[UIImage imageNamed:@"ico_clock_sel"] forState:UIControlStateSelected];
    }
    return _schedulingButton;
}

- (UIView *)separateView {
    if (!_separateView) {
        _separateView = [[UIView alloc] init];
        _separateView.backgroundColor = LJHexColor(@"#EEEEEE");
    }
    return _separateView;
}

- (RHMoreButton *)messageButton {
    if (!_messageButton) {
        _messageButton = [[RHMoreButton alloc] init];
        _messageButton.titleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        [_messageButton setTitle:GetLocalResStr(@"airpurifier_more_show_mynews_text") forState:UIControlStateNormal];
        [_messageButton setTitleColor:LJHexColor(@"#36424a") forState:UIControlStateNormal];
        [_messageButton setTitleColor:[UIColor classics_blue] forState:UIControlStateHighlighted];
        [_messageButton setImage:[UIImage imageNamed:@"ico_message_nor"] forState:UIControlStateNormal];
        [_messageButton setImage:[UIImage imageNamed:@"ico_message_sel"] forState:UIControlStateHighlighted];
        [_messageButton setImage:[UIImage imageNamed:@"ico_message_sel"] forState:UIControlStateSelected];
    }
    return _messageButton;
}

#pragma mark - System Methods
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-47);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.mas_equalTo(10);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(DeviceUtils.statusBarHeight + 10);
        make.centerX.mas_equalTo(0);
        make.left.equalTo(self.backButton.mas_right).offset(20);
    }];
    
    [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(8);
        make.height.width.mas_equalTo(65 * kRatio);
    }];
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarButton.mas_bottom).offset(5);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.schedulingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.equalTo(self.separateView.mas_left);
        make.top.equalTo(self.backgroundImageView.mas_bottom);
        make.width.equalTo(self.messageButton.mas_width);
        make.height.mas_equalTo(47);
    }];
    
    [self.separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(2);
        make.top.equalTo(self.backgroundImageView.mas_bottom).offset(5);
        make.bottom.mas_equalTo(-5);
        make.right.equalTo(self.messageButton.mas_left);
    }];
    
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.equalTo(self.schedulingButton.mas_top);
        make.height.equalTo(self.schedulingButton.mas_height);
    }];
}

@end
