//
//  ACConnectionFailureController.m
//  supor
//
//  Created by Jun Zhou on 2017/11/23.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "ACConnectionFailureController.h"

#import "UIBarButtonItem+Extension.h"
#import "UINavigationBar+FlatUI.h"
#import "ACAddDeviceConnectDomesticController.h"

static CGFloat ButtonHeight = 0;

@interface ACConnectionFailureController ()

@property (strong, nonatomic) UIView *safeAreaView;

@property (strong, nonatomic) UIButton *retryButton;

@property (strong, nonatomic) UIView *contentContainerView;

@property (strong, nonatomic) UIView *containerViewTip1;
@property (strong, nonatomic) UIImageView *imageViewTip1;
@property (strong, nonatomic) UILabel *contentLabelTip1;


@property (strong, nonatomic) UIView *containerViewTip2;
@property (strong, nonatomic) UIImageView *imageViewTip2;
@property (strong, nonatomic) UILabel *contentLabelTip2;


@property (strong, nonatomic) UIView *containerViewTip3;
@property (strong, nonatomic) UIImageView *imageViewTip3;
@property (strong, nonatomic) UILabel *contentLabelTip3;


@property (strong, nonatomic) UIView *containerViewTip4;
@property (strong, nonatomic) UIImageView *imageViewTip4;
@property (strong, nonatomic) UILabel *contentLabelTip4;


@end

@implementation ACConnectionFailureController

// MARK: - getter

- (UIView *)safeAreaView {
    if (_safeAreaView == nil) {
        _safeAreaView = [[UIView alloc] init];
    }
    return _safeAreaView;
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

- (UIView *)contentContainerView {
    if (_contentContainerView == nil) {
        _contentContainerView = [[UIView alloc] init];
    }
    return _contentContainerView;
}

- (UIView *)containerViewTip1 {
    if (_containerViewTip1 == nil) {
        _containerViewTip1 = [[UIView alloc] init];
    }
    return _containerViewTip1;
}

- (UIImageView *)imageViewTip1 {
    if (_imageViewTip1 == nil) {
        _imageViewTip1 = [[UIImageView alloc] init];
        _imageViewTip1.image = GETIMG(@"img_p14_1");
    }
    return _imageViewTip1;
}

- (UILabel *)contentLabelTip1 {
    if (_contentLabelTip1 == nil) {
        _contentLabelTip1 = [[UILabel alloc] init];
        _contentLabelTip1.font = [UIFont systemFontOfSize:16];
        _contentLabelTip1.textColor = [UIColor blackColor];
        _contentLabelTip1.numberOfLines = 0;
        _contentLabelTip1.textAlignment = NSTextAlignmentLeft;
        _contentLabelTip1.text = GetLocalResStr(@"fragment_p14_one");
    }
    return _contentLabelTip1;
}

- (UIView *)containerViewTip2 {
    if (_containerViewTip2 == nil) {
        _containerViewTip2 = [[UIView alloc] init];
    }
    return _containerViewTip2;
}

- (UIImageView *)imageViewTip2 {
    if (_imageViewTip2 == nil) {
        _imageViewTip2 = [[UIImageView alloc] init];
        _imageViewTip2.image = GETIMG(@"img_p14_2");
    }
    return _imageViewTip2;
}

- (UILabel *)contentLabelTip2 {
    if (_contentLabelTip2 == nil) {
        _contentLabelTip2 = [[UILabel alloc] init];
        _contentLabelTip2.font = [UIFont systemFontOfSize:16];
        _contentLabelTip2.textColor = [UIColor blackColor];
        _contentLabelTip2.numberOfLines = 0;
        _contentLabelTip2.textAlignment = NSTextAlignmentLeft;
        _contentLabelTip2.text = GetLocalResStr(@"fragment_p14_two");
    }
    return _contentLabelTip2;
}

- (UIView *)containerViewTip3 {
    if (_containerViewTip3 == nil) {
        _containerViewTip3 = [[UIView alloc] init];
    }
    return _containerViewTip3;
}

- (UIImageView *)imageViewTip3 {
    if (_imageViewTip3 == nil) {
        _imageViewTip3 = [[UIImageView alloc] init];
        _imageViewTip3.image = GETIMG(@"img_p14_3");
    }
    return _imageViewTip3;
}

- (UILabel *)contentLabelTip3 {
    if (_contentLabelTip3 == nil) {
        _contentLabelTip3 = [[UILabel alloc] init];
        _contentLabelTip3.font = [UIFont systemFontOfSize:16];
        _contentLabelTip3.textColor = [UIColor blackColor];
        _contentLabelTip3.numberOfLines = 0;
        _contentLabelTip3.textAlignment = NSTextAlignmentLeft;
        _contentLabelTip3.text = GetLocalResStr(@"fragment_p14_three");
    }
    return _contentLabelTip3;
}

- (UIView *)containerViewTip4 {
    if (_containerViewTip4 == nil) {
        _containerViewTip4 = [[UIView alloc] init];
    }
    return _containerViewTip4;
}

- (UIImageView *)imageViewTip4 {
    if (_imageViewTip4 == nil) {
        _imageViewTip4 = [[UIImageView alloc] init];
        _imageViewTip4.image = GETIMG(@"img_p14_4");
    }
    return _imageViewTip4;
}

- (UILabel *)contentLabelTip4 {
    if (_contentLabelTip4 == nil) {
        _contentLabelTip4 = [[UILabel alloc] init];
        _contentLabelTip4.font = [UIFont systemFontOfSize:16];
        _contentLabelTip4.textColor = [UIColor blackColor];
        _contentLabelTip4.numberOfLines = 0;
        _contentLabelTip4.textAlignment = NSTextAlignmentLeft;
        _contentLabelTip4.text = GetLocalResStr(@"fragment_p14_four");
    }
    return _contentLabelTip4;
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
    self.navigationItem.title = GetLocalResStr(@"fragment_p15_title");
    self.automaticallyAdjustsScrollViewInsets = NO;
    ButtonHeight = kMainScreenWidth > 375 ? 55 : 45;
}

// MARK: - setup subview

- (void)setupSubViews {
    [self.view addSubview:self.safeAreaView];
    [self.safeAreaView addSubview:self.retryButton];
    [self.safeAreaView addSubview:self.contentContainerView];
    
    [self.contentContainerView addSubview:self.containerViewTip1];
    [self.contentContainerView addSubview:self.containerViewTip2];
    [self.contentContainerView addSubview:self.containerViewTip3];
    [self.contentContainerView addSubview:self.containerViewTip4];
    
    [self.containerViewTip1 addSubview:self.imageViewTip1];
    [self.containerViewTip1 addSubview:self.contentLabelTip1];
    
    [self.containerViewTip2 addSubview:self.imageViewTip2];
    [self.containerViewTip2 addSubview:self.contentLabelTip2];
    
    [self.containerViewTip3 addSubview:self.imageViewTip3];
    [self.containerViewTip3 addSubview:self.contentLabelTip3];
    
    [self.containerViewTip4 addSubview:self.imageViewTip4];
    [self.containerViewTip4 addSubview:self.contentLabelTip4];
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
    
    [ws.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RATIO(90));
        make.right.mas_equalTo(-RATIO(90));
        make.height.mas_equalTo(ButtonHeight);
        make.bottom.equalTo(ws.safeAreaView).offset(-44);
    }];
    
    [ws.contentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.safeAreaView).offset(40);
        make.left.equalTo(ws.safeAreaView);
        make.right.equalTo(ws.safeAreaView);
        make.bottom.equalTo(ws.retryButton.mas_top).offset(-60);
    }];
    
    [ws.containerViewTip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.contentContainerView.mas_top);
        make.left.right.equalTo(ws.contentContainerView);
        make.height.equalTo(ws.contentContainerView.mas_height).dividedBy(4);
    }];
    
    [ws.containerViewTip2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.containerViewTip1.mas_bottom);
        make.left.right.equalTo(ws.contentContainerView);
        make.height.equalTo(ws.contentContainerView.mas_height).dividedBy(4);
    }];
    
    [ws.containerViewTip3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.containerViewTip2.mas_bottom);
        make.left.right.equalTo(ws.contentContainerView);
        make.height.equalTo(ws.contentContainerView.mas_height).dividedBy(4);
    }];
    
    [ws.containerViewTip4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.containerViewTip3.mas_bottom);
        make.left.right.equalTo(ws.contentContainerView);
        make.height.equalTo(ws.contentContainerView.mas_height).dividedBy(4);
    }];
    
    
    
    
    [ws.imageViewTip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(ws.containerViewTip1).offset(15);
        make.bottom.equalTo(ws.containerViewTip1).offset(-15);
        make.width.equalTo(ws.imageViewTip1.mas_height);
    }];
    
    [ws.contentLabelTip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.containerViewTip1);
        make.left.equalTo(ws.imageViewTip1.mas_right).offset(15);
        make.right.equalTo(ws.containerViewTip1).offset(-15);
    }];
    
    [ws.imageViewTip2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(ws.containerViewTip2).offset(15);
        make.bottom.equalTo(ws.containerViewTip2).offset(-15);
        make.width.equalTo(ws.imageViewTip2.mas_height);
    }];
    
    [ws.contentLabelTip2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.containerViewTip2);
        make.left.equalTo(ws.imageViewTip2.mas_right).offset(15);
        make.right.equalTo(ws.containerViewTip2).offset(-15);
    }];
    
    [ws.imageViewTip3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(ws.containerViewTip3).offset(15);
        make.bottom.equalTo(ws.containerViewTip3).offset(-15);
        make.width.equalTo(ws.imageViewTip3.mas_height);
    }];
    
    [ws.contentLabelTip3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.containerViewTip3);
        make.left.equalTo(ws.imageViewTip3.mas_right).offset(15);
        make.right.equalTo(ws.containerViewTip3).offset(-15);
    }];
    
    [ws.imageViewTip4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(ws.containerViewTip4).offset(15);
        make.bottom.equalTo(ws.containerViewTip4).offset(-15);
        make.width.equalTo(ws.imageViewTip4.mas_height);
    }];
    
    [ws.contentLabelTip4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.containerViewTip4);
        make.left.equalTo(ws.imageViewTip4.mas_right).offset(15);
        make.right.equalTo(ws.containerViewTip4).offset(-15);
    }];
}

// MARK: - action 

- (void)retryButtonDidClick:(UIButton *)sender {
    // 返回设备类型选择页面
    for (UIViewController *controller in self.navigationController.childViewControllers) {
        NSString *classStr = NSStringFromClass([controller class]);
        if ([classStr isEqualToString:@"ACSelectProductController"]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
}

@end
