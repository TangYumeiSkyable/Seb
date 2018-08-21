//
//  ResetPasswordViewController.m
//  supor
//
//  Created by Ennnnnn7 on 2018/5/11.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "ResetNoticeViewController.h"
#import "NSString+LKExtension.h"

@interface ResetPasswordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *emailTitleLabel;

@property (nonatomic, strong) UITextField *emailTextField;

@property (nonatomic, strong) UIButton *resetButton;

@end

static const float resetButtonHeight = 44;

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
}

#pragma mark - Common Methods
- (void)configUI {
    self.navigationItem.title = GetLocalResStr(@"airpurifier_login_show_reset_title_text");
    self.view.backgroundColor = LJHexColor(@"#EEEEEE");
}

- (void)initViews {
    [self.view addSubview:self.emailTitleLabel];
    [self.view addSubview:self.emailTextField];
    [self.view addSubview:self.resetButton];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    RHBorderRadius(textField, 6, 1, [UIColor classics_blue]);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    RHBorderRadius(textField, 6, 0, [UIColor classics_blue]);
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Target Methods
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length != 0) {
        _resetButton.userInteractionEnabled = YES;
        [self.resetButton setBackgroundImage:[UIImage imageWithColor:[UIColor  classics_blue] cornerRadius:resetButtonHeight * 0.5] forState:UIControlStateNormal];
    } else {
        _resetButton.userInteractionEnabled = NO;
        [self.resetButton setBackgroundImage:[UIImage  imageWithColor:[UIColor classics_gray] cornerRadius:resetButtonHeight * 0.5]forState:UIControlStateNormal];
    }
}

- (void)resetPasswordAction:(UIButton *)sender {
    
    NSString *emailStr = self.emailTextField.text;
    if (emailStr && emailStr.length>1) {
        
        NSString *lastStr = [emailStr substringFromIndex:emailStr.length-1];
        if ([lastStr isEqualToString:@" "]) {
            
            emailStr = [emailStr substringToIndex:emailStr.length-1];
        }
    }
    if (![emailStr checkMail]) {
        [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_login_show_registertosinvalidphonenumber_text")];
        return;
    }
    [self.view endEditing:YES];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD show];
    // 1. AC check accout is exist
    // 2. DCP reset password
    // 3. success: push to notice page; fail: toast
    [ACAccountManager checkExist:emailStr
                        callback:^(BOOL exist, NSError *error) {
                            if (exist) {
                                [DCPServiceUtils resetPasswordWithAccount:emailStr
                                                                 callback:^(BOOL success, NSError *error) {
                                                                     [SVProgressHUD dismiss];
                                                                     if (!success) {
                                                                         [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_login_show_passwordresetfail_text")];
                                                                     } else {
                                                                         // 成功之后跳转到提示成功控制器
                                                                         ResetNoticeViewController *noticeVC = [[ResetNoticeViewController alloc] init];
                                                                         noticeVC.emailText = emailStr;
                                                                         [self.navigationController pushViewController:noticeVC animated:YES];
                                                                     }
                                                                 }];
                            } else {
                                [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_login_show_registertosinvalidphonenumber_text")];
                            }
                        }];
}

#pragma mark - Lazyload Methods
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
        _emailTextField.placeholder = GetLocalResStr(@"airpurifier_login_show_email_hint");
        _emailTextField.returnKeyType = UIReturnKeyDone;
        _emailTextField.textAlignment = NSTextAlignmentCenter;
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTextField.backgroundColor = [UIColor whiteColor];
        _emailTextField.textColor = LJHexColor(@"#36424a");
        _emailTextField.delegate = self;
        _emailTextField.layer.cornerRadius = 6;
        _emailTextField.font = [UIFont fontWithName:Medium size:16];
        
        _emailTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _emailTextField.leftViewMode = UITextFieldViewModeAlways;
        
        [_emailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_emailTextField setValue:LJHexColor(@"#c8c8c8") forKeyPath:@"_placeholderLabel.textColor"];
        [_emailTextField setValue:[UIFont fontWithName:Regular size:16] forKeyPath:@"_placeholderLabel.font"];
    }
    return _emailTextField;
}

- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetButton.userInteractionEnabled = NO;
        _resetButton.titleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        [_resetButton setTitleColor:LJHexColor(@"#f2f2f2") forState:UIControlStateNormal];
        [_resetButton setTitle:GetLocalResStr(@"airpurifier_login_show_changepassword_text") forState:UIControlStateNormal];
        [_resetButton setBackgroundImage:[UIImage imageWithColor:[UIColor classics_gray] cornerRadius:resetButtonHeight * 0.5] forState:UIControlStateNormal];
        [_resetButton addTarget:self action:@selector(resetPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}


#pragma mark - System Methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    RHBorderRadius(self.emailTextField, 6, 0, [UIColor classics_blue]);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.emailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self.emailTextField.mas_centerY);
        make.width.mas_equalTo(80);
    }];
    
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.left.equalTo(self.emailTitleLabel.mas_right).offset(10);
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(resetButtonHeight);
    }];
    
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailTextField.mas_bottom).offset(30);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(resetButtonHeight);
    }];
}

@end
