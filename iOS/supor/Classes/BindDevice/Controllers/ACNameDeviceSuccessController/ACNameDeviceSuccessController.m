//
//  ACNameDeviceSuccessController.m
//  supor
//
//  Created by Jun Zhou on 2017/11/23.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "ACNameDeviceSuccessController.h"

#import "UIBarButtonItem+Extension.h"
#import "UINavigationBar+FlatUI.h"


static CGFloat ButtonHeight = 0;

@interface ACNameDeviceSuccessController ()

@property (strong, nonatomic) UIView *safeAreaView;

@property (strong, nonatomic) UIImageView *guideImageView;

@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) UIButton *okButton;

@end

@implementation ACNameDeviceSuccessController

// MARK: - getter

- (UIView *)safeAreaView {
    if (_safeAreaView == nil) {
        _safeAreaView = [[UIView alloc] init];
    }
    return _safeAreaView;
}

- (UIImageView *)guideImageView {
    if (_guideImageView == nil) {
        _guideImageView = [[UIImageView alloc] init];
        _guideImageView.image = GETIMG(@"img_p13");
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
        _tipLabel.text = GetLocalResStr(@"aplink_p13_desc");
    }
    return _tipLabel;
}

- (UIButton *)okButton {
    if (_okButton == nil) {
        _okButton = [[UIButton alloc] init];
        UIImage * image = [UIImage imageWithColor:[UIColor classics_blue] cornerRadius:ButtonHeight / 2];
        [_okButton setBackgroundImage:image forState:UIControlStateNormal];
        [_okButton setTitle:GetLocalResStr(@"airpurifier_public_ok") forState:UIControlStateNormal];
        _okButton.titleLabel.font = [UIFont fontWithName:Regular size:18];
        [_okButton addTarget:self action:@selector(okButtonDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _okButton;
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
    self.navigationItem.title = GetLocalResStr(@"fragment_p13_title");
    self.automaticallyAdjustsScrollViewInsets = NO;
    ButtonHeight = kMainScreenWidth > 375 ? 55 : 45;
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:YES];
}

// MARK: - setup subview

- (void)setupSubViews {
    [self.view addSubview:self.safeAreaView];
    [self.safeAreaView addSubview:self.guideImageView];
    [self.safeAreaView addSubview:self.tipLabel];
    [self.safeAreaView addSubview:self.okButton];
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
        make.top.equalTo(ws.safeAreaView).offset(60);
        make.left.equalTo(ws.safeAreaView).offset(90);
        make.right.equalTo(ws.safeAreaView).offset(-90);
        make.height.equalTo(ws.guideImageView.mas_width);
    }];
    
    [ws.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.guideImageView.mas_bottom).offset(30);
        make.left.equalTo(ws.safeAreaView).offset(30);
        make.right.equalTo(ws.safeAreaView).offset(-30);
    }];
    
    [ws.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RATIO(90));
        make.right.mas_equalTo(-RATIO(90));
        make.height.mas_equalTo(ButtonHeight);
        make.bottom.equalTo(ws.safeAreaView).offset(-44);
    }];
}

// MARK: - action 

- (void)okButtonDidClick:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
