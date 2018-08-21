//
//  ShareDeviceView.m
//  supor
//
//  Created by 刘杰 on 2018/4/23.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "ShareDeviceView.h"

@interface ShareDeviceView ()

@property (nonatomic, strong) UIView *topBackgroundView;

@property (nonatomic, strong) UILabel *refreshTipLabel;

@property (nonatomic, strong) UILabel *shareTitleLabel;

@property (nonatomic, strong) UILabel *bottomTipLabel;

@end


@implementation ShareDeviceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = LJHexColor(@"#EEEEEE");
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.topBackgroundView];
    [self.topBackgroundView addSubview:self.titleLabel];
    [self.topBackgroundView addSubview:self.qrcodeImageView];
    [self.topBackgroundView addSubview:self.refreshTipLabel];
    [self addSubview:self.shareBackgroundView];
    [self.shareBackgroundView addSubview:self.shareTitleLabel];
    [self addSubview:self.bottomTipLabel];
    
}

#pragma mark - Lazyload Methods
- (UIView *)topBackgroundView {
    if (!_topBackgroundView) {
        _topBackgroundView = [[UIView alloc] init];
        _topBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _topBackgroundView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = LJHexColor(@"#555555");
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIImageView *)qrcodeImageView {
    if (!_qrcodeImageView) {
        _qrcodeImageView = [[UIImageView alloc] init];
    }
    return _qrcodeImageView;
}

- (UILabel *)refreshTipLabel {
    if (!_refreshTipLabel) {
        _refreshTipLabel = [[UILabel alloc] init];
        _refreshTipLabel.text = GetLocalResStr(@"airpurifier_more_show_fiveminutesrefreshago_text");
        _refreshTipLabel.textColor = LJHexColor(@"#6F7179");
        _refreshTipLabel.font = [UIFont systemFontOfSize:13];
        _refreshTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _refreshTipLabel;
}

- (UIView *)shareBackgroundView {
    if (!_shareBackgroundView) {
        _shareBackgroundView = [[UIView alloc] init];
        _shareBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _shareBackgroundView;
}

- (UILabel *)shareTitleLabel {
    if (!_shareTitleLabel) {
        _shareTitleLabel = [[UILabel alloc] init];
        _shareTitleLabel.text = GetLocalResStr(@"airpurifier_more_show_sharethroughphone_text");
        _shareTitleLabel.textColor = LJHexColor(@"#555555");;
        _shareTitleLabel.font = [UIFont systemFontOfSize:17];
        _shareTitleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _shareTitleLabel;
}

- (UILabel *)bottomTipLabel {
    if (!_bottomTipLabel) {
        _bottomTipLabel = [[UILabel alloc] init];
        _bottomTipLabel.backgroundColor = self.backgroundColor;
        _bottomTipLabel.text = GetLocalResStr(@"airpurifier_more_show_emailtip_text");
        _bottomTipLabel.textColor = LJHexColor(@"#848484");
        _bottomTipLabel.numberOfLines = 0;
    }
    return _bottomTipLabel;
}

#pragma mark - System Methods
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.topBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [self.qrcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.equalTo(self.qrcodeImageView.mas_width);
    }];
    
    [self.refreshTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrcodeImageView.mas_bottom).offset(20);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.titleLabel.mas_right);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self.shareBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBackgroundView.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    
    [self.shareTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.bottomTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareBackgroundView.mas_bottom).offset(30);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
}

@end
