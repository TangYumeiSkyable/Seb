//
//  LoginViewController.m
//  supor
//
//  Created by Ennnnnn7 on 2018/5/7.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "LoginViewController.h"
#import "ResetPasswordViewController.h"
#import "RHAgreementViewController.h"
#import "LicenseViewController.h"
#import "LoginView.h"
#import "UAlertView.h"
#import "ACUserInfo.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "RHAccountTool.h"
#import "AppDelegate+Add.h"

@interface LoginViewController ()<UITextFieldDelegate, UAlertViewDelegate>

@property (nonatomic, strong) LoginView *loginView;

@end

@implementation LoginViewController

#pragma mark - View LifeCycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - Common Methods
- (void)configUI {
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)initViews {
    [self.view addSubview:self.loginView];
    RHAccount *account = [RHAccountTool account];
    if (account) {
        self.loginView.emailTextField.text = account.user_phoneNumber;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.loginView.emailTextField) {
        RHBorderRadius(self.loginView.emailTextField, 6, 1, [UIColor classics_blue]);
        RHBorderRadius(self.loginView.pwdTextField, 6, 1, [UIColor clearColor]);
    } else {
        RHBorderRadius(self.loginView.emailTextField, 6, 1, [UIColor clearColor]);
        RHBorderRadius(self.loginView.pwdTextField, 6, 1, [UIColor classics_blue]);
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.loginView.emailTextField) {
        [self.loginView.pwdTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.loginView.emailTextField.text.length != 0 && self.loginView.pwdTextField.text.length != 0) {
        self.loginView.loginButton.userInteractionEnabled = YES;
        [self.loginView.loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor classics_blue] cornerRadius:26] forState:UIControlStateNormal];
    } else {
        self.loginView.loginButton.userInteractionEnabled = NO;
        [self.loginView.loginButton setBackgroundImage:[UIImage imageWithColor:LJHexColor(@"#848484") cornerRadius:26] forState:UIControlStateNormal];
    }
}

#pragma mark - UAlertViewDelegate
- (void)alertView:(UAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 之前的逻辑，猜测是响应window上的弹窗
    // old code
    if (buttonIndex == 1) {
        RHAgreementViewController *agreementVC = [[RHAgreementViewController alloc] init];
        [self.navigationController pushViewController:agreementVC animated:YES];
    } else {
        LicenseViewController *licenseVC = [[UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LicenseViewController"];
        [self.navigationController pushViewController:licenseVC animated:YES];
    }
}

#pragma mark - Target Method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    RHBorderRadius(self.loginView.emailTextField, 6, 1, [UIColor clearColor]);
    RHBorderRadius(self.loginView.pwdTextField, 6, 1, [UIColor clearColor]);
}

- (void)securySwitchAction:(UIButton *)sender {
    // switch text/ciphertext
    self.loginView.pwdTextField.secureTextEntry = !self.loginView.pwdTextField.secureTextEntry;
    NSString *tempString = self.loginView.pwdTextField.text;
    self.loginView.pwdTextField.text = @"";
    self.loginView.pwdTextField.text = tempString;
    if (self.loginView.pwdTextField.secureTextEntry) {
        [sender setImage:[[UIImage imageNamed:@"ico_eye_close"] imageWithSize:CGSizeMake(22, 16)] forState:UIControlStateNormal];
    } else {
        [sender setImage:[[UIImage imageNamed:@"ico_eye_open"] imageWithSize:CGSizeMake(22, 16)] forState:UIControlStateNormal];
    }
}

- (void)loginAction {
    [self.view endEditing:YES];
    // check input content
    if (self.loginView.emailTextField.text.length == 0 || self.loginView.pwdTextField.text.length == 0) {
        return;
    }
    // check network status
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if ( 0 == reach.currentReachabilityStatus){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"airpurifier_login_show_tosneterror_text") duration:1];
        });
        return;
    }
    
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:LJHexColor(@"#009dc2")];
    [SVProgressHUD showImage:[UIImage imageNamed:@"ico_wait.png"] status:GetLocalResStr(@"airpurifier_login_show_toslogining_text")];
    
    // DCP Service login
   
    NSString *emailStr = self.loginView.emailTextField.text;
    if (emailStr && emailStr.length>1) {
        NSString *lastStr = [emailStr substringFromIndex:emailStr.length-1];
        if ([lastStr isEqualToString:@" "]) {
            
            emailStr = [emailStr substringToIndex:emailStr.length-1];
        }
    }
    [DCPServiceUtils loginWithName:emailStr
                          password:self.loginView.pwdTextField.text
                          callback:^(ACUserInfo *userInfo, NSError *error) {
                              if (error) {
//                                  [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"airpurifier_login_show_toswrongpwdaccount_text") duration:1];
                              } else {
                          // local cache account info and queryUsersDevice
                          // 在“queryUsersDevice”进行了页面跳转
                                  AppDelegate * app = [AppDelegate sharedInstance];
                                  RHAccount *account = [RHAccountTool account];
                                  account.user_ID = userInfo.userId;
                                  account.user_nickName = userInfo.nickName;
                                  account.user_phoneNumber = userInfo.email;
                                  [RHAccountTool saveAccount:account];
                                  [app setAlias: [NSString stringWithFormat:@"%ld",(long)account.user_ID]];
                                  [app queryUsersDevice];
                                  [SVProgressHUD dismissWithDelay:0.1];
                              }
                          }];
}

- (void)forgetPwdAction {
    ResetPasswordViewController *resetPwdVC = [[ResetPasswordViewController alloc] init];
    [self.navigationController pushViewController:resetPwdVC animated:YES];
    return;
}

- (void)registAction {
    RHAgreementViewController *agreementVC = [[RHAgreementViewController alloc] init];
    [self.navigationController pushViewController:agreementVC animated:YES];
}

#pragma mark - Lazyload Methods
- (LoginView *)loginView {
    if (!_loginView) {
        _loginView = [[LoginView alloc] initWithFrame:CGRectZero];
        _loginView.emailTextField.delegate = self;
        _loginView.pwdTextField.delegate = self;
        [_loginView.emailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_loginView.pwdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_loginView.securySwitchButton addTarget:self action:@selector(securySwitchAction:) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.registButton addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.forgetPwdButton addTarget:self action:@selector(forgetPwdAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginView;
}

#pragma mark - System Methods
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

@end
