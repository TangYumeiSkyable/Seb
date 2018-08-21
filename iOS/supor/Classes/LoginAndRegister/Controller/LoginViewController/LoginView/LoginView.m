//
//  LoginView.m
//  supor
//
//  Created by Ennnnnn7 on 2018/5/7.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "LoginView.h"
#import "UIImage+FlatUI.h"

@interface LoginView ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *emailTitleLabel;

@property (nonatomic, strong) UILabel *pwdTitleLabel;

@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = LJHexColor(@"#EEEEEE");
        [self initViews];
    }
    return self;
}

#pragma mark - Common Methods
- (void)initViews {
    [self addSubview:self.iconImageView];
    [self addSubview:self.emailTitleLabel];
    [self addSubview:self.emailTextField];
    [self addSubview:self.pwdTitleLabel];
    [self addSubview:self.pwdTextField];
    [self addSubview:self.loginButton];
    [self addSubview:self.forgetPwdButton];
    [self addSubview:self.registButton];
}

#pragma mark - Lazyload Methods
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1024"]];
    }
    return _iconImageView;
}

- (UILabel *)emailTitleLabel {
    if (!_emailTitleLabel) {
        _emailTitleLabel = [[UILabel alloc] init];
        _emailTitleLabel.text = GetLocalResStr(@"airpurifier_login_show_email_text");
        _emailTitleLabel.textColor = LJHexColor(@"#848484");
        _emailTitleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        _emailTitleLabel.numberOfLines = 0;
    }
    return _emailTitleLabel;
}

- (UITextField *)emailTextField {
    if (!_emailTextField) {
        _emailTextField = [[UITextField alloc] init];
        _emailTextField.backgroundColor = [UIColor whiteColor];
        _emailTextField.textColor = LJHexColor(@"#36424a");
        _emailTextField.font = [UIFont fontWithName:Medium size:16];
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTextField.textAlignment = NSTextAlignmentCenter;
        _emailTextField.layer.cornerRadius = 6;
        _emailTextField.returnKeyType = UIReturnKeyNext;
        _emailTextField.placeholder = GetLocalResStr(@"airpurifier_login_show_email_hint");
        [_emailTextField setValue:LJHexColor(@"#c8c8c8") forKeyPath:@"_placeholderLabel.textColor"];
        [_emailTextField setValue:@(NSTextAlignmentCenter) forKeyPath:@"_placeholderLabel.textAlignment"];
        [_emailTextField setValue:[UIFont fontWithName:Regular size:16] forKeyPath:@"_placeholderLabel.font"];
        
        UIView *emailLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
        _emailTextField.leftView = emailLeftView;
        _emailTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _emailTextField;
}

- (UILabel *)pwdTitleLabel {
    if (!_pwdTitleLabel) {
        _pwdTitleLabel = [[UILabel alloc] init];
        _pwdTitleLabel.text = GetLocalResStr(@"airpurifier_login_show_pwd_text");
        _pwdTitleLabel.textColor = LJHexColor(@"#848484");
        _pwdTitleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        _pwdTitleLabel.numberOfLines = 0;
    }
    return _pwdTitleLabel;
}

- (UITextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = [[UITextField alloc] init];
        _pwdTextField.backgroundColor = [UIColor whiteColor];
        _pwdTextField.secureTextEntry = YES;
        _pwdTextField.textColor = LJHexColor(@"#36424a");
        _pwdTextField.font = [UIFont fontWithName:Medium size:16];
        _pwdTextField.textAlignment = NSTextAlignmentCenter;
        _pwdTextField.layer.cornerRadius = 6;
        _pwdTextField.returnKeyType = UIReturnKeyDone;
        _pwdTextField.placeholder = GetLocalResStr(@"airpurifier_login_show_pwd_hint");
        [_pwdTextField setValue:LJHexColor(@"#c8c8c8") forKeyPath:@"_placeholderLabel.textColor"];
        [_pwdTextField setValue:@(NSTextAlignmentCenter) forKeyPath:@"_placeholderLabel.textAlignment"];
        [_pwdTextField setValue:[UIFont fontWithName:Regular size:16] forKeyPath:@"_placeholderLabel.font"];
        
        UIView *pwdLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
        _pwdTextField.leftView = pwdLeftView;
        _pwdTextField.leftViewMode = UITextFieldViewModeAlways;
        
        _pwdTextField.rightView = self.securySwitchButton;
        _pwdTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _pwdTextField;
}

- (UIButton *)securySwitchButton {
    if (!_securySwitchButton) {
        _securySwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_securySwitchButton setImage:[[UIImage imageNamed:@"ico_eye_close"] imageWithSize:CGSizeMake(22, 16)] forState:UIControlStateNormal];
    }
    return _securySwitchButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:GetLocalResStr(@"airpurifier_login_show_button_text") forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        [_loginButton setBackgroundImage:[UIImage imageWithColor:LJHexColor(@"#848484") cornerRadius:26] forState:UIControlStateNormal];
        _loginButton.userInteractionEnabled = NO;
    }
    return _loginButton;
}

- (UIButton *)forgetPwdButton {
    if (!_forgetPwdButton) {
        _forgetPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *forgetString = [[NSMutableAttributedString alloc] initWithString:GetLocalResStr(@"airpurifier_login_show_forgetpwd_text")
                                                                                         attributes:@{
                                                                                                      NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                                                                                                      NSForegroundColorAttributeName : [UIColor classics_gray],
                                                                                                      NSFontAttributeName : [UIFont systemFontOfSize:14]
                                                                                                      }];
        [_forgetPwdButton setAttributedTitle:forgetString forState:UIControlStateNormal];
    }
    return _forgetPwdButton;
}

- (UIButton *)registButton {
    if (!_registButton) {
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *registString = [[NSMutableAttributedString alloc] initWithString:GetLocalResStr(@"airpurifier_login_show_register_text")
                                                                                         attributes:@{
                                                                                                      NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                                                                                                      NSForegroundColorAttributeName : [UIColor classics_gray],
                                                                                                      NSFontAttributeName : [UIFont systemFontOfSize:14]
                                                                                                      }];
        [_registButton setAttributedTitle:registString forState:UIControlStateNormal];
    }
    return _registButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.width.mas_equalTo(75);
        make.top.mas_equalTo(DeviceUtils.statusBarHeight + 41);
    }];

    [self.emailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self.emailTextField.mas_centerY);
        make.width.mas_equalTo(90);
    }];

    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(50);
        make.left.equalTo(self.emailTitleLabel.mas_right).offset(10);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(43);
    }];

    [self.pwdTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.emailTitleLabel.mas_left);
        make.centerY.equalTo(self.pwdTextField.mas_centerY);
        make.width.equalTo(self.emailTitleLabel.mas_width);
    }];

    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.emailTitleLabel.mas_right).offset(10);
        make.top.equalTo(self.emailTextField.mas_bottom).offset(25);
        make.right.equalTo(self.emailTextField.mas_right);
        make.height.equalTo(self.emailTextField.mas_height);
    }];
    
    [self.securySwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
    }];

    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.equalTo(self.pwdTitleLabel.mas_bottom).offset(55);
        make.height.mas_equalTo(55);
    }];

    [self.forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(20);
        make.left.mas_equalTo(40);
        make.right.equalTo(self.registButton.mas_left).offset(-10);
        make.width.equalTo(self.registButton.mas_width);
        make.height.mas_equalTo(40);
    }];

    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.height.equalTo(self.forgetPwdButton.mas_height);
        make.top.equalTo(self.forgetPwdButton.mas_top);
    }];
}

@end
