//
//  ACAPAddDeviceTurnOnController
//  supor
//
//  Created by Jun Zhou on 2017/11/15.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "ACAPAddDeviceTurnOnController.h"
#import "ACPageControlView.h"
#import "UIBarButtonItem+Extension.h"
#import "UINavigationBar+FlatUI.h"
#import "ACAddDeviceActiveController.h"
#import "UAlertView.h"

static CGFloat ButtonHeight = 0;

@interface ACAPAddDeviceTurnOnController () <UAlertViewDelegate>

@property (strong, nonatomic) UIView *safeAreaView;

@property (strong, nonatomic) ACPageControlView *pageControlView;

@property (strong, nonatomic) UIImageView *guideImageView;

@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) UIButton *nextButton;

@property (assign, nonatomic) BOOL isConnectWifi;

@end

@implementation ACAPAddDeviceTurnOnController

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
        _guideImageView.image = GETIMG(@"img_p4");
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
        _tipLabel.text = [NSString stringWithFormat:@"%@ %@",GetLocalResStr(@"aplink_p4"), GetLocalResStr(@"aplink_p2")];
    }
    return _tipLabel;
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

// MARK: - view lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self setupSubViews];
    [self checkWifiConnect];
}

// MARK: - config UI

- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = GetLocalResStr(@"turn_on");
    self.automaticallyAdjustsScrollViewInsets = NO;
    ButtonHeight = kMainScreenWidth > 375 ? 55 : 45;
}

// MARK: - setup subview

- (void)setupSubViews {
    [self.view addSubview:self.safeAreaView];
    [self.safeAreaView addSubview:self.pageControlView];
    [self.safeAreaView addSubview:self.guideImageView];
    [self.safeAreaView addSubview:self.tipLabel];
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
    
    [ws.guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.pageControlView.mas_bottom);
        make.left.equalTo(ws.safeAreaView).offset(45);
        make.right.equalTo(ws.safeAreaView).offset(-45);
        make.height.equalTo(ws.guideImageView.mas_width);
    }];
    
    [ws.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.guideImageView.mas_bottom);
        make.left.equalTo(ws.safeAreaView).offset(30);
        make.right.equalTo(ws.safeAreaView).offset(-30);
    }];
    
    [ws.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RATIO(90));
        make.right.mas_equalTo(-RATIO(90));
        make.height.mas_equalTo(ButtonHeight);
        make.bottom.equalTo(ws.safeAreaView).offset(-44);
    }];
}

- (void)checkWifiConnect {
    
    WEAKSELF(ws);
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr startMonitoring];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"AFNetworkReachabilityStatusUnknown");
                ws.isConnectWifi = NO;
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"AFNetworkReachabilityStatusNotReachable");
                ws.isConnectWifi = NO;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"AFNetworkReachabilityStatusReachableViaWWAN");
                ws.isConnectWifi = NO;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"AFNetworkReachabilityStatusReachableViaWiFi");
                ws.isConnectWifi = YES;
                break;
        }
    }];
    self.isConnectWifi = mgr.isReachableViaWiFi;
}

// MARK: - UAlertViewDelegate

- (void)alertView:(UAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString * urlString = @"App-Prefs:root=WIFI";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    }
}

// MARK: - action
- (void)nextButtonDidClick:(UIButton *)sender {
    
    if (self.isConnectWifi == NO) {
        NSString *title = nil;
        NSString *msg = GetLocalResStr(@"need_connect_wifi");
        UAlertView * alert = [[UAlertView alloc] initWithTitle:title
                                                           msg:msg
                                                   cancelTitle:GetLocalResStr(@"know")
                                                       okTitle:nil];
        [alert setOKButtonColor:nil andCancelButtonColor:[UIColor classics_blue]];
        alert.delegate = self;
        [alert show];
        return;
    }
    // get system SSID
    ACAddDeviceActiveController *activeController = [[ACAddDeviceActiveController alloc] init];
    activeController.pageIdx = 2;
    activeController.dataSourceDic = self.dataSourceDic;
    activeController.domesticSsid = [ACWifiLinkManager getCurrentSSID];
    [self.navigationController pushViewController:activeController animated:YES];
    
}

@end
