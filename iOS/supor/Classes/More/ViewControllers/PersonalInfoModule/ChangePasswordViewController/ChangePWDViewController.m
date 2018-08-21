//
//  ChangePWDViewController.m
//  supor
//
//  Created by 刘杰 on 2018/4/23.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "ChangePWDViewController.h"
#import "ChangePWDView.h"
#import "RHAccountTool.h"
#import "NSString+LKExtension.h"
#import "UAlertView.h"

@interface ChangePWDViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) ChangePWDView *changePasswordView;

@end

@implementation ChangePWDViewController

#pragma mark - View LifeCycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Common Methods
- (void)configUI {
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_change_password_text");
}

- (void)initViews {
    [self.view addSubview:self.changePasswordView];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.changePasswordView.pwdTextField) {
        RHBorderRadius(self.changePasswordView.pwdTextField, 6, 1, [UIColor classics_blue]);
        RHBorderRadius(self.changePasswordView.confirmTextField, 6, 0, [UIColor classics_blue]);
    } else if (textField == self.changePasswordView.confirmTextField) {
        RHBorderRadius(self.changePasswordView.pwdTextField, 6, 0, [UIColor classics_blue]);
        RHBorderRadius(self.changePasswordView.confirmTextField, 6, 1, [UIColor classics_blue]);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.changePasswordView.pwdTextField) {
        RHBorderRadius(self.changePasswordView.pwdTextField, 6, 0, [UIColor classics_blue]);
    } else if (textField == self.changePasswordView.confirmTextField) {
        RHBorderRadius(self.changePasswordView.confirmTextField, 6, 0, [UIColor classics_blue]);
    }
}

#pragma mark - Target Methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)textFieldChanged:(UITextField *)textField {
    // change UI by password edit
    if (textField == self.changePasswordView.pwdTextField) {
        if ([self.changePasswordView.pwdTextField.text checkPassword]) {
            self.changePasswordView.pwdCheckImageView.image = [UIImage imageNamed:@"ico_right_sel"];
        } else {
            self.changePasswordView.pwdCheckImageView.image = [UIImage imageNamed:@"ico_right_nor"];
        }
    }
    
    if (textField == self.changePasswordView.confirmTextField) {
        if ([self.changePasswordView.confirmTextField.text checkPassword]) {
            self.changePasswordView.confirmCheckImageView.image = [UIImage imageNamed:@"ico_right_sel"];
        } else {
            self.changePasswordView.confirmCheckImageView.image = [UIImage imageNamed:@"ico_right_nor"];
        }
    }
    
    if ([self.changePasswordView.pwdTextField.text checkPassword] && [self.changePasswordView.confirmTextField.text checkPassword] && ([self.changePasswordView.pwdTextField.text isEqualToString:self.changePasswordView.confirmTextField.text])) {
        [self.changePasswordView.submitButton setBackgroundImage:[UIImage imageWithColor:[UIColor classics_blue] cornerRadius:20] forState:UIControlStateNormal];
        self.changePasswordView.submitButton.userInteractionEnabled = YES;
    } else {
        [self.changePasswordView.submitButton setBackgroundImage:[UIImage imageWithColor:[UIColor classics_gray] cornerRadius:20] forState:UIControlStateNormal];
        self.changePasswordView.submitButton.userInteractionEnabled = NO;
    }
    
}

- (void)textFieldBeginEdit:(UITextField *)textField {
    if (textField == self.changePasswordView.pwdTextField) {
        RHBorderRadius(self.changePasswordView.pwdTextField, 6, 1, [UIColor classics_blue]);
        RHBorderRadius(self.changePasswordView.confirmTextField, 6, 0, [UIColor classics_blue]);
    } else if (textField == self.changePasswordView.confirmTextField) {
        RHBorderRadius(self.changePasswordView.pwdTextField, 6, 0, [UIColor classics_blue]);
        RHBorderRadius(self.changePasswordView.confirmTextField, 6, 1, [UIColor classics_blue]);
    }
}

- (void)changePWDTextfieldSecureTextEntryAction:(UIButton *)sender {
    [self changeSecureTextEntryWithTextField:self.changePasswordView.pwdTextField targetButton:sender];
}

- (void)changeConfirmTextfieldSecureTextEntryAction:(UIButton *)sender {
    [self changeSecureTextEntryWithTextField:self.changePasswordView.confirmTextField targetButton:sender];
}

- (void)changeSecureTextEntryWithTextField:(UITextField *)textField targetButton:(UIButton *)button {
    textField.secureTextEntry = !textField.secureTextEntry;
    NSString *tempString = textField.text;
    textField.text = @" ";
    textField.text = tempString;
    if (textField.secureTextEntry) {
        [button setImage:[[UIImage imageNamed:@"ico_eye_close"] imageWithSize:CGSizeMake(22, 16)] forState:UIControlStateNormal];
    } else {
        [button setImage:[[UIImage imageNamed:@"ico_eye_open"] imageWithSize:CGSizeMake(22, 16)] forState:UIControlStateNormal];
    }
}

- (void)submitNewPasswordAction {
    [self.view endEditing:YES];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD show];
    [DCPServiceUtils updatePasswordWithAccount:[RHAccountTool account].user_phoneNumber
                                      password:self.changePasswordView.confirmTextField.text
                                      callback:^(ACUserInfo *user, NSError *error) {
                                          [SVProgressHUD dismiss];
                                          
                                          if (error) {
                                              NSInteger errorCode = error.code;
                                              if (errorCode == 2015) {
                                                  UAlertView *errorAlert = [[UAlertView alloc] initWithTitle:nil
                                                                                                         msg:GetLocalResStr(@"password_not_secured_enough")
                                                                                                 cancelTitle:GetLocalResStr(@"ok")
                                                                                                     okTitle:nil];
                                                  [errorAlert show];
                                              } else {
                                                  [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"airpurifier_personal_updatePassword_error") duration:1];
                                              }
                                          } else {
                                              [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"airpurifier_personal_updatePassword_success") duration:1];
                                              [self.navigationController popViewControllerAnimated:YES];
                                          }
                                      }];
    
}

#pragma mark - Lazyload Methods
- (ChangePWDView *)changePasswordView {
    if (!_changePasswordView) {
        _changePasswordView = [[ChangePWDView alloc] initWithFrame:CGRectZero];
        [_changePasswordView.submitButton addTarget:self action:@selector(submitNewPasswordAction) forControlEvents:UIControlEventTouchUpInside];
        [_changePasswordView.pwdSwitchButton addTarget:self action:@selector(changePWDTextfieldSecureTextEntryAction:) forControlEvents:UIControlEventTouchUpInside];
        [_changePasswordView.confirmSwitchButton addTarget:self action:@selector(changeConfirmTextfieldSecureTextEntryAction:) forControlEvents:UIControlEventTouchUpInside];
        [_changePasswordView.pwdTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [_changePasswordView.confirmTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        _changePasswordView.pwdTextField.delegate = self;
        _changePasswordView.confirmTextField.delegate = self;
    }
    return _changePasswordView;
}

#pragma mark - System Methods
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.changePasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

@end
