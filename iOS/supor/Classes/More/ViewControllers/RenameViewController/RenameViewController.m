//
//  RenameViewController.m
//  supor
//
//  Created by 刘杰 on 2018/4/19.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "RenameViewController.h"
#import "RHAccountTool.h"

@interface RenameViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *renameTextField;

@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation RenameViewController

#pragma mark - View Lifecycle Method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
}

#pragma mark - Common Method
- (void)configUI {
    self.view.backgroundColor = LJHexColor(@"#EEEEEE");
}

- (void)initViews {
    [self.view addSubview:self.renameTextField];
    [self.view addSubview:self.confirmButton];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    RHBorderRadius(textField, 6, 1, [UIColor classics_blue]);
}

#pragma mark - Target Method
- (void)renameTextChangedAction:(UITextField *)textField {
    if (textField.text.length > 30) {
        textField.text = [textField.text substringToIndex:30];
    }
    if (textField.text.length > 0) {
        self.confirmButton.enabled = YES;
        [_confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor classics_blue] cornerRadius:20] forState:UIControlStateNormal];
    } else {
        self.confirmButton.enabled = NO;
        [_confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor classics_gray] cornerRadius:20] forState:UIControlStateNormal];
    }
}

- (void)confirmRenameAction {
    if (self.renameTextField.text.length == 0) {
        return;
    }
    [self.renameTextField resignFirstResponder];
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD show];
    
    switch (self.renameType) {
        case RenameNicknameType:
            [self changeNickname];
            break;
        case RenameDeviceNameType:
            [self changeDeviceName];
            break;
        case RenameShareDeviceWithEmailType :
            [self shareDeviceWithEmail];
            break;
        default:
            break;
    }
}

#pragma mark - Private Method
- (void)changeNickname {
    WEAKSELF(weakSelf);
    if ([self.renameTextField.text isEqualToString:[RHAccountTool account].user_nickName]) {
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [DCPServiceUtils changeNickName:self.renameTextField.text
                               callback:^(NSError *error) {
                                   [SVProgressHUD dismiss];
                                   if (error) {
                                       [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"airpurifier_more_show_modifyname_fail_ios") duration:1];
                                   } else {
                                       RHAccount *account = [RHAccountTool account];
                                       account.user_nickName = weakSelf.renameTextField.text;
                                       [RHAccountTool saveAccount:account];
                                       _renameBlock(weakSelf.renameTextField.text);
                                       [weakSelf.navigationController popViewControllerAnimated:YES];
                                   }
                               }];
    }
}

- (void)changeDeviceName {
    WEAKSELF(weakSelf);
    if ([self.renameTextField.text isEqualToString:self.device.deviceName]) {
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [ACBindManager changNameWithSubDomain:self.device.subDomain
                                     deviceId:self.device.deviceId
                                         name:self.renameTextField.text
                                     callback:^(NSError *error) {
                                         [SVProgressHUD dismiss];
                                         if (error) {
                                             [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"airpurifier_more_show_modifyname_fail_ios") duration:1];
                                         } else {
                                             _renameBlock(weakSelf.renameTextField.text);
                                             [weakSelf.navigationController popViewControllerAnimated:YES];
                                         }
                                     }];
    }
}

- (void)shareDeviceWithEmail {
    WEAKSELF(weakSelf);
    [ACBindManager bindDeviceWithUserSubdomain:self.device.subDomain
                                      deviceId:self.device.deviceId
                                       account:self.renameTextField.text
                                      callback:^(NSError *error) {
                                          [SVProgressHUD dismiss];
                                          if(error){
                                              [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_moredevice_show_devicesharefailed_text")];
                                          } else {
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"shareDeviceByEmailSuccess" object:nil];
                                              [weakSelf.navigationController popViewControllerAnimated:YES];
                                          }
    }];
}

#pragma mark - Setter and Getter
- (UITextField *)renameTextField {
    if (!_renameTextField) {
        _renameTextField = [[UITextField alloc] init];
        _renameTextField.backgroundColor = [UIColor whiteColor];
        _renameTextField.keyboardType = UIKeyboardTypeDefault;
        _renameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _renameTextField.textAlignment = NSTextAlignmentCenter;
        _renameTextField.textColor = LJHexColor(@"#36424a");
        _renameTextField.font = [UIFont fontWithName:Medium size:16];
        _renameTextField.layer.cornerRadius = 6;
        _renameTextField.delegate = self;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
        _renameTextField.leftView = leftView;
        _renameTextField.leftViewMode = UITextFieldViewModeAlways;
        
        [_renameTextField addTarget:self action:@selector(renameTextChangedAction:) forControlEvents:UIControlEventEditingChanged];
    }
    return _renameTextField;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor classics_gray] cornerRadius:20] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmRenameAction) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.enabled = NO;
    }
    return _confirmButton;
}

- (void)setRenameType:(RenameType)renameType {
    _renameType = renameType;
    switch (renameType) {
        case RenameNicknameType:
            self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_modifyName_title");
            self.renameTextField.placeholder = GetLocalResStr(@"airpurifier_more_show_modifyName_title");
            [self.confirmButton setTitle:GetLocalResStr(@"airpurifier_more_show_modifyname_button") forState:UIControlStateNormal];
            break;
        case RenameDeviceNameType:
            self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_modifydevicename_title");
            self.renameTextField.placeholder = GetLocalResStr(@"airpurifier_more_show_modifyname_hint");
            [self.confirmButton setTitle:GetLocalResStr(@"airpurifier_more_show_modifyname_comfirm_ios") forState:UIControlStateNormal];
            break;
        case RenameShareDeviceWithEmailType:
            self.navigationItem.title = GetLocalResStr(@"airpurifier_moredevice_show_phoneshare_text");
            self.renameTextField.placeholder = GetLocalResStr(@"airpurifier_moredevice_show_sharetophone_hint");
            [self.confirmButton setTitle:GetLocalResStr(@"airpurifier_public_ok") forState:UIControlStateNormal];
            self.renameTextField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
            
        default:
            break;
    }
}

#pragma mark - System Method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.renameTextField resignFirstResponder];
    RHBorderRadius(self.renameTextField, 6, 0, RGB(0, 0, 0));
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.renameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(45);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.renameTextField.mas_bottom).offset(30);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.equalTo(self.renameTextField.mas_height);
    }];
}

@end
