//
//  ChangePWDView.m
//  supor
//
//  Created by 刘杰 on 2018/4/23.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "ChangePWDView.h"
#import "UIImage+FlatUI.h"

@implementation ChangePWDView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = LJHexColor(@"#EEEEEE");
        [self initViews];
    }
    return self;
}

#pragma mark - Common Methods
- (void)initViews {
    [self addSubview:self.pwdTitleLabel];
    [self addSubview:self.pwdTextField];
    [self addSubview:self.pwdCheckImageView];
    [self addSubview:self.confirmTitleLabel];
    [self addSubview:self.confirmTextField];
    [self addSubview:self.confirmCheckImageView];
    [self addSubview:self.tipLabel];
    [self addSubview:self.submitButton];
}

#pragma mark - LazyLoad Methods
- (UILabel *)pwdTitleLabel {
    if (!_pwdTitleLabel) {
        _pwdTitleLabel = [[UILabel alloc] init];
        _pwdTitleLabel.text = GetLocalResStr(@"airpurifier_login_show_pwd_text");
        _pwdTitleLabel.textColor = LJHexColor(@"#848484");
        _pwdTitleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        _pwdTitleLabel.adjustsFontSizeToFitWidth = YES;
        _pwdTitleLabel.numberOfLines = 0;
    }
    return _pwdTitleLabel;
}

- (UITextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = [[UITextField alloc] init];
        _pwdTextField.placeholder = GetLocalResStr(@"airpurifier_register_show_pwd_placeholder");
        _pwdTextField.textAlignment = NSTextAlignmentCenter;
        _pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdTextField.backgroundColor = [UIColor whiteColor];
        _pwdTextField.textColor = LJHexColor(@"#36424a");
        _pwdTextField.font = [UIFont fontWithName:Medium size:16];
        _pwdTextField.layer.cornerRadius = 6;
        _pwdTextField.secureTextEntry = YES;
        
        UIView *pwdLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _pwdTextField.leftView = pwdLeftView;
        _pwdTextField.leftViewMode = UITextFieldViewModeAlways;
        
        _pwdTextField.rightView = self.pwdSwitchButton;
        _pwdTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _pwdTextField;
}

- (UIButton *)pwdSwitchButton {
    if (!_pwdSwitchButton) {
        _pwdSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // change image size to fit UI
        [_pwdSwitchButton setImage:[[UIImage imageNamed:@"ico_eye_close"] imageWithSize:CGSizeMake(22, 16)] forState:UIControlStateNormal];
    }
    return _pwdSwitchButton;
}

- (UIImageView *)pwdCheckImageView {
    if (!_pwdCheckImageView) {
        _pwdCheckImageView = [[UIImageView alloc] init];
        _pwdCheckImageView.layer.cornerRadius = 10;
        _pwdCheckImageView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        _pwdCheckImageView.image = [UIImage imageNamed:@"ico_right_nor"];
    }
    return _pwdCheckImageView;
}

- (UILabel *)confirmTitleLabel {
    if (!_confirmTitleLabel) {
        _confirmTitleLabel = [[UILabel alloc] init];
        _confirmTitleLabel.text = GetLocalResStr(@"airpurifier_login_show_registeconfirmpwd_text");
        _confirmTitleLabel.textColor = LJHexColor(@"#848484");
        _confirmTitleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        _confirmTitleLabel.adjustsFontSizeToFitWidth = YES;
        _confirmTitleLabel.numberOfLines = 0;
    }
    return _confirmTitleLabel;
}

- (UITextField *)confirmTextField {
    if (!_confirmTextField) {
        _confirmTextField = [[UITextField alloc] init];
        _confirmTextField.placeholder = GetLocalResStr(@"airpurifier_register_show_pwd_placeholder");
        _confirmTextField.textAlignment = NSTextAlignmentCenter;
        _confirmTextField.backgroundColor = [UIColor whiteColor];
        _confirmTextField.textColor = LJHexColor(@"#36424a");
        _confirmTextField.font = [UIFont fontWithName:Medium size:16];
        _confirmTextField.layer.cornerRadius = 6;
        _confirmTextField.secureTextEntry = YES;
        
        UIView *confirmLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _confirmTextField.leftView = confirmLeftView;
        _confirmTextField.leftViewMode = UITextFieldViewModeAlways;
        
        _confirmTextField.rightView = self.confirmSwitchButton;
        _confirmTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _confirmTextField;
}

- (UIButton *)confirmSwitchButton {
    if (!_confirmSwitchButton) {
        _confirmSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmSwitchButton setImage:[[UIImage imageNamed:@"ico_eye_close"] imageWithSize:CGSizeMake(22, 16)] forState:UIControlStateNormal];
    }
    return _confirmSwitchButton;
}

- (UIImageView *)confirmCheckImageView {
    if (!_confirmCheckImageView) {
        _confirmCheckImageView = [[UIImageView alloc] init];
        _confirmCheckImageView.image = [UIImage imageNamed:@"ico_right_nor"];
        _confirmCheckImageView.layer.cornerRadius = 10;
        _confirmCheckImageView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    return _confirmCheckImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = GetLocalResStr(@"airpurifier_login_show_registepasswordrule_text");
        _tipLabel.textColor = LJHexColor(@"#848484");
        _tipLabel.font = [UIFont fontWithName:Regular size:12];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:GetLocalResStr(@"airpurifier_login_show_button_submittext") forState:UIControlStateNormal];
        [_submitButton setTitleColor:LJHexColor(@"#f2f2f2") forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        [_submitButton setBackgroundImage:[UIImage imageWithColor:[UIColor classics_gray] cornerRadius:20] forState:UIControlStateNormal];
        _submitButton.userInteractionEnabled = NO;
    }
    return _submitButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.pwdTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self.pwdTextField.mas_centerY);
        make.width.mas_equalTo(85);
    }];
    
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdTitleLabel.mas_right).offset(10);
        make.top.mas_equalTo(30);
        make.height.mas_equalTo(44);
        make.right.equalTo(self.pwdCheckImageView.mas_left).offset(-10);
    }];
    
    [self.pwdSwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.with.mas_equalTo(40);
    }];
    
    [self.pwdCheckImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self.pwdTextField.mas_centerY);
    }];
    
    [self.confirmTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdTitleLabel.mas_left);
        make.width.equalTo(self.pwdTitleLabel.mas_width);
        make.centerY.equalTo(self.confirmTextField.mas_centerY);
    }];
    
    [self.confirmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdTextField.mas_left);
        make.top.equalTo(self.pwdTextField.mas_bottom).offset(20);
        make.height.equalTo(self.pwdTextField.mas_height);
        make.width.equalTo(self.pwdTextField.mas_width);
    }];
    
    [self.confirmSwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
    }];
    
    [self.confirmCheckImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pwdCheckImageView.mas_right);
        make.width.height.equalTo(self.pwdCheckImageView.mas_width);
        make.centerY.equalTo(self.confirmTextField.mas_centerY);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.confirmTitleLabel.mas_left);
        make.top.equalTo(self.confirmTitleLabel.mas_bottom).offset(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(44);
    }];
    
}

@end
