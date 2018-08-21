//
//  AQITypeTableViewCell.m
//  supor
//
//  Created by 刘杰 on 2018/3/24.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "AQITypeTableViewCell.h"

@interface AQITypeTableViewCell ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation AQITypeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = LJHexColor(@"#EEEEEE");
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [self.contentView addSubview:self.pointView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.numberLabel];
}

#pragma mark - LazyLoad Methods
- (UIView *)pointView {
    if (!_pointView) {
        _pointView = [[UIView alloc] init];
        _pointView.hidden = YES;
        [_pointView.layer addSublayer:self.circleLayer];
    }
    return _pointView;
}

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 5, 5) cornerRadius:2.5];
        _circleLayer.path = circlePath.CGPath;
        [_circleLayer setFillColor:LJHexColor(@"#009dc2").CGColor];
    }
    return _circleLayer;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = LJHexColor(@"#36424a");
        _titleLabel.font = [UIFont fontWithName:Regular size:18];
        _titleLabel.text = @"--";
    }
    return _titleLabel;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textColor = LJHexColor(@"#009dc2");
        _numberLabel.font = [UIFont fontWithName:Medium size:22];
        _numberLabel.text = @"--";
    }
    return _numberLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pointView.mas_right).offset(5);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(75);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.equalTo(self.titleLabel.mas_right).offset(RATIO(48));
        make.right.mas_equalTo(-3);
    }];
}

@end
