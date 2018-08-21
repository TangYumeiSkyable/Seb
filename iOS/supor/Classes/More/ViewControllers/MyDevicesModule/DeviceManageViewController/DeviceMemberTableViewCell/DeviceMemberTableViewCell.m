//
//  DeviceMemberTableViewCell.m
//  supor
//
//  Created by 刘杰 on 2018/4/19.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "DeviceMemberTableViewCell.h"

@interface DeviceMemberTableViewCell ()



@end

@implementation DeviceMemberTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.avatorImageView];
        [self.contentView addSubview:self.accountLabel];
        [self.contentView addSubview:self.unbindButton];
    }
    return self;
}


#pragma mark - Lazyload Methods
- (UIImageView *)avatorImageView {
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.image = [[UIImage imageNamed:@"img_big_avator"] imageWithSize:CGSizeMake(44, 44)];
    }
    return _avatorImageView;
}

- (UILabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.textColor = LJHexColor(@"#848484");
        _accountLabel.font = [UIFont fontWithName:Regular size:17];
    }
    return _accountLabel;
}

- (UIButton *)unbindButton {
    if (!_unbindButton) {
        _unbindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unbindButton setTitle:GetLocalResStr(@"airpurifier_more_show_cancelsharealign_text") forState:UIControlStateNormal];
        [_unbindButton setTitleColor:LJHexColor(@"#36424a") forState:UIControlStateNormal];
        _unbindButton.titleLabel.font = [UIFont fontWithName:Regular size:16];
    }
    return _unbindButton;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(44);
    }];
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatorImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.unbindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.bottom.mas_equalTo(0);
    }];
}

@end
