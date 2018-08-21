//
//  SelectCountryHeaderView.m
//  supor
//
//  Created by 刘杰 on 2018/3/23.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "SelectCountryHeaderView.h"

@interface SelectCountryHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SelectCountryHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LJHexColor(@"#EEEEEE");
        [self initViews];
    }
    return self;
}

#pragma mark - Common Methods
- (void)initViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.selectedCityLabel];
    [self addSubview:self.locateButton];
}

#pragma mark - Lazyload Methods
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = GetLocalResStr(@"airpurifier_adjust_show_currentcity_text");
        _titleLabel.textColor = LJHexColor(@"#848484");
        _titleLabel.font = [UIFont fontWithName:Regular size:18];
    }
    return _titleLabel;
}

- (UILabel *)selectedCityLabel {
    if (!_selectedCityLabel) {
        _selectedCityLabel = [[UILabel alloc] init];
        _selectedCityLabel.textColor = LJHexColor(@"#009dc2");
        _selectedCityLabel.font = [UIFont fontWithName:Regular size:18];
    }
    return _selectedCityLabel;
}

- (UIButton *)locateButton {
    if (!_locateButton) {
        _locateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _locateButton.layer.cornerRadius = 6;
        _locateButton.layer.masksToBounds = YES;
        _locateButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_locateButton setTitle:GetLocalResStr(@"relocation") forState:UIControlStateNormal];
        [_locateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_locateButton setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.4]];
    }
    return _locateButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RATIO(60));
        make.centerY.equalTo(self.locateButton.mas_centerY);
    }];
    
    [self.selectedCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.locateButton.mas_bottom).offset(10);
        make.right.equalTo(self.locateButton.mas_right);
    }];
    
    [self.locateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(RATIO(60));
        make.right.mas_equalTo(-RATIO(60));
        make.width.mas_equalTo(RATIO(400));
        make.height.mas_equalTo(RATIO(150));
    }];
}

@end
