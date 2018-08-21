//
//  ACAddDeviceController.m
//  supor
//
//  Created by Jun Zhou on 2017/11/14.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "ACAddDeviceController.h"
#import "UIBarButtonItem+Extension.h"
#import "UINavigationBar+FlatUI.h"
#import "UAlertView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#import "ACSelectProductController.h"

static CGFloat ButtonHeight = 0;

@interface ACAddDeviceController ()<UAlertViewDelegate>

@property (strong, nonatomic) UIButton *startButton;

@property (assign, nonatomic) BOOL isConnectWifi;

@property (strong, nonatomic) UIView *safeAreaView;

@property (strong, nonatomic) UIImageView *guideImageView;

@property (strong, nonatomic) UILabel *tipLabel;


@end

@implementation ACAddDeviceController

// MARK: - getter

- (UIButton *)startButton {
    if (_startButton == nil) {
        _startButton = [[UIButton alloc] init];
        UIImage *image = [UIImage imageWithColor:[UIColor classics_blue] cornerRadius:ButtonHeight / 2];
        [_startButton setBackgroundImage:image forState:UIControlStateNormal];
        [_startButton setTitle:GetLocalResStr(@"airpurifier_more_show_start") forState:UIControlStateNormal];
        _startButton.titleLabel.font = [UIFont fontWithName:Regular size:18];
        [_startButton addTarget:self action:@selector(startButtonDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _startButton;
}

- (UIView *)safeAreaView {
    if (_safeAreaView == nil) {
        _safeAreaView = [[UIView alloc] init];
    }
    return _safeAreaView;
}

- (UIImageView *)guideImageView {
    if (_guideImageView == nil) {
        _guideImageView = [[UIImageView alloc] init];
        _guideImageView.image = GETIMG(@"img_p2");
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
        _tipLabel.text = GetLocalResStr(@"aplink_p2");
    }
    return _tipLabel;
}

// MARK: - view lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
    [self setupSubViews];
    [self checkWifiConnect];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

// MARK: - config UI

- (void)configUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = GetLocalResStr(@"add_a_product");
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor classics_blue]];
    
    ButtonHeight = kMainScreenWidth > 375 ? 55 : 45;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
}

// MARK: - setup subviews

- (void)setupSubViews {
    [self.view addSubview:self.safeAreaView];
    [self.safeAreaView addSubview:self.guideImageView];
    [self.safeAreaView addSubview:self.tipLabel];
    [self.safeAreaView addSubview:self.startButton];
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
    
    [ws.guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.safeAreaView);
        make.left.equalTo(ws.safeAreaView).offset(25);
        make.right.equalTo(ws.safeAreaView).offset(-25);
        make.height.equalTo(ws.guideImageView.mas_width);
    }];
    
    [ws.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.guideImageView.mas_bottom);
        make.left.equalTo(ws.safeAreaView).offset(30);
        make.right.equalTo(ws.safeAreaView).offset(-30);
    }];
    
    [ws.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RATIO(90));
        make.right.mas_equalTo(-RATIO(90));
        make.height.mas_equalTo(ButtonHeight);
        make.bottom.equalTo(ws.safeAreaView).offset(-44);
    }];
}

// MARK: - action

- (void)startButtonDidClick:(UIButton *)sender {
    
    if (self.isConnectWifi == NO) {
        NSString *title = nil;
        NSString *msg = GetLocalResStr(@"need_connect_wifi");
        UAlertView *alert = [[UAlertView alloc] initWithTitle:title
                                                          msg:msg
                                                  cancelTitle:GetLocalResStr(@"know")
                                                      okTitle:nil];
        [alert setOKButtonColor:nil andCancelButtonColor:[UIColor classics_blue]];
        alert.delegate = self;
        [alert show];
        return;
    }
    
    ACSelectProductController *selectController = [[ACSelectProductController alloc] init];
    selectController.domesticSsid = [ACWifiLinkManager getCurrentSSID];
    [self.navigationController pushViewController:selectController animated:YES];
}

// MARK: - UAlertViewDelegate

- (void)alertView:(UAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *urlString = @"App-Prefs:root=WIFI";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    }
}
@end
