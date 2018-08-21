//
//  OutDoorView.m
//  supor
//
//  Created by 刘杰 on 2018/3/24.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "OutDoorView.h"


@interface OutDoorView ()

@property (nonatomic, strong) UIView *levelImageBackgroundView;

@property (nonatomic, strong) UILabel *airQualityLevelTitlelabel;

@property (nonatomic, strong) UIImageView *rightArrowImageView;

@property (nonatomic, strong) UIView *descriptionPointView;

@end

@implementation OutDoorView

#pragma mark - Init View Method
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LJHexColor(@"#EEEEEE");
        [self initViews];
    }
    return self;
}

#pragma mark - Common Methods
- (void)initViews {
    [self addSubview:self.selectCityButton];
//    [self addSubview:self.unitLabel];
    [self addSubview:self.levelImageBackgroundView];
    [self.levelImageBackgroundView addSubview:self.airLevelImageView];
    [self.levelImageBackgroundView addSubview:self.airLevelLabel];
    [self addSubview:self.airQualityIndexTableView];
    [self addSubview:self.levelBackgroundView];
    [self.levelBackgroundView addSubview:self.airQualityLevelTitlelabel];
    [self.levelBackgroundView addSubview:self.rightArrowImageView];
    [self addSubview:self.descriptionPointView];
    [self addSubview:self.AQITypeTitleLabel];
    [self addSubview:self.AQITypeDescriptionTextView];
}

#pragma mark - Lazyload Methods
- (UIButton *)selectCityButton {
    if (!_selectCityButton) {
        _selectCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectCityButton.titleLabel.font = [UIFont fontWithName:Regular size:18];
        [_selectCityButton setTitleColor:LJHexColor(@"#848484") forState:UIControlStateNormal];
        [_selectCityButton setImage:[UIImage imageNamed:@"ico_more3"] forState:UIControlStateNormal];
        [_selectCityButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    }
    return _selectCityButton;
}

//- (UILabel *)unitLabel {
//    if (!_unitLabel) {
//        _unitLabel= [[UILabel alloc] init];
//        _unitLabel.text = @"μg/m³";
//        _unitLabel.font = [UIFont boldSystemFontOfSize:18];
//        _unitLabel.textAlignment = NSTextAlignmentCenter;
//        _unitLabel.textColor = [UIColor blackColor];
//    }
//    return _unitLabel;
//}


- (UIView *)levelImageBackgroundView {
    if (!_levelImageBackgroundView) {
        _levelImageBackgroundView = [[UIView alloc] init];
    }
    return _levelImageBackgroundView;
}

- (UIImageView *)airLevelImageView {
    if (!_airLevelImageView) {
        _airLevelImageView = [[UIImageView alloc] init];
    }
    return _airLevelImageView;
}

- (UILabel *)airLevelLabel {
    if (!_airLevelLabel) {
        _airLevelLabel = [[UILabel alloc] init];
        _airLevelLabel.text = @"--";
        _airLevelLabel.numberOfLines = 0;
        _airLevelLabel.textColor = LJHexColor(@"#009dc2");
        _airLevelLabel.textAlignment = NSTextAlignmentCenter;
        _airLevelLabel.font = [UIFont fontWithName:Regular size:18];
    }
    return _airLevelLabel;
}

- (UITableView *)airQualityIndexTableView {
    if (!_airQualityIndexTableView) {
        _airQualityIndexTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _airQualityIndexTableView.backgroundColor = self.backgroundColor;
        [_airQualityIndexTableView registerClass:[AQITypeTableViewCell class] forCellReuseIdentifier:typeCellIdentifier];
        _airQualityIndexTableView.rowHeight = 44;
        _airQualityIndexTableView.tableFooterView = [UIView new];
        _airQualityIndexTableView.showsVerticalScrollIndicator = NO;
        _airQualityIndexTableView.showsHorizontalScrollIndicator = NO;
        _airQualityIndexTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _airQualityIndexTableView.scrollEnabled = NO;
    }
    return _airQualityIndexTableView;
}

- (UIView *)levelBackgroundView {
    if (!_levelBackgroundView) {
        _levelBackgroundView = [[UIView alloc] init];
        _levelBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _levelBackgroundView;
}

- (UILabel *)airQualityLevelTitlelabel {
    if (!_airQualityLevelTitlelabel) {
        _airQualityLevelTitlelabel = [[UILabel alloc] init];
        _airQualityLevelTitlelabel.text = GetLocalResStr(@"airpurifier_more_show_airquality_text");
        _airQualityLevelTitlelabel.font = [UIFont fontWithName:Regular size:18];
        _airQualityLevelTitlelabel.textColor = LJHexColor(@"#36424a");
    }
    return _airQualityLevelTitlelabel;
}

- (UIImageView *)rightArrowImageView {
    if (!_rightArrowImageView) {
        _rightArrowImageView = [[UIImageView alloc] init];
        _rightArrowImageView.image = [UIImage imageNamed:@"ico_more"];
    }
    return _rightArrowImageView;
}

- (UIView *)descriptionPointView {
    if (!_descriptionPointView) {
        _descriptionPointView = [[UIView alloc] init];
        
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 5, 5) cornerRadius:2.5];
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.path = circlePath.CGPath;
        circleLayer.fillColor = LJHexColor(@"#009dc2").CGColor;
        [_descriptionPointView.layer addSublayer:circleLayer];
    }
    return _descriptionPointView;
}

- (UILabel *)AQITypeTitleLabel {
    if (!_AQITypeTitleLabel) {
        _AQITypeTitleLabel = [[UILabel alloc] init];
        _AQITypeTitleLabel.textColor = LJHexColor(@"#36424a");
        _AQITypeTitleLabel.font = [UIFont fontWithName:Regular size:18];
        
        _AQITypeTitleLabel.text = GetLocalResStr(@"airpurifier_more_airquality_tvno2");
    }
    return _AQITypeTitleLabel;
}

- (UITextView *)AQITypeDescriptionTextView {
    if (!_AQITypeDescriptionTextView) {
        _AQITypeDescriptionTextView = [[UITextView alloc] init];
        _AQITypeDescriptionTextView.font = [UIFont fontWithName:Regular size:18];
        _AQITypeDescriptionTextView.textColor = self.AQITypeTitleLabel.textColor;
        _AQITypeDescriptionTextView.editable = NO;
        _AQITypeDescriptionTextView.selectable = NO;
        _AQITypeDescriptionTextView.showsVerticalScrollIndicator = NO;
        _AQITypeDescriptionTextView.text = GetLocalResStr(@"airpurifier_more_airquality_no2");
        _AQITypeDescriptionTextView.backgroundColor = self.backgroundColor;
    }
    return _AQITypeDescriptionTextView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.selectCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(RATIO(18));
        make.left.mas_equalTo(RATIO(48));
    }];
    
//    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.selectCityButton.mas_bottom).offset(RATIO(35));
//        make.right.mas_equalTo(RATIO(-25));
//        make.width.equalTo(self.selectCityButton.mas_width);
//        make.height.equalTo(self.selectCityButton.mas_height);
//
//    }];
    
    [self.levelImageBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectCityButton.mas_bottom).offset(RATIO(102));
        make.left.mas_equalTo(0);
        make.width.equalTo(self.airQualityIndexTableView.mas_width);
        make.right.equalTo(self.airQualityIndexTableView.mas_left);
        make.bottom.equalTo(self.airLevelLabel.mas_bottom).offset(30);
    }];
    
    [self.airLevelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(RATIO(318), RATIO(228)));
        make.center.mas_equalTo(0);
    }];
    
    [self.airLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.airLevelImageView.mas_bottom).offset(10);
        make.left.mas_equalTo(RATIO(48));
        make.right.mas_equalTo(RATIO(-48));
    }];
    
    [self.airQualityIndexTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.levelImageBackgroundView.mas_top);
        make.left.equalTo(self.levelImageBackgroundView.mas_right);
        make.right.mas_equalTo(0);
        make.width.equalTo(self.levelImageBackgroundView.mas_width);
        make.height.equalTo(self.levelImageBackgroundView.mas_height);
    }];
    
    [self.levelBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.airQualityIndexTableView.mas_bottom).offset(RATIO(60));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    [self.airQualityLevelTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(0);
    }];
    
    [self.descriptionPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.levelBackgroundView.mas_bottom).offset(20);
        make.left.offset(20);
        make.width.height.mas_equalTo(4);
    }];
    
    [self.AQITypeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descriptionPointView.mas_right).offset(5);
        make.centerY.equalTo(self.descriptionPointView.mas_centerY);
    }];
    
    [self.AQITypeDescriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.AQITypeTitleLabel.mas_bottom);
        make.left.equalTo(self.descriptionPointView.mas_left);
        make.right.bottom.mas_equalTo(-20);
    }];
}
@end
