//
//  ACAddDeviceConnectDomesticController.m
//  supor
//
//  Created by Jun Zhou on 2017/11/16.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "ACAddDeviceConnectDomesticController.h"
#import "ACPageControlView.h"
#import "UIBarButtonItem+Extension.h"
#import "UINavigationBar+FlatUI.h"


#import "AppDelegate.h"
// 古北的库
#import <BLLetCore/BLController.h>
#import "ACLocalDevice.h"

#import "ACNameDeviceController.h"
#import "ACConnectionFailureController.h"
#import "JX_GCDTimerManager.h"

static CGFloat ButtonHeight = 0;
static NSString * const countDownTimerKey = @"countDownTimerKey";
//static NSInteger countDownSecond = 20;

@interface ACAddDeviceConnectDomesticController () <UITextFieldDelegate, BLControllerDelegate>

@property (strong, nonatomic) UIView *safeAreaView;

@property (strong, nonatomic) ACPageControlView *pageControlView;

@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) UIButton *addDeviceButton;

@property (strong, nonatomic) UIView *accountContainerView;

@property (strong, nonatomic) UIView *ssidContainerView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *ssidLabel;

@property (strong, nonatomic) UIView *passwordContanerView;
@property (strong, nonatomic) UILabel *passwordLabel;
@property (strong, nonatomic) UITextField *passwordTextField;

@property (strong, nonatomic) UIButton *eyeButton;

@property (strong, nonatomic) UIView *topLineView;
@property (strong, nonatomic) UIView *centerLineView;
@property (strong, nonatomic) UIView *bottomLineView;

@property (strong, nonatomic) ACWifiLinkManager *wifiManager;

@property (strong, nonatomic) UIImageView *connectingImageView;
@property (strong, nonatomic) UILabel *connectingLabel;
@property (strong, nonatomic) UIButton *nextButton;

@property (strong, nonatomic) ACUserDevice *device;

@property (strong, nonatomic) BLController *blController;
@property (assign, nonatomic) NSInteger ssidType;
@property (assign, nonatomic) BOOL isFindTargetWifi;
@property (assign, nonatomic) BOOL findWifiCount;
@property (assign, nonatomic) NSInteger totalSecond;
@property (copy, nonatomic) NSString *password;

@end

@implementation ACAddDeviceConnectDomesticController

// MARK: - getter

- (BLController *)blController {
    if (_blController == nil) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _blController = delegate.let.controller;
        _blController.delegate = self;
    }
    return _blController;
}

- (UIView *)safeAreaView {
    if (_safeAreaView == nil) {
        _safeAreaView = [[UIView alloc] init];
    }
    return _safeAreaView;
}

- (ACPageControlView *)pageControlView {
    if (_pageControlView == nil) {
        _pageControlView = [[ACPageControlView alloc] initWithPageControlNum:6 currentPage:self.pageIdx];
    }
    return _pageControlView;
}

- (UILabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:16];
        _tipLabel.textColor = [UIColor blackColor];
        _tipLabel.numberOfLines = 0;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = GetLocalResStr(@"aplink_desc_p9");

    }
    return _tipLabel;
}

- (UIButton *)addDeviceButton {
    if (_addDeviceButton == nil) {
        _addDeviceButton = [[UIButton alloc] init];
        UIImage * image = [UIImage imageWithColor:[UIColor classics_blue] cornerRadius:ButtonHeight / 2];
        [_addDeviceButton setBackgroundImage:image forState:UIControlStateNormal];
        [_addDeviceButton setTitle:GetLocalResStr(@"aplink_p9_bt") forState:UIControlStateNormal];
        _addDeviceButton.titleLabel.font = [UIFont fontWithName:Regular size:18];
        [_addDeviceButton addTarget:self action:@selector(addDeviceButtonDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addDeviceButton;
}

- (UIView *)accountContainerView {
    if (_accountContainerView == nil) {
        _accountContainerView = [[UIView alloc] init];
    }
    return _accountContainerView;
}

- (UIView *)ssidContainerView {
    if (_ssidContainerView == nil) {
        _ssidContainerView = [[UIView alloc] init];
    }
    return _ssidContainerView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.numberOfLines = 1;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = GetLocalResStr(@"airpurifier_moredevice_show_name_text");
    }
    return _nameLabel;
}

- (UILabel *)ssidLabel {
    if (_ssidLabel == nil) {
        _ssidLabel = [[UILabel alloc] init];
        _ssidLabel.font = [UIFont systemFontOfSize:16];
        _ssidLabel.textColor = [UIColor grayColor];
        _ssidLabel.numberOfLines = 1;
        _ssidLabel.textAlignment = NSTextAlignmentLeft;
        _ssidLabel.text = self.domesticSsid;
    }
    return _ssidLabel;
}

- (UIView *)passwordContanerView {
    if (_passwordContanerView == nil) {
        _passwordContanerView = [[UIView alloc] init];
    }
    return _passwordContanerView;
}

- (UILabel *)passwordLabel {
    if (_passwordLabel == nil) {
        _passwordLabel = [[UILabel alloc] init];
        _passwordLabel.font = [UIFont systemFontOfSize:16];
        _passwordLabel.textColor = [UIColor blackColor];
        _passwordLabel.numberOfLines = 1;
        _passwordLabel.textAlignment = NSTextAlignmentLeft;
        _passwordLabel.text = GetLocalResStr(@"airpurifier_login_show_pwd_text");
    }
    return _passwordLabel;
}

- (UITextField *)passwordTextField {
    if (_passwordTextField == nil) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.placeholder = GetLocalResStr(@"airpurifier_login_show_pwd_hint");
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.delegate = self;
    }
    return _passwordTextField;
}

- (UIButton *)eyeButton {
    if (_eyeButton == nil) {
        _eyeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_eyeButton setImage:GETIMG(@"ico_eye_close") forState:UIControlStateNormal];
        [_eyeButton addTarget:self action:@selector(eyeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eyeButton;
}

- (UIView *)topLineView {
    if (_topLineView == nil) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = LineColor;
    }
    return _topLineView;
}

- (UIView *)centerLineView {
    if (_centerLineView == nil) {
        _centerLineView = [[UIView alloc] init];
        _centerLineView.backgroundColor = LineColor;
    }
    return _centerLineView;
}

- (UIView *)bottomLineView {
    if (_bottomLineView == nil) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = LineColor;
    }
    return _bottomLineView;
}

- (UIImageView *)connectingImageView  {
    if (_connectingImageView == nil) {
        _connectingImageView = [[UIImageView alloc] init];
        _connectingImageView.image = GETIMG(@"img_p10");
        _connectingImageView.hidden = YES;
    }
    return _connectingImageView;
}

- (UILabel *)connectingLabel {
    if (_connectingLabel == nil) {
        _connectingLabel = [[UILabel alloc] init];
        _connectingLabel = [[UILabel alloc] init];
        _connectingLabel.font = [UIFont systemFontOfSize:16];
        _connectingLabel.textColor = [UIColor blackColor];
        _connectingLabel.numberOfLines = 0;
        _connectingLabel.textAlignment = NSTextAlignmentCenter;
        _connectingLabel.text = GetLocalResStr(@"aplink_p10");
        _connectingLabel.hidden = YES;

    }
    return _connectingLabel;
}

- (UIButton *)nextButton {
    if (_nextButton == nil) {
        _nextButton = [[UIButton alloc] init];
        UIImage * image = [UIImage imageWithColor:[UIColor classics_blue] cornerRadius:ButtonHeight / 2];
        [_nextButton setBackgroundImage:image forState:UIControlStateNormal];
        [_nextButton setTitle:GetLocalResStr(@"next") forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont fontWithName:Regular size:18];
        [_nextButton addTarget:self action:@selector(nextButtonDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _nextButton.hidden = YES;
    }
    return _nextButton;
}

- (ACWifiLinkManager *)wifiManager {
    if (_wifiManager == nil) {
        // wifi芯片品牌为古北
        _wifiManager = [[ACWifiLinkManager alloc] initWithLinkerName:ACLinkerNameGuBei];
    }
    return _wifiManager;
}

// MARK: - view lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 显示添加设备相关控件
    self.tipLabel.hidden = NO;
    self.accountContainerView.hidden = NO;
    self.addDeviceButton.hidden = NO;
    // 隐藏设备联网成功后应该显示的控件
    self.connectingImageView.hidden = YES;
    self.connectingLabel.hidden = YES;
    self.nextButton.hidden = YES;
}

// MARK: - config UI

- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = GetLocalResStr(@"fragment_p9_title");
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ButtonHeight = kMainScreenWidth > 375 ? 55 : 45;
    
    //self.findWifiCount = 2;
}

// MARK: setup subview

- (void)setupSubViews {
    [self.view addSubview:self.safeAreaView];
    [self.safeAreaView addSubview:self.pageControlView];
    [self.safeAreaView addSubview:self.tipLabel];
    [self.safeAreaView addSubview:self.addDeviceButton];
    [self.safeAreaView addSubview:self.accountContainerView];
    
    [self.accountContainerView addSubview:self.topLineView];
    [self.accountContainerView addSubview:self.centerLineView];
    [self.accountContainerView addSubview:self.bottomLineView];
    
    [self.accountContainerView addSubview:self.ssidContainerView];
    [self.ssidContainerView addSubview:self.nameLabel];
    [self.ssidContainerView addSubview:self.ssidLabel];
    
    [self.accountContainerView addSubview:self.passwordContanerView];
    [self.passwordContanerView addSubview:self.passwordLabel];
    [self.passwordContanerView addSubview:self.passwordTextField];
    [self.passwordContanerView addSubview:self.eyeButton];
    
    [self.safeAreaView addSubview:self.connectingImageView];
    [self.safeAreaView addSubview:self.connectingLabel];
    [self.safeAreaView addSubview:self.nextButton];
}

// MARK: - layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    WEAKSELF(ws);
    [ws.safeAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(DeviceUtils.navigationStatusBarHeight);
        make.left.equalTo(ws.view);
        make.bottom.equalTo(ws.view).offset(-DeviceUtils.bottomSafeHeight);
        make.right.equalTo(ws.view);
    }];
    
    [ws.pageControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(ws.safeAreaView);
        make.height.mas_equalTo(60);
    }];
    
    [ws.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.pageControlView.mas_bottom).offset(60);
        make.left.equalTo(ws.safeAreaView).offset(15);
        make.right.equalTo(ws.safeAreaView).offset(-15);
    }];
    
    [ws.addDeviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RATIO(90));
        make.right.mas_equalTo(-RATIO(90));
        make.height.mas_equalTo(ButtonHeight);
        make.bottom.equalTo(ws.safeAreaView).offset(-44);
    }];
    
    [ws.accountContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.safeAreaView);
        make.right.equalTo(ws.safeAreaView);
        make.bottom.equalTo(ws.addDeviceButton.mas_top).offset(-60);
        make.height.mas_equalTo(120);
    }];
    
    [ws.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.accountContainerView);
        make.left.equalTo(ws.accountContainerView);
        make.right.equalTo(ws.accountContainerView);
        make.height.mas_equalTo(1);
    }];
    
    [ws.centerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.accountContainerView).offset(60);
        make.left.equalTo(ws.accountContainerView);
        make.right.equalTo(ws.accountContainerView);
        make.height.mas_equalTo(1);
    }];
    
    [ws.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.accountContainerView);
        make.left.equalTo(ws.accountContainerView);
        make.right.equalTo(ws.accountContainerView);
        make.height.mas_equalTo(1);
    }];
    
    [ws.ssidContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.accountContainerView);
        make.left.equalTo(ws.accountContainerView);
        make.right.equalTo(ws.accountContainerView);
        make.height.equalTo(ws.accountContainerView.mas_height).multipliedBy(0.5);
    }];
    
    [ws.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.centerY.equalTo(ws.ssidContainerView);
    }];
    
    [ws.ssidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.ssidContainerView);
        make.left.mas_equalTo(DeviceUtils.screenWidth / 5 * 2);
    }];
    
    
    
    [ws.passwordContanerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.accountContainerView);
        make.left.equalTo(ws.accountContainerView);
        make.right.equalTo(ws.accountContainerView);
        make.height.equalTo(ws.accountContainerView.mas_height).multipliedBy(0.5);
    }];
    
    
    [ws.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.centerY.equalTo(ws.passwordContanerView);
    }];
    
    [ws.eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(ws.passwordContanerView);
        make.width.mas_equalTo(60);
    }];
    
    [ws.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(DeviceUtils.screenWidth / 5 * 2);
        make.top.bottom.equalTo(ws.passwordContanerView);
        make.right.equalTo(ws.eyeButton.mas_left);
    }];
    
    
    [ws.connectingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.pageControlView.mas_bottom);
        make.left.equalTo(ws.safeAreaView).offset(60);
        make.right.equalTo(ws.safeAreaView).offset(-60);
        make.height.equalTo(ws.connectingImageView.mas_width);
    }];
    
    [ws.connectingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.connectingImageView.mas_bottom).offset(30);
        make.left.equalTo(ws.safeAreaView).offset(15);
        make.right.equalTo(ws.safeAreaView).offset(-15);
    }];
    
    [ws.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RATIO(90));
        make.right.mas_equalTo(-RATIO(90));
        make.height.mas_equalTo(ButtonHeight);
        make.bottom.equalTo(ws.safeAreaView).offset(-44);
    }];
}


// MARK: - action

/// 输入密码后，添加新设备，进入配网
- (void)addDeviceButtonDidClick:(UIButton *)sender {
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:YES];
    [self beforeSendWifiInfoAction];

    self.password = self.passwordTextField.text;
    
    [self blController];
    
    [self timingSearchWifiList];
}

- (void)beforeSendWifiInfoAction {
    // 隐藏添加设备相关控件
    self.tipLabel.hidden = YES;
    self.accountContainerView.hidden = YES;
    self.addDeviceButton.hidden = YES;
    // 显示正在联网相关控件
    self.connectingImageView.hidden = NO;
    self.connectingLabel.hidden = NO;
}

- (void)timingSearchWifiList {
    
    WEAKSELF(ws);
    // 每2秒执行一次操作，超时时间是20秒
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:countDownTimerKey
                                                           timeInterval:2
                                                                  queue:nil
                                                                repeats:YES
                                                           actionOption:AbandonPreviousAction
                                                                 action:^{
                                                                     // 寻找目标wifi，并设置超时时间
                                                                     ws.totalSecond += 2;
                                                                     [ws findAPWifiListLock];
        
                                                                     if (ws.isFindTargetWifi == YES || ws.totalSecond == 20) {
                                                                         [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:countDownTimerKey];
                                                                         [ws searchDevice];
                                                                         return;
                                                                     }
    }];
    
}

- (void)searchDevice {
    WEAKSELF(ws);
    if (ws.isFindTargetWifi == NO) {
        ws.ssidType = 4;
    }
    // 根据ssid和密码，使用古北SDK方法链接wifi，超时时间为60s
    BLBaseResult *result = [ws.blController deviceAPConfig:ws.domesticSsid password:ws.password type:ws.ssidType timeout:60];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"ssidType: %zd", ws.ssidType);
        
        if ([result succeed]) {
            // 设备配网成功，app在局域网内发现设备
            [ws sendWifiInfoFindDevice];
        } else {
            [ws bindDeviceFail];
        }
    });
}

- (void)groupSync:(NSString *)password
{
    WEAKSELF(ws);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ws findAPWifiListLock];
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ws findAPWifiListLock];
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ws findAPWifiListLock];
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ws findAPWifiListLock];
        dispatch_group_leave(group);
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        
        if (ws.isFindTargetWifi == NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ZSVProgressHUD showErrorWithStatus:@"Don't find the target wifi." duration:1];
                [ws bindDeviceFail];
            });
            return ;
            //ws.ssidType = 4;
        }
        
        BLBaseResult *result = [ws.blController deviceAPConfig:ws.domesticSsid password:password type:ws.ssidType timeout:60];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"ssidType: %zd", ws.ssidType);
            [ZSVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"AP search device result: %@, ssidType: %zd.", ([result succeed] ? @"YES" : @"NO"), ws.ssidType] duration:1];
            
            if ([result succeed]) {
                [ws sendWifiInfoFindDevice];
            } else {
                [ZSVProgressHUD showErrorWithStatus:@"Find device fail." duration:1];
                [ws bindDeviceFail];
            }
        });
        
    });
}


- (BOOL)findAPWifiList {
    BLGetAPListResult *APListResult = [self.blController deviceAPList:7000];
    NSLog(@"APListResult status: %zd, msg: %@", APListResult.error, APListResult.msg);
    for (BLAPInfo *apInfo in APListResult.list) {
        if ([apInfo.ssid isEqualToString:self.domesticSsid]) {
            self.ssidType = apInfo.type;
            return YES;
        }
    }
    
    self.findWifiCount -= 1;
    if (self.findWifiCount == 0) {
        return NO;
    } else {
        return [self findAPWifiList];
    }
}

- (void)findAPWifiListLock {
    WEAKSELF(ws);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // get ap list with timeout
    BLGetAPListResult *APListResult = [self.blController deviceAPList:7000];
    if ([APListResult succeed]) {
        NSLog(@"APListResult status: %zd, msg: %@ isFindTargetWifi: %@", APListResult.error, APListResult.msg, @(ws.isFindTargetWifi));
        for (BLAPInfo *apInfo in APListResult.list) {
            if ([apInfo.ssid isEqualToString:self.domesticSsid]) {
                ws.ssidType = apInfo.type;
                ws.isFindTargetWifi = YES;
                break;
            }
        }
    }
    dispatch_semaphore_signal(semaphore);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)sendWifiInfoFindDevice {
    
    NSLog(@"SendWifiInfo start");
    
     WEAKSELF(ws);
    [ws.wifiManager sendWifiInfo:ws.domesticSsid
                        password:ws.passwordTextField.text
                         timeout:80.0
                        callback:^(NSArray *localDevices, NSError *error) {
                            [ws.wifiManager stopWifiLink];
        
                            NSLog(@"SendWifiInfo error: %@, ssid: %@, password: %@", error, ws.domesticSsid, ws.passwordTextField.text);
        
                            if (error == nil) {
                                if (localDevices.count != 0) {
                                    //设备配网成功后，2s延时，确定解绑指令执行后（设备进入配网模式包含两个指令：解绑指令和进入配网模式指令，解绑指令可能没有发出，当下一次配网后，立即触发解绑操作），再进行局域网发现设备，绑定设备
                                    dispatch_after(2.0f, dispatch_get_main_queue(), ^{
                                        // 发现设备成功，app在局域网内发现设备
                                        [ws bindLocalDevice:localDevices[0]];
                                    });
                                } else {
                                    [ws bindDeviceFail];
                                }
                            } else {
                                [ws bindDeviceFail];
                            }
                        }];
}

- (void)bindLocalDevice:(ACLocalDevice *)localDevice {
    
    WEAKSELF(ws);
    // 根据subDomainId获取SubDomain
    [ACBindManager bindDeviceWithSubDomain:GetSubDomainWithSubDomainId(localDevice.subDomainId)
                          physicalDeviceId:localDevice.deviceId
                                      name:ws.dataSourceDic[@"productModel"]
                                  callback:^(ACUserDevice *userDevice, NSError *error) {
        
                                      NSLog(@"BindDevice error: %@ subDomain: %@, physicalDeviceId: %@", error, GetSubDomainWithSubDomainId(localDevice.subDomainId), localDevice.deviceId);
        
                                      if (error == nil) {
                                          [ws bindDeviceSuccess:userDevice];
                                      } else {
                                          [ws bindDeviceFail];
                                      }
                                  }];
}

/// 绑定成功

- (void)bindDeviceSuccess:(ACUserDevice *)device {
    
    self.connectingImageView.image = GETIMG(@"img_p11");
    self.connectingLabel.text = GetLocalResStr(@"aplink_p11");
    self.nextButton.hidden = NO;
    self.device = device;
}

/// 发现设备失败 绑定设备失败

- (void)bindDeviceFail {
    ACConnectionFailureController *failController = [[ACConnectionFailureController alloc] init];
    [self.navigationController pushViewController:failController animated:YES];
}

/// 显示密码
- (void)eyeButtonDidClick:(UIButton *)sender {
    
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    
    if (self.passwordTextField.secureTextEntry == NO) {
        [_eyeButton setImage:GETIMG(@"ico_eye_open") forState:UIControlStateNormal];
    } else {
        [_eyeButton setImage:GETIMG(@"ico_eye_close") forState:UIControlStateNormal];
    }
}

/// 下一步
- (void)nextButtonDidClick:(UIButton *)sender {
    
    ACNameDeviceController *nameDeviceController = [[ACNameDeviceController alloc] init];
    nameDeviceController.pageIdx = 5;
    nameDeviceController.dataSourceDic = self.dataSourceDic;
    nameDeviceController.domesticSsid = self.domesticSsid;
    nameDeviceController.device = self.device;
    [self.navigationController pushViewController:nameDeviceController animated:YES];
}

// MARK: - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
