//
//  ContentCollectionViewCell.m
//  supor
//
//  Created by 刘杰 on 2018/3/26.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "ContentCollectionViewCell.h"

@interface ContentCollectionViewCell ()

@property (nonatomic, strong) UIView *subTitlePointView;

@property (nonatomic, strong) UIView *contentPointView;

@property (nonatomic, strong) UIView *contentBackgroundView;

@end


@implementation ContentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = LJHexColor(@"#EEEEEE");
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [self.contentView addSubview:self.contentBackgroundView];
    [self.contentBackgroundView addSubview:self.titleLabel];
    [self.contentBackgroundView addSubview:self.subTitlePointView];
    [self.contentBackgroundView addSubview:self.subTitleLabel];
    [self.contentBackgroundView addSubview:self.contentPointView];
    [self.contentBackgroundView addSubview:self.contentTextLabel];
}

#pragma mark - Lazyload Methods
- (UIView *)contentBackgroundView {
    if (!_contentBackgroundView) {
        _contentBackgroundView = [[UIView alloc] init];
        _contentBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _contentBackgroundView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = LJHexColor(@"#36424a");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:Regular size:18];
    }
    return _titleLabel;
}

- (UIView *)subTitlePointView {
    if (!_subTitlePointView) {
        _subTitlePointView = [[UIView alloc] init];
        
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 5, 5) cornerRadius:2.5];
        CAShapeLayer *subtitlePointLayer = [CAShapeLayer layer];
        subtitlePointLayer.path = circlePath.CGPath;
        subtitlePointLayer.fillColor = LJHexColor(@"#009dc2").CGColor;
        [_subTitlePointView.layer addSublayer:subtitlePointLayer];
    }
    return _subTitlePointView;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = LJHexColor(@"#36424a");
        _subTitleLabel.font = [UIFont fontWithName:Medium size:16];
        _subTitleLabel.numberOfLines = 0;
    }
    return _subTitleLabel;
}

- (UIView *)contentPointView {
    if (!_contentPointView) {
        _contentPointView = [[UIView alloc] init];
        
        UIBezierPath *pointPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 5, 5) cornerRadius:2.5];
        CAShapeLayer *contentPointLayer = [CAShapeLayer layer];
        contentPointLayer.path = pointPath.CGPath;
        contentPointLayer.fillColor = LJHexColor(@"#009dc2").CGColor;
        [_contentPointView.layer addSublayer:contentPointLayer];
    }
    return _contentPointView;
}

- (UILabel *)contentTextLabel {
    if (!_contentTextLabel) {
        _contentTextLabel = [[UILabel alloc] init];
        _contentTextLabel.textColor = LJHexColor(@"#36424a");
        _contentTextLabel.font = [UIFont fontWithName:Medium size:16];
        _contentTextLabel.numberOfLines = 0;
    }
    return _contentTextLabel;
}

- (UITextView *)opinionTextView {
    if (!_opinionTextView) {
        _opinionTextView = [[UITextView alloc] init];
        _opinionTextView.textColor = LJHexColor(@"#36424a");
        _opinionTextView.font = [UIFont fontWithName:Medium size:16];  
    }
    return _opinionTextView;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.contentTextLabel.mas_bottom).offset(20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(RATIO(72));
        make.height.mas_equalTo(30);
    }];
    
    [self.subTitlePointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.subTitleLabel.mas_top).offset(8);
        make.width.height.mas_equalTo(5);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(RATIO(72));
        make.left.equalTo(self.subTitlePointView.mas_right).offset(RATIO(10));
        make.right.mas_equalTo(-20);
    }];
    
    [self.contentPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subTitlePointView.mas_left);
        make.top.equalTo(self.contentTextLabel.mas_top).offset(8);
        make.width.height.mas_equalTo(5);
    }];
    
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(20);
        make.left.equalTo(self.subTitleLabel.mas_left);
        make.right.equalTo(self.subTitleLabel.mas_right);
    }];
}

@end
