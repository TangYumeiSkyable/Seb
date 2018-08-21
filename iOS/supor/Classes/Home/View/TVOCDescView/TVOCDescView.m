//
//  TVOCDescView.m
//  supor
//
//  Created by Jun Zhou on 2017/10/27.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "TVOCDescView.h"

@interface TVOCDescView ()

@property (strong, nonatomic) UIImageView *faceImageView;

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation TVOCDescView

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = GetLocalResStr(@"circle_gas_des");
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIImageView *)faceImageView {
    if (_faceImageView == nil) {
        _faceImageView = [[UIImageView alloc] init];
    }
    return _faceImageView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.faceImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    WEAKSELF(ws);
    [ws.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws);
        make.centerX.equalTo(ws);
    }];
    
    [ws.faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.titleLabel.mas_bottom).offset(5);
        make.centerX.equalTo(ws);
        make.width.height.mas_equalTo(RATIO(90));
    }];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.faceImageView.image = image;
}

@end
