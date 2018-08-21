//
//  ACAddDeviceActiveController.m
//  supor
//
//  Created by Jun Zhou on 2017/11/16.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "ACAddDeviceActiveController.h"
#import "ACPageControlView.h"
#import "UIBarButtonItem+Extension.h"
#import "UINavigationBar+FlatUI.h"
#import "ACAddDeviceConnectController.h"

static CGFloat ButtonHeight = 0;

@interface ACAddDeviceActiveController ()

@property (strong, nonatomic) UIView *safeAreaView;

@property (strong, nonatomic) ACPageControlView *pageControlView;

@property (strong, nonatomic) UIImageView *guideImageView;

@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) UIButton *nextButton;

@end

@implementation ACAddDeviceActiveController

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
        _guideImageView.image = GETIMG(@"img_p5");
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
        _tipLabel.text = GetLocalResStr(@"aplink_p5");
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
}

// MARK: - config UI

- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = GetLocalResStr(@"active_wifi");
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
        make.left.equalTo(ws.safeAreaView).offset(60);
        make.right.equalTo(ws.safeAreaView).offset(-60);
        make.height.equalTo(ws.guideImageView.mas_width);
    }];
    
    [ws.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.guideImageView.mas_bottom).offset(10);
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

- (void)nextButtonDidClick:(UIButton *)sender {
    
    ACAddDeviceConnectController *connectController = [[ACAddDeviceConnectController alloc] init];
    connectController.pageIdx = 3;
    connectController.dataSourceDic = self.dataSourceDic;
    connectController.domesticSsid = self.domesticSsid;
    [self.navigationController pushViewController:connectController animated:YES];
    
}

@end
