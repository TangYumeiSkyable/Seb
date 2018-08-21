//
//  ACNameDeviceController.m
//  supor
//
//  Created by Jun Zhou on 2017/11/23.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "ACNameDeviceController.h"

#import "ACPageControlView.h"
#import "UIBarButtonItem+Extension.h"
#import "UINavigationBar+FlatUI.h"

#import "ACNameDeviceSuccessController.h"

static CGFloat ButtonHeight = 0;

@interface ACNameDeviceController () <UITextFieldDelegate>

@property (strong, nonatomic) UIView *safeAreaView;

@property (strong, nonatomic) ACPageControlView *pageControlView;

@property (strong, nonatomic) UIImageView *guideImageView;

@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) UIButton *confirmButton;

@property (strong, nonatomic) UIView *deviceInfoContainerView;
@property (strong, nonatomic) UIView *topLineView;
@property (strong, nonatomic) UIView *centerLineView;
@property (strong, nonatomic) UIView *bottomLineView;

@property (strong, nonatomic) UIView *macContainerView;
@property (strong, nonatomic) UILabel *macTitleLabel;
@property (strong, nonatomic) UILabel *macLabel;

@property (strong, nonatomic) UIView *nameContanerView;
@property (strong, nonatomic) UILabel *nameTitleLabel;
@property (strong, nonatomic) UITextField *nameTextField;

@end

@implementation ACNameDeviceController

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
        _guideImageView.image = GETIMG(@"img_p1");
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
        _tipLabel.text = GetLocalResStr(@"aplink_p12");
    }
    return _tipLabel;
}

- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        _confirmButton = [[UIButton alloc] init];
        UIImage * image = [UIImage imageWithColor:[UIColor classics_blue] cornerRadius:ButtonHeight / 2];
        [_confirmButton setBackgroundImage:image forState:UIControlStateNormal];
        [_confirmButton setTitle:GetLocalResStr(@"airpurifier_public_confirm") forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:Regular size:18];
        [_confirmButton addTarget:self action:@selector(confirmButtonDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _confirmButton;
}

- (UIView *)deviceInfoContainerView {
    if (_deviceInfoContainerView == nil) {
        _deviceInfoContainerView = [[UIView alloc] init];
    }
    return _deviceInfoContainerView;
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

- (UIView *)macContainerView {
    if (_macContainerView == nil) {
        _macContainerView = [[UIView alloc] init];
    }
    return _macContainerView;
}

- (UILabel *)macTitleLabel {
    if (_macTitleLabel == nil) {
        _macTitleLabel = [[UILabel alloc] init];
        _macTitleLabel.font = [UIFont systemFontOfSize:16];
        _macTitleLabel.textColor = [UIColor blackColor];
        _macTitleLabel.numberOfLines = 1;
        _macTitleLabel.textAlignment = NSTextAlignmentCenter;
        _macTitleLabel.text = GetLocalResStr(@"airpurifier_moredevice_show_macaddress_text");
    }
    return _macTitleLabel;
}

- (UILabel *)macLabel {
    if (_macLabel == nil) {
        _macLabel = [[UILabel alloc] init];
        _macLabel.font = [UIFont systemFontOfSize:16];
        _macLabel.textColor = [UIColor grayColor];
        _macLabel.numberOfLines = 1;
        _macLabel.textAlignment = NSTextAlignmentLeft;
        _macLabel.text = self.device.physicalDeviceId;
    }
    return _macLabel;
}

- (UIView *)nameContanerView {
    if (_nameContanerView == nil) {
        _nameContanerView = [[UIView alloc] init];
    }
    return _nameContanerView;
}

- (UILabel *)nameTitleLabel {
    if (_nameTitleLabel == nil) {
        _nameTitleLabel = [[UILabel alloc] init];
        _nameTitleLabel.font = [UIFont systemFontOfSize:16];
        _nameTitleLabel.textColor = [UIColor blackColor];
        _nameTitleLabel.numberOfLines = 1;
        _nameTitleLabel.textAlignment = NSTextAlignmentCenter;
        _nameTitleLabel.text = GetLocalResStr(@"airpurifier_more_show_modifydevicename_title");
    }
    return _nameTitleLabel;
}

- (UITextField *)nameTextField {
    if (_nameTextField == nil) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.placeholder = GetProductNameWithSubDomainId(self.device.subDomainId);
        _nameTextField.delegate = self;
    }
    return _nameTextField;
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
    self.navigationItem.title = GetLocalResStr(@"fragment_p12_title");
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ButtonHeight = kMainScreenWidth > 375 ? 55 : 45;
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:YES];
    
}

// MARK: - setup subview

- (void)setupSubViews {
    [self.view addSubview:self.safeAreaView];
    [self.safeAreaView addSubview:self.pageControlView];
    [self.safeAreaView addSubview:self.guideImageView];
    [self.safeAreaView addSubview:self.tipLabel];
    [self.safeAreaView addSubview:self.deviceInfoContainerView];
    [self.safeAreaView addSubview:self.confirmButton];

    [self.deviceInfoContainerView addSubview:self.topLineView];
    [self.deviceInfoContainerView addSubview:self.centerLineView];
    [self.deviceInfoContainerView addSubview:self.bottomLineView];
    
    [self.deviceInfoContainerView addSubview:self.macContainerView];
    [self.deviceInfoContainerView addSubview:self.nameContanerView];
    
    [self.macContainerView addSubview:self.macTitleLabel];
    [self.macContainerView addSubview:self.macLabel];
    
    [self.nameContanerView addSubview:self.nameTitleLabel];
    [self.nameContanerView addSubview:self.nameTextField];
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
        make.left.equalTo(ws.safeAreaView).offset(95);
        make.right.equalTo(ws.safeAreaView).offset(-95);
        make.height.equalTo(ws.guideImageView.mas_width);
    }];
    
    [ws.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.guideImageView.mas_bottom).offset(10);
        make.left.equalTo(ws.safeAreaView).offset(15);
        make.right.equalTo(ws.safeAreaView).offset(-15);
    }];
    
    [ws.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RATIO(90));
        make.right.mas_equalTo(-RATIO(90));
        make.height.mas_equalTo(ButtonHeight);
        make.bottom.equalTo(ws.safeAreaView).offset(-44);
    }];
    
    [ws.deviceInfoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.safeAreaView);
        make.right.equalTo(ws.safeAreaView);
        make.bottom.equalTo(ws.confirmButton.mas_top).offset(-30);
        make.height.mas_equalTo(120);
    }];
    
    [ws.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.deviceInfoContainerView);
        make.left.equalTo(ws.deviceInfoContainerView);
        make.right.equalTo(ws.deviceInfoContainerView);
        make.height.mas_equalTo(1);
    }];
    
    [ws.centerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.deviceInfoContainerView).offset(60);
        make.left.equalTo(ws.deviceInfoContainerView);
        make.right.equalTo(ws.deviceInfoContainerView);
        make.height.mas_equalTo(1);
    }];
    
    [ws.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.deviceInfoContainerView);
        make.left.equalTo(ws.deviceInfoContainerView);
        make.right.equalTo(ws.deviceInfoContainerView);
        make.height.mas_equalTo(1);
    }];
    
    
    [ws.macContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.deviceInfoContainerView);
        make.left.equalTo(ws.deviceInfoContainerView);
        make.right.equalTo(ws.deviceInfoContainerView);
        make.height.equalTo(ws.deviceInfoContainerView.mas_height).multipliedBy(0.5);
    }];
    
    [ws.macTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.centerY.equalTo(ws.macContainerView);
    }];
    
    [ws.macLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.macContainerView);
        make.left.mas_equalTo(DeviceUtils.screenWidth * 0.5);
    }];
    
    
    
    [ws.nameContanerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.deviceInfoContainerView);
        make.left.equalTo(ws.deviceInfoContainerView);
        make.right.equalTo(ws.deviceInfoContainerView);
        make.height.equalTo(ws.deviceInfoContainerView.mas_height).multipliedBy(0.5);
    }];
    
    
    [ws.nameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.centerY.equalTo(ws.nameContanerView);
    }];
    
    [ws.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(DeviceUtils.screenWidth * 0.5);
        make.top.bottom.equalTo(ws.nameContanerView);
        make.right.equalTo(ws.nameContanerView).offset(-15);
    }];
}



// MARK: - action

- (void)confirmButtonDidClick:(UIButton *)sender {
    // 没有填写设备名称，那就根据设备subdomainID获取默认名称
    NSString *name = self.nameTextField.text.length > 0 ? self.nameTextField.text : GetProductNameWithSubDomainId(self.device.subDomainId);
    
    WEAKSELF(ws);
    [ACBindManager changNameWithSubDomain:GetSubDomainWithSubDomainId(ws.device.subDomainId)
                                 deviceId:ws.device.deviceId
                                     name:name
                                 callback:^(NSError *error) {
                                     NSLog(@"ChangName subDomain: %@, deviceId: %zd, name: %@", GetSubDomainWithSubDomainId(ws.device.subDomainId), ws.device.deviceId, name);
                                     if (error == nil) {
                                         [ws changeDeviceNameSuccess];
                                     } else {
                                         // 返回错误也会跳转到下一界面
                                         [ws changeDeviceNameFail];
                                         [ws changeDeviceNameSuccess];
                                     }
                                 }];
}

- (void)changeDeviceNameSuccess {
    
    ACNameDeviceSuccessController *successController = [[ACNameDeviceSuccessController alloc] init];
    successController.pageIdx = 6;
    successController.dataSourceDic = self.dataSourceDic;
    successController.domesticSsid = self.domesticSsid;
    successController.device = self.device;
    [self.navigationController pushViewController:successController animated:YES];
}


- (void)changeDeviceNameFail {
    [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"fail") duration:0.5];
}


// MARK: - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
