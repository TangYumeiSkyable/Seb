//
//  RegistOneButtonTableViewCell.m
//  supor
//
//  Created by Ennnnnn7 on 2018/5/14.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "RegistOneButtonTableViewCell.h"

const CGFloat RegistButtonHeight = 44;

@implementation RegistOneButtonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.registButton];
        self.backgroundColor = LJHexColor(@"#EEEEEE");
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - Lazyload Method
- (UIButton *)registButton {
    if (!_registButton) {
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registButton setTitle:GetLocalResStr(@"airpurifier_login_show_button_submittext") forState:UIControlStateNormal];
        _registButton.titleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        [_registButton setTitleColor:LJHexColor(@"#f2f2f2") forState:UIControlStateNormal];
        [_registButton setBackgroundImage:[UIImage imageWithColor:[UIColor classics_gray] cornerRadius:RegistButtonHeight * 0.5] forState:UIControlStateNormal];
        _registButton.userInteractionEnabled = NO;
        _registButton.layer.cornerRadius = RegistButtonHeight * 0.5;
    }
    return _registButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(RegistButtonHeight);
    }];
}

@end
