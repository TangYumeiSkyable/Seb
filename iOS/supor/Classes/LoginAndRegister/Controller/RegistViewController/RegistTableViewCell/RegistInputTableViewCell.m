//
//  RegistTableViewCell.m
//  supor
//
//  Created by Ennnnnn7 on 2018/5/14.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "RegistInputTableViewCell.h"

@implementation RegistInputTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
        self.backgroundColor = LJHexColor(@"#EEEEEE");
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - Common Methods
- (void)initViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.inputTextField];
    [self.contentView addSubview:self.checkImageView];
    self.inputTextField.rightView = self.ciphetSwitchButton;
}
#pragma mark - Target Action Methods
- (void)switchCiphetAction:(UIButton *)sender {
    if (self.ciphetSwitchBlock) {
        self.ciphetSwitchBlock(sender, self.inputTextField);
    }
}

#pragma mark - Lazyload Method
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = LJHexColor(@"#848484");
        _titleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
    }
    return _titleLabel;
}

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.secureTextEntry = YES;
        _inputTextField.returnKeyType = UIReturnKeyNext;
        _inputTextField.textColor = LJHexColor(@"#36424a");
        _inputTextField.textAlignment = NSTextAlignmentCenter;
        _inputTextField.backgroundColor = [UIColor whiteColor];
        _inputTextField.font = [UIFont fontWithName:Medium size:16];
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTextField.placeholder = GetLocalResStr(@"airpurifier_register_show_pwd_placeholder");
        _inputTextField.layer.cornerRadius = 6;
        _inputTextField.rightViewMode = UITextFieldViewModeAlways;
        
        _inputTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _inputTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _inputTextField;
}

- (UIImageView *)checkImageView {
    if (!_checkImageView) {
        _checkImageView = [[UIImageView alloc] init];
        _checkImageView.image = [UIImage imageNamed:@"ico_right_nor"];
    }
    return _checkImageView;
}

- (UIButton *)ciphetSwitchButton {
    if (!_ciphetSwitchButton) {
        _ciphetSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ciphetSwitchButton setImage:[[UIImage imageNamed:@"ico_eye_close"] imageWithSize:CGSizeMake(22, 16)] forState:UIControlStateNormal];
        [_ciphetSwitchButton addTarget:self action:@selector(switchCiphetAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ciphetSwitchButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(85);
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(0);
        make.right.equalTo(self.checkImageView.mas_left).offset(-10);
        make.height.mas_equalTo(44);
    }];
    
    [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.ciphetSwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(44);
    }];
}

@end
