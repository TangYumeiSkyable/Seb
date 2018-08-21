//
//  RegistViewController.m
//  supor
//
//  Created by Ennnnnn7 on 2018/5/11.
//  Copyright © 2018年 XYJ. All rights reserved.
//  使用表视图进行布局，用指针指向cell中的控件，前3个cell是输入框cell，第4个cell内是提示语，第5个cell是注册button

#import "RegistViewController.h"
#import "NoDeviceViewController.h"
#import "RHBaseNavgationController.h"
#import "RegistInputTableViewCell.h"
#import "RegistOneButtonTableViewCell.h"
#import "NSString+LKExtension.h"
#import "RHAccountTool.h"
#import "ACUserInfo.h"
#import "AppDelegate.h"
#import "UAlertView.h"

static NSString * const kInputCellIdentifier = @"inputCell";
static NSString * const kTipCellIdentifier = @"tipCell";
static NSString * const kRegistCellIdentifier = @"registCell";

@interface RegistViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UAlertViewDelegate>

@property (nonatomic, strong) UITableView *registTableView;

@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, copy)   NSString *email;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UITextField *confirmPwdTextField;

@property (nonatomic, strong) UIImageView *emailCheckImageView;
@property (nonatomic, strong) UIImageView *pwdCheckImageView;
@property (nonatomic, strong) UIImageView *confirmPwdCheckImageView;

@property (nonatomic, strong) UIButton *registButton;

@property (nonatomic, strong) NSArray<NSString *> *cellTitleArray;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
}

#pragma mark - Common Method
- (void)configUI {
    self.navigationItem.title = GetLocalResStr(@"airpurifier_register_show_registertext_title");
}

- (void)initViews {
    [self.view addSubview:self.registTableView];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitleArray.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row < 3 ? 60 : 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 3) {
        
        RegistInputTableViewCell *inputCell = [tableView dequeueReusableCellWithIdentifier:kInputCellIdentifier forIndexPath:indexPath];
        inputCell.titleLabel.text = self.cellTitleArray[indexPath.row];
        inputCell.inputTextField.delegate = self;
        [inputCell.inputTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
        // 明文/密文切换按钮操作
        // plaintext/ciphetText switch button action
        inputCell.ciphetSwitchBlock = ^(UIButton *button, UITextField *textField) {
            textField.secureTextEntry = !textField.secureTextEntry;
            NSString *tempString = textField.text;
            textField.text = @"";
            textField.text = tempString;
            if (textField.secureTextEntry) {
                [button setImage:[[UIImage imageNamed:@"ico_eye_close"] imageWithSize:CGSizeMake(22, 16)] forState:UIControlStateNormal];
            } else {
                [button setImage:[[UIImage imageNamed:@"ico_eye_open"] imageWithSize:CGSizeMake(22, 16)] forState:UIControlStateNormal];
            }
        };
        // 指针指向不同cell内的输入框和输入框右侧图片
        if (indexPath.row == 0) {
            inputCell.inputTextField.keyboardType = UIKeyboardTypeEmailAddress;
            inputCell.inputTextField.rightViewMode = UITextFieldViewModeNever;
            inputCell.inputTextField.secureTextEntry = NO;
            self.emailTextField = inputCell.inputTextField;
            self.emailCheckImageView = inputCell.checkImageView;
        } else if (indexPath.row == 1) {
            self.pwdTextField = inputCell.inputTextField;
            self.pwdCheckImageView = inputCell.checkImageView;
        } else if (indexPath.row == 2) {
            inputCell.inputTextField.returnKeyType = UIReturnKeyDone;
            self.confirmPwdTextField = inputCell.inputTextField;
            self.confirmPwdCheckImageView = inputCell.checkImageView;
        }
        return inputCell;
        
    } else if (indexPath.row == 3) {
        
        UITableViewCell *tipCell = [tableView dequeueReusableCellWithIdentifier:kTipCellIdentifier forIndexPath:indexPath];
        tipCell.backgroundColor = tableView.backgroundColor;
        tipCell.textLabel.textColor = LJHexColor(@"#848484");
        tipCell.textLabel.font = [UIFont fontWithName:Regular size:12];
        tipCell.textLabel.numberOfLines = 0;
        tipCell.textLabel.text = GetLocalResStr(@"airpurifier_login_show_registepasswordrule_text");
        tipCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return tipCell;
    }
    
    RegistOneButtonTableViewCell *registCell = [tableView dequeueReusableCellWithIdentifier:kRegistCellIdentifier forIndexPath:indexPath];
    [registCell.registButton addTarget:self action:@selector(accountRegistAction:) forControlEvents:UIControlEventTouchUpInside];
    self.registButton = registCell.registButton;
    return registCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // pack up the keyboard
    [self.view endEditing:YES];
    RHBorderRadius(self.emailTextField, 6, 0, [UIColor classics_blue]);
    RHBorderRadius(self.pwdTextField, 6, 0, [UIColor classics_blue]);
    RHBorderRadius(self.confirmPwdTextField, 6, 0, [UIColor classics_blue]);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // change UI with textfield status
    RHBorderRadius(self.emailTextField, 6, 0, [UIColor classics_blue]);
    RHBorderRadius(self.pwdTextField, 6, 0, [UIColor classics_blue]);
    RHBorderRadius(self.confirmPwdTextField, 6, 0, [UIColor classics_blue]);
    if (textField == self.emailTextField) {
        RHBorderRadius(self.emailTextField, 6, 1, [UIColor classics_blue]);
    } else if (textField == self.pwdTextField) {
        RHBorderRadius(self.pwdTextField, 6, 1, [UIColor classics_blue]);
    } else if (textField == self.confirmPwdTextField) {
        RHBorderRadius(self.confirmPwdTextField, 6, 1, [UIColor classics_blue]);
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // click keyboard “return” and next textfield becomes first responder
    // 点击键盘上的“return”，光标移动到下一个输入框，最后一个输入框直接取消响应者
    if (textField == self.emailTextField) {
        [self.pwdTextField becomeFirstResponder];
    } else if (textField == self.pwdTextField) {
        [self.confirmPwdTextField becomeFirstResponder];
    } else if (textField == self.confirmPwdTextField) {
        [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark - UAlertViewDelegate
- (void)alertView:(UAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10001) {
        if (buttonIndex == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Target Action
- (void)textFieldDidChanged:(UITextField *)textField {
    // check email specification
    if (textField == self.emailTextField) {
        NSString *emailStr = textField.text;
        if (emailStr && emailStr.length>1) {
            NSString *lastStr = [emailStr substringFromIndex:emailStr.length-1];
            if ([lastStr isEqualToString:@" "]) {

                emailStr = [emailStr substringToIndex:emailStr.length-1];
            }
            self.email = emailStr;
        }
        
        if ([emailStr checkMail]) {
            self.emailCheckImageView.image = [UIImage imageNamed:@"ico_right_sel"];
        } else {
            self.emailCheckImageView.image = [UIImage imageNamed:@"ico_right_nor"];
        }
    } else if (textField == self.pwdTextField) {
        // check password specification
        if ([textField.text checkPassword]) {
            self.pwdCheckImageView.image = [UIImage imageNamed:@"ico_right_sel"];
        } else {
            self.pwdCheckImageView.image = [UIImage imageNamed:@"ico_right_nor"];
        }
    } else if (textField == self.confirmPwdTextField) {
        // check confirm password specification
        if ([textField.text checkPassword] && [textField.text isEqualToString:self.pwdTextField.text]) {
            self.confirmPwdCheckImageView.image = [UIImage imageNamed:@"ico_right_sel"];
        } else {
            self.confirmPwdCheckImageView.image = [UIImage imageNamed:@"ico_right_nor"];
        }
    }
    
    // change regist button status with textfields specification
    if ([self.email checkMail] && [self.pwdTextField.text checkPassword] && [self.confirmPwdTextField.text isEqualToString:self.pwdTextField.text]) {
        self.registButton.userInteractionEnabled = YES;
        [self.registButton setBackgroundImage:[UIImage imageWithColor:[UIColor classics_blue] cornerRadius:RegistButtonHeight * 0.5] forState:UIControlStateNormal];
    } else {
        self.registButton.userInteractionEnabled = NO;
        [self.registButton setBackgroundImage:[UIImage imageWithColor:[UIColor classics_gray] cornerRadius:RegistButtonHeight * 0.5] forState:UIControlStateNormal];
    }
}

- (void)accountRegistAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD show];
    
    WEAKSELF(ws);
    // check account exist
    [ACAccountManager checkExist:self.email callback:^(BOOL exist, NSError *error) {
        if (exist) {
            [SVProgressHUD dismiss];
            [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_login_show_registertosphonealreadyregidter_text")];
        } else {
            // DCP regist account with email
            [DCPServiceUtils registerWithNickName:self.email
                                            email:self.email
                                         password:self.pwdTextField.text
                                       verifyCode:nil
                                         callback:^(ACUserInfo *user, NSError *error) {
                                             if (error) {
                                                 [SVProgressHUD dismiss];
                                                 NSInteger errorCode = error.code;
                                                 if (errorCode == 5000) { // regist fail
                                                     [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_regist_fail")];
                                                 } else if (errorCode == 5001) { // login fail
                                                     [ws registLoginFailAction];
                                                 } else if (errorCode == 3502) { // account exist
                                                     [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_login_show_registertosphonealreadyregidter_text")];
                                                 } else if (errorCode == 2015) {
                                                     UAlertView *errorAlert = [[UAlertView alloc] initWithTitle:nil
                                                                                                           msg:GetLocalResStr(@"password_not_secured_enough")
                                                                                                   cancelTitle:GetLocalResStr(@"ok")
                                                                                                       okTitle:nil];
                                                     [errorAlert show];
                                                 }
//                                                 else {
//                                                     [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_public_fail")];
//                                                 }
                                             } else {
                                                 // 设置用户推送相关的附加属性
                                                 ACObject *obj = [[ACObject alloc] init];
                                                 [obj putBool:@"notifyFlg1" value:1];
                                                 [obj putBool:@"notifyFlg2" value:1];
                                                 [obj putBool:@"notifyFlg3" value:1];
                                                 [obj putBool:@"notifyFlg4" value:1];
                                                 [obj putString:@"work_model" value:@"{\"workStatus\":\"1\",\"weekDay\":\"week[1,2,3,4,5]\",\"startTime\":\"08:00\",\"endTime\":\"17:00\",\"selected\":\"device[]\",\"unselected\":\"device[]\"}"];
                                                 [obj putString:@"space" value:@"0-10㎡"];
                                                 [ACAccountManager setUserProfile:obj callback:^(NSError *error) {
                                                     [SVProgressHUD dismiss];
                                                     RHAccount *account = [RHAccountTool account];
                                                     account.user_ID = user.userId;
                                                     account.user_nickName = user.nickName;
                                                     account.user_phoneNumber = user.email;
                                                     [RHAccountTool saveAccount:account];
                                                     
                                                     AppDelegate *app = [AppDelegate sharedInstance];
                                                     [app setAlias: [NSString stringWithFormat:@"%ld",(long)account.user_ID]];
                                                     NoDeviceViewController * vc = [[NoDeviceViewController alloc]init];
                                                     RHBaseNavgationController * nc = [[RHBaseNavgationController alloc]initWithRootViewController:vc];
                                                     app.window.rootViewController = nc;
                                                 }];
                                             }
                                         }];
        }
    }];
}

- (void)registLoginFailAction {
    UAlertView * alert = [[UAlertView alloc] initWithTitle:nil
                                                       msg:GetLocalResStr(@"airpurifier_regist_login_fail")
                                               cancelTitle:GetLocalResStr(@"airpurifier_public_cancel")
                                                   okTitle:GetLocalResStr(@"airpurifier_public_ok")];
    alert.delegate = self;
    alert.tag = 10001;
    [alert setOKButtonColor:[UIColor classics_blue] andCancelButtonColor:[UIColor classics_black]];
    [alert show];
}

#pragma mark - Lazyload Methods
- (UITableView *)registTableView {
    if (!_registTableView) {
        _registTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _registTableView.delegate = self;
        _registTableView.dataSource = self;
        _registTableView.scrollEnabled = NO;
        _registTableView.tableFooterView = [UIView new];
        _registTableView.showsVerticalScrollIndicator = NO;
        _registTableView.backgroundColor = LJHexColor(@"#EEEEEE");
        _registTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        _registTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_registTableView registerClass:[RegistInputTableViewCell class] forCellReuseIdentifier:kInputCellIdentifier];
        [_registTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTipCellIdentifier];
        [_registTableView registerClass:[RegistOneButtonTableViewCell class] forCellReuseIdentifier:kRegistCellIdentifier];
    }
    return _registTableView;
}

- (NSArray *)cellTitleArray {
    if (!_cellTitleArray) {
        _cellTitleArray = @[GetLocalResStr(@"airpurifier_login_show_email_text"),
                            GetLocalResStr(@"airpurifier_login_show_pwd_text"),
                            GetLocalResStr(@"airpurifier_login_show_registeconfirmpwd_text")
                            ];
    }
    return _cellTitleArray;
}

#pragma mark - System Methods
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.registTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

@end
