//
//  IndicatorTitleView.m
//  supor
//
//  Created by Jun Zhou on 2017/10/30.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "IndicatorTitleView.h"

@interface IndicatorTitleView ()

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIView *lineView;

@end

@implementation IndicatorTitleView

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"--";
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];
    }
    return _lineView;
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
    [self addSubview:self.lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    WEAKSELF(ws);
    [ws.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(ws);
        make.top.equalTo(ws).offset(10);
        make.bottom.equalTo(ws).offset(-10);
    }];
    
    [ws.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(ws).offset(15);
        make.right.equalTo(ws).offset(-15);
        make.top.equalTo(ws.titleLabel.mas_bottom);
    }];

}


- (void)setAirPureState:(AirPureState)airPureState {
    _airPureState = airPureState;
    
    switch (airPureState) {
        case AirPureStateGood: {
            self.titleLabel.text = GetLocalResStr(@"air_quality_A");
           break;
        }
        case AirPureStateAverage: {
            self.titleLabel.text = GetLocalResStr(@"airpurifier_more_airquality_moderate_new");
            break;
        }
        case AirPureStateBad: {
            self.titleLabel.text = GetLocalResStr(@"airpurifier_more_airquality_high_new");
            break;
        }
        default:
            self.titleLabel.text = GetLocalResStr(@"air_quality_A");
            break;
    }
}

@end
