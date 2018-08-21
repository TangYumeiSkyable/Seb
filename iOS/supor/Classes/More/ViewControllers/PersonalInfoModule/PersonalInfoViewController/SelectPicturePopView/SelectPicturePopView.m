//
//  SelectPicturePopView.m
//  supor
//
//  Created by 刘杰 on 2018/4/27.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "SelectPicturePopView.h"

@interface SelectPicturePopView ()

@property (nonatomic, strong) UIView *bottomBackgroundView;

@property (nonatomic, strong) UIButton *cameraButton;

@property (nonatomic, strong) UIView *firstLineView;

@property (nonatomic, strong) UIButton *albumButton;

@property (nonatomic, strong) UIView *secondLineView;

@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation SelectPicturePopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.6);
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.bottomBackgroundView];
    [self.bottomBackgroundView addSubview:self.cameraButton];
    [self.bottomBackgroundView addSubview:self.firstLineView];
    [self.bottomBackgroundView addSubview:self.albumButton];
    [self.bottomBackgroundView addSubview:self.secondLineView];
    [self.bottomBackgroundView addSubview:self.cancelButton];
}

#pragma mark - Target Action
- (void)selectCameraAction:(UIButton *)sender {
    if (_completion) {
        _completion(PopViewSelectCamera);
    }
    [self hidePopView];
}

- (void)selectAlbumAction:(UIButton *)sender {
    if (_completion) {
        _completion(PopViewSelectAlbum);
    }
    [self hidePopView];
}

- (void)cancelAction:(UIButton *)sender {
    [self hidePopView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hidePopView];
}

#pragma mark - Private Methods
- (void)showPopView {
    [UIView animateWithDuration:2.f animations:^{
        [[UIApplication sharedApplication].delegate.window addSubview:self];
    }];
}

- (void)hidePopView {
    [UIView animateWithDuration:0.2f animations:^{
        self.bottomBackgroundView.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Lazyload Methods
- (UIView *)bottomBackgroundView {
    if (!_bottomBackgroundView) {
        _bottomBackgroundView = [[UIView alloc] init];
        _bottomBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomBackgroundView;
}

- (UIButton *)cameraButton {
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setTitle:GetLocalResStr(@"airpurifier_more_show_takephoto_text") forState:UIControlStateNormal];
        [_cameraButton setTitleColor:LJHexColor(@"#36424a") forState:UIControlStateNormal];
        _cameraButton.titleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        _cameraButton.backgroundColor = self.bottomBackgroundView.backgroundColor;
        [_cameraButton addTarget:self action:@selector(selectCameraAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}

- (UIView *)firstLineView {
    if (!_firstLineView) {
        _firstLineView = [[UIView alloc] init];
        _firstLineView.backgroundColor = [UIColor classics_gray];
    }
    return _firstLineView;
}

- (UIButton *)albumButton {
    if (!_albumButton) {
        _albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumButton setTitle:GetLocalResStr(@"airpurifier_more_show_selectfromalbum_text") forState:UIControlStateNormal];
        [_albumButton setTitleColor:LJHexColor(@"#36424a") forState:UIControlStateNormal];
        _albumButton.titleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        _albumButton.backgroundColor = self.bottomBackgroundView.backgroundColor;
        [_albumButton addTarget:self action:@selector(selectAlbumAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _albumButton;
}

- (UIView *)secondLineView {
    if (!_secondLineView) {
        _secondLineView = [[UIView alloc] init];
        _secondLineView.backgroundColor = [UIColor classics_gray];
    }
    return _secondLineView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:GetLocalResStr(@"airpurifier_public_cancel") forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        _cancelButton.backgroundColor = [UIColor classics_blue];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.layer.cornerRadius = RATIO(156) / 2;
    }
    return _cancelButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.bottomBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(230 + DeviceUtils.bottomSafeHeight);
    }];
    
    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cameraButton.mas_bottom);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
    
    [self.albumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstLineView.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
        make.height.equalTo(self.cameraButton.mas_height);
    }];
    
    [self.secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.albumButton.mas_bottom);
        make.left.equalTo(self.firstLineView.mas_left);
        make.right.equalTo(self.firstLineView.mas_right);
        make.height.equalTo(self.firstLineView.mas_height);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondLineView.mas_bottom).offset(30);
        make.left.equalTo(self.secondLineView.mas_left);
        make.right.equalTo(self.secondLineView.mas_right);
        make.height.equalTo(self.albumButton.mas_height);
    }];
}

@end
