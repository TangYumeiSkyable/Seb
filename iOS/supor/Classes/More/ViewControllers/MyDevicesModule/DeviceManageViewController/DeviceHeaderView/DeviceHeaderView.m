//
//  DeviceHeaderView.m
//  supor
//
//  Created by 刘杰 on 2018/4/18.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "DeviceHeaderView.h"

@interface DeviceHeaderView ()

@property (nonatomic, strong) UILabel *macTitleLabel;

@property (nonatomic, strong) UILabel *versionTitleLabel;

@end

@implementation DeviceHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = LJHexColor(@"#EEEEEE");
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.macTitleLabel];
    [self addSubview:self.macTextLabel];
    [self addSubview:self.versionTitleLabel];
    [self addSubview:self.versionTextLabel];
    [self addSubview:self.sectionTitleLabel];
}

#pragma mark - Lazyload Methods
- (UILabel *)macTitleLabel {
    if (!_macTitleLabel) {
        _macTitleLabel = [[UILabel alloc] init];
        _macTitleLabel.font = [UIFont fontWithName:Regular size:17];
        _macTitleLabel.text = GetLocalResStr(@"airpurifier_moredevice_show_devicemac_text");
        _macTitleLabel.textColor = LJHexColor(@"#848484");
    }
    return _macTitleLabel;
}

- (UILabel *)macTextLabel {
    if (!_macTextLabel) {
        _macTextLabel = [[UILabel alloc] init];
        _macTextLabel.font = [UIFont fontWithName:Regular size:16];
        _macTextLabel.textColor = LJHexColor(@"#36424a");
    }
    return _macTextLabel;
}

- (UILabel *)versionTitleLabel {
    if (!_versionTitleLabel) {
        _versionTitleLabel = [[UILabel alloc] init];
        _versionTitleLabel.font = [UIFont fontWithName:Regular size:17];
        _versionTitleLabel.text = GetLocalResStr(@"firmware_version");
        _versionTitleLabel.textColor = LJHexColor(@"#848484");
    }
    return _versionTitleLabel;
}

- (UILabel *)versionTextLabel {
    if (!_versionTextLabel) {
        _versionTextLabel = [[UILabel alloc] init];
        _versionTextLabel.font = [UIFont fontWithName:Regular size:16];
        _versionTextLabel.textColor = LJHexColor(@"#36424a");
    }
    return _versionTextLabel;
}

- (UILabel *)sectionTitleLabel {
    if (!_sectionTitleLabel) {
        _sectionTitleLabel = [[UILabel alloc] init];
        _sectionTitleLabel.text = GetLocalResStr(@"airpurifier_moredevice_show_membermenage_text");
        _sectionTitleLabel.font = [UIFont fontWithName:Regular size:14];
        _sectionTitleLabel.textColor = LJHexColor(@"#c8c8c8");
    }
    return _sectionTitleLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.macTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
    }];
    
    [self.macTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.macTitleLabel.mas_centerY);
    }];
    
    [self.versionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.macTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.macTitleLabel.mas_left);
    }];
    
    [self.versionTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.macTextLabel.mas_right);
        make.centerY.equalTo(self.versionTitleLabel.mas_centerY);
    }];
    
    [self.sectionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.versionTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.versionTitleLabel.mas_left);
    }];
    
    
    
    
}

@end
