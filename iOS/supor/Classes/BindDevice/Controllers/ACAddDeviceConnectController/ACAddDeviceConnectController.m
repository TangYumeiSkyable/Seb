//
//  ACAddDeviceConnectController.m
//  supor
//
//  Created by Jun Zhou on 2017/11/16.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "ACAddDeviceConnectController.h"
#import "ACPageControlView.h"
#import "UIBarButtonItem+Extension.h"
#import "UINavigationBar+FlatUI.h"

#import "ACAddDeviceConnectDomesticController.h"
#import "JX_GCDTimerManager.h"
#import "ACAddDeviceController.h"

static CGFloat ButtonHeight = 0;

static NSString * const CheckWifiConnectTimer = @"checkWifiConnect";

@interface ACAddDeviceConnectController ()

@property (strong, nonatomic) UIView *safeAreaView;

@property (strong, nonatomic) ACPageControlView *pageControlView;

@property (strong, nonatomic) UIImageView *guideImageView;

@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) UIButton *wifiSettingButton;

@property (strong, nonatomic) UIImageView *connectImageView;

@property (strong, nonatomic) UIButton *nextButton;

@property (strong, nonatomic) UILabel *connectTipLabel;

@property (strong, nonatomic) UIButton *retryButton;

@property (copy, nonatomic) NSString *ssid;

@property (assign, nonatomic) BOOL isConnectHotSpot;

@end

@implementation ACAddDeviceConnectController

// MARK: - getter

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

- (UIImageView *)guideImageView {
    if (_guideImageView == nil) {
        _guideImageView = [[UIImageView alloc] init];
        _guideImageView.image = GETIMG(@"img_p6");
    }
    return _guideImageView;
}

- (UILabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:16];
        _tipLabel.textColor = [UIColor blackColor];
        _tipLabel.numberOfLines = 0;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = GetLocalResStr(@"aplink_p6");
    }
    return _tipLabel;
}

- (UIButton *)wifiSettingButton {
    if (_wifiSettingButton == nil) {
        _wifiSettingButton = [[UIButton alloc] init];
        UIImage *image = [UIImage imageWithColor:[UIColor classics_blue] cornerRadius:ButtonHeight / 2];
        [_wifiSettingButton setBackgroundImage:image forState:UIControlStateNormal];
        [_wifiSettingButton setTitle:GetLocalResStr(@"aplink_p6_bt_text") forState:UIControlStateNormal];
        _wifiSettingButton.titleLabel.font = [UIFont fontWithName:Regular size:18];
        [_wifiSettingButton addTarget:self action:@selector(wifiSettingButtonDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _wifiSettingButton;
}


- (UIImageView *)connectImageView {
    if (_connectImageView == nil) {
        _connectImageView = [[UIImageView alloc] init];
        _connectImageView.image = GETIMG(@"img_p7");
    }
    return _connectImageView;
}

- (UIButton *)nextButton {
    if (_nextButton == nil) {
        _nextButton = [[UIButton alloc] init];
        UIImage * image = [UIImage imageWithColor:[UIColor classics_blue] cornerRadius:ButtonHeight / 2];
        [_nextButton setBackgroundImage:image forState:UIControlStateNormal];
        [_nextButton setTitle:GetLocalResStr(@"next") forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont fontWithName:Regular size:18];
        [_nextButton addTarget:self action:@selector(nextButtonDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nextButton;
}

- (UILabel *)connectTipLabel {
    if (_connectTipLabel == nil) {
        _connectTipLabel = [[UILabel alloc] init];
        _connectTipLabel.font = [UIFont systemFontOfSize:16];
        _connectTipLabel.textColor = [UIColor blackColor];
        _connectTipLabel.numberOfLines = 0;
        _connectTipLabel.textAlignment = NSTextAlignmentCenter;
        _connectTipLabel.text = GetLocalResStr(@"connect");
    }
    return _connectTipLabel;
}

- (UIButton *)retryButton {
    if (_retryButton == nil) {
        _retryButton = [[UIButton alloc] init];
        UIImage * image = [UIImage imageWithColor:[UIColor classics_blue] cornerRadius:ButtonHeight / 2];
        [_retryButton setBackgroundImage:image forState:UIControlStateNormal];
        [_retryButton setTitle:GetLocalResStr(@"airpurifier_connect_fail_retry") forState:UIControlStateNormal];
        _retryButton.titleLabel.font = [UIFont fontWithName:Regular size:18];
        [_retryButton addTarget:self action:@selector(retryButtonDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _retryButton;
}


// MARK: - view lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self setupSubViews];
    [self addNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:CheckWifiConnectTimer];
}

// MARK: - config UI

- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = GetLocalResStr(@"fragment_p6_title");
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ButtonHeight = kMainScreenWidth > 375 ? 55 : 45;
}

// MARK: - setup subview

- (void)setupSubViews {
    [self.view addSubview:self.safeAreaView];
    [self.safeAreaView addSubview:self.pageControlView];
    [self.safeAreaView addSubview:self.guideImageView];
    [self.safeAreaView addSubview:self.tipLabel];
    [self.safeAreaView addSubview:self.wifiSettingButton];
    
    [self.safeAreaView addSubview:self.connectImageView];
    [self.safeAreaView addSubview:self.connectTipLabel];
    [self.safeAreaView addSubview:self.nextButton];
    [self.safeAreaView addSubview:self.retryButton];
    
    self.connectImageView.hidden = YES;
    self.connectTipLabel.hidden = YES;
    self.nextButton.hidden = YES;
    self.retryButton.hidden = YES;
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
    
    [ws.guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.pageControlView.mas_bottom);
        make.left.equalTo(ws.safeAreaView).offset(60);
        make.right.equalTo(ws.safeAreaView).offset(-60);
        make.height.equalTo(ws.guideImageView.mas_width);
    }];
    
    [ws.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.guideImageView.mas_bottom);
        make.left.equalTo(ws.safeAreaView).offset(15);
        make.right.equalTo(ws.safeAreaView).offset(-15);
    }];
    
    [ws.wifiSettingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RATIO(90));
        make.right.mas_equalTo(-RATIO(90));
        make.height.mas_equalTo(ButtonHeight);
        make.bottom.equalTo(ws.safeAreaView).offset(-44);
    }];
    

    [ws.connectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.pageControlView.mas_bottom);
        make.left.equalTo(ws.safeAreaView).offset(60);
        make.right.equalTo(ws.safeAreaView).offset(-60);
        make.height.equalTo(ws.connectImageView.mas_width);
    }];
    
    [ws.connectTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.connectImageView.mas_bottom);
        make.left.equalTo(ws.safeAreaView).offset(15);
        make.right.equalTo(ws.safeAreaView).offset(-15);
    }];
    
    [ws.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RATIO(90));
        make.right.mas_equalTo(-RATIO(90));
        make.height.mas_equalTo(ButtonHeight);
        make.bottom.equalTo(ws.safeAreaView).offset(-44);
        
    }];
    
    [ws.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RATIO(90));
        make.right.mas_equalTo(-RATIO(90));
        make.height.mas_equalTo(ButtonHeight);
        make.bottom.equalTo(ws.safeAreaView).offset(-44);
    }];
}

// MARK: - action

/// 跳转到设置中连接设备AP热点
- (void)wifiSettingButtonDidClick:(UIButton *)sender {
    
    self.guideImageView.hidden = YES;
    self.tipLabel.hidden = YES;
    self.wifiSettingButton.hidden = YES;
    
    self.connectImageView.hidden = NO;
    self.connectTipLabel.hidden = NO;
    
    NSString * urlString = @"App-Prefs:root=WIFI";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    }
}

// 跳转到wifi密码输入页面
- (void)nextButtonDidClick:(UIButton *)sender {
    
    ACAddDeviceConnectDomesticController *domesticController = [[ACAddDeviceConnectDomesticController alloc] init];
    domesticController.pageIdx = 4;
    domesticController.dataSourceDic = self.dataSourceDic;
    domesticController.domesticSsid = self.domesticSsid;
    [self.navigationController pushViewController:domesticController animated:YES];
}

// 点击retry button,返回到设备类型选择页面
- (void)retryButtonDidClick:(UIButton *)sender {
    for (UIViewController *controller in self.navigationController.childViewControllers) {
        NSString *classStr = NSStringFromClass([controller class]);
        if ([classStr isEqualToString:@"ACSelectProductController"]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
}

// 添加App从后台转到前台的通知
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

// 通知执行方法：检查是否连接到AP热点
- (void)applicationBecomeActive:(NSNotification *)notification {
    [self checkWifiConnect];
}

- (void)checkWifiConnect {
    
    NSString *ssid = [ACWifiLinkManager getCurrentSSID];
    if ([ssid hasPrefix:@"AIR PURIFIER"]) {
        if (self.isConnectHotSpot == YES) return;
        
        self.isConnectHotSpot = YES;
        self.nextButton.hidden = NO;
        self.retryButton.hidden = YES;
        self.connectImageView.image = GETIMG(@"img_p8");
        self.connectTipLabel.text = GetLocalResStr(@"aplink_p8");
        
    } else {
        self.isConnectHotSpot = NO;
        // 如果没有连接到正确的AP热点，开启定时器，在指定时间后刷新UI，让用户重试
        WEAKSELF(ws);
        [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:CheckWifiConnectTimer
                                                               timeInterval:15.0
                                                                      queue:nil
                                                                    repeats:NO
                                                               actionOption:AbandonPreviousAction
                                                                     action:^{
            
                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                             ws.nextButton.hidden = YES;
                                                                             ws.retryButton.hidden = NO;
                                                                             ws.connectImageView.image = GETIMG(@"img_p15");
                                                                             ws.connectTipLabel.text = GetLocalResStr(@"aplink_p15_desc");
                                                                             [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:CheckWifiConnectTimer];
                                                                         });
        }];
    }
}

@end
