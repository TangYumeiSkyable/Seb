//
//  NoDeviceViewController.m
//  supor
//
//  Created by 赵冰冰 on 2017/5/8.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "NoDeviceViewController.h"
#import "RHHomeViewController.h"
#import "MoreViewController.h"
#import "RHBaseNavgationController.h"
#import "AppDelegate.h"
#import "RHAccountTool.h"
#import "UIImage+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "UIView+WhenTappedBlocks.h"
#import "JNavigationView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "OutDoorViewController.h"
#import "SelectCountryViewController.h"
#import "ACSelectProductController.h"
#import "LoginViewController.h"

@interface NoDeviceViewController () <JNavigationDelegate>

@property (nonatomic, assign) CGFloat addDeviceButtonHeight;

@property (nonatomic, strong) JNavigationView *customNavigationView;

@property (nonatomic, strong) UIButton *settingButton;

@property (nonatomic, strong) UIImageView *deviceImageView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *addDeviceButton;

@end

@implementation NoDeviceViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}

#pragma mark - Common Methods
- (void)initViews {
    [self.view addSubview:self.customNavigationView];
    [self.view addSubview:self.settingButton];
    [self.view addSubview:self.deviceImageView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.addDeviceButton];
}

- (void)configUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _addDeviceButtonHeight = kMainScreenWidth > 375 ? 55 : 45;
    
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationItem.title = GetLocalResStr(@"airpurifier_moredevice_show_adddevice_text");
}

- (void)initData {
    [ACBindManager listDevicesWithStatusCallback:^(NSArray *devices, NSError *error) {
        if (!error) {
            if (devices.count > 0) {
                AppDelegate *app = [AppDelegate sharedInstance];
                RHHomeViewController *homeVC = [[RHHomeViewController alloc] init];
                [homeVC.devices addObjectsFromArray:devices];
                RHBaseNavgationController *nc = [[RHBaseNavgationController alloc] initWithRootViewController:homeVC];
                app.window.rootViewController = nc;
            }
        } else {
            if (error.code == 3014 || error.code == 3015 || error.code == 3514 || error.code == 3515 || error.code == 3516) {
                RHAccount * acc = [RHAccountTool account];
                [[AppDelegate sharedInstance] removeAlias:[NSString stringWithFormat:@"%ld", (long)acc.user_ID]];
                [RHAccountTool cleanAccount];
                [ACAccountManager logout];
                AppDelegate * app = [AppDelegate sharedInstance];
                RHBaseNavgationController *loginNC = [[RHBaseNavgationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
                app.window.rootViewController = loginNC;
            }
        }
    }];
}

#pragma mark - Lazyload Methods
- (JNavigationView *)customNavigationView {
    if (!_customNavigationView) {
        _customNavigationView = [[JNavigationView alloc] init];
        _customNavigationView.backgroundColor = [UIColor classics_blue];
        _customNavigationView.delegate = self;
    }
    return _customNavigationView;
}

- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        BTN_ADDTARGET(_settingButton, @selector(pushToMoreContainerViewController));
        [_settingButton setImage:[[UIImage imageNamed:@"ico_setting_blue"] imageWithSize:CGSizeMake(23, 23)] forState:UIControlStateNormal];
    }
    return _settingButton;
}

- (UIImageView *)deviceImageView {
    if (!_deviceImageView) {
        _deviceImageView = [[UIImageView alloc] init];
        _deviceImageView.image = [UIImage imageNamed:@"img_p1"];
    }
    return _deviceImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = GetLocalResStr(@"aplink_p1");
        _tipLabel.textColor = [UIColor blackColor];
        _tipLabel.font = [UIFont fontWithName:Regular size:18];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UIButton *)addDeviceButton {
    if (!_addDeviceButton) {
        _addDeviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addDeviceButton setBackgroundImage:[UIImage imageWithColor:[UIColor classics_blue] cornerRadius:_addDeviceButtonHeight / 2] forState:UIControlStateNormal];
        [_addDeviceButton setTitle:GetLocalResStr(@"airpurifier_moredevice_show_adddevice_text") forState:UIControlStateNormal];
        _addDeviceButton.titleLabel.font = [UIFont fontWithName:Regular size:18];
        BTN_ADDTARGET(_addDeviceButton, @selector(addDeviceAction));
    }
    return _addDeviceButton;
}
#pragma mark - Target Actions
- (void)addDeviceAction {
    ACSelectProductController *selectProductController = [[ACSelectProductController alloc] init];
    [self.navigationController pushViewController:selectProductController animated:YES];
}

- (void)pushToMoreContainerViewController {
    MoreViewController *moreVC =[[MoreViewController alloc] init];
    [self.navigationController pushViewController:moreVC animated:YES];
}

#pragma mark - JNavigationDelegate
- (void)didSelectAtIndex:(NSInteger)index {
    if (index == 0) {
        SelectCountryViewController *selectVC = [[SelectCountryViewController alloc] init];
        selectVC.popStyle = SelectCityVCPopToRoot;
        [self.navigationController pushViewController:selectVC animated:YES];
    } else {
        OutDoorViewController * outVC = [OutDoorViewController new];
        [self.navigationController pushViewController:outVC animated:YES];
    }
}

#pragma mark - System Methods
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.customNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(DeviceUtils.navigationStatusBarHeight);
    }];
    
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(RATIO(-38));
        make.width.height.mas_equalTo(44);
        make.top.equalTo(self.customNavigationView.mas_bottom).offset(15);
    }];
    
    [self.deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNavigationView.mas_bottom).offset(RATIO(132 + 168));
        make.left.mas_equalTo(80);
        make.right.mas_equalTo(-80);
        make.height.equalTo(self.deviceImageView.mas_width);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.deviceImageView.mas_bottom).offset(30);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    [self.addDeviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RATIO(90));
        make.right.mas_equalTo(RATIO(-90));
        make.bottom.mas_equalTo(-44);
        make.height.mas_equalTo(_addDeviceButtonHeight);
    }];
}

@end
