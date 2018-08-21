//
//  HeaderCollectionViewCell.m
//  supor
//
//  Created by 刘杰 on 2018/3/26.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "HeaderCollectionViewCell.h"

@implementation HeaderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [self.contentView addSubview:self.levelImageView];
    [self.contentView addSubview:self.arrowImageView];
}

#pragma mark - Lazyload Methods
- (UIImageView *)levelImageView {
    if (!_levelImageView) {
        _levelImageView = [[UIImageView alloc] init];
        _levelImageView.contentMode = UIViewContentModeCenter;
    }
    return _levelImageView;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_cutting"]];
    }
    return _arrowImageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.right.equalTo(self.arrowImageView.mas_left);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(10);
    }];
}

@end
