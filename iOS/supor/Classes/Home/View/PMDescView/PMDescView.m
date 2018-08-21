//
//  PMDescView.m
//  supor
//
//  Created by Jun Zhou on 2017/10/27.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "PMDescView.h"

@interface PMDescView ()

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *valueLabel;

@property (strong, nonatomic) UILabel *unitLabel;

@end

@implementation PMDescView

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.text = @"FIND PARTICLES & ALLERGENES";
        _titleLabel.text = GetLocalResStr(@"circle_pm25_des");
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)valueLabel {
    if (_valueLabel == nil) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = [UIFont boldSystemFontOfSize:22];
        _valueLabel.textColor = [UIColor whiteColor];
    }
    return _valueLabel;
}

- (UILabel *)unitLabel {
    if (_unitLabel == nil) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = [UIFont systemFontOfSize:10];
        _unitLabel.text = @"μg/m3";
        _unitLabel.textColor = [UIColor whiteColor];
    }
    
    return _unitLabel;
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
    [self addSubview:self.valueLabel];
    [self addSubview:self.unitLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    WEAKSELF(ws);
    [ws.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws).offset(5);
        make.centerX.equalTo(ws);
    }];
    
    [ws.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
    }];
    
    [ws.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws).offset(-5);
        make.centerX.equalTo(ws);
    }];
}

- (void)setPm25Value:(NSString *)pm25Value {
    _pm25Value = pm25Value;
    self.valueLabel.text = pm25Value;
}


@end
