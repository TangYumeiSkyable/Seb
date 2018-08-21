//
//  AvatarTableViewCell.m
//  supor
//
//  Created by 刘杰 on 2018/4/25.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "AvatarTableViewCell.h"



@implementation AvatarTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.textLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        self.textLabel.textColor = LJHexColor(@"#848484");
        
        self.detailTextLabel.textColor = LJHexColor(@"#36424a");
        self.detailTextLabel.font = [UIFont fontWithName:Regular size:16];
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [self.contentView addSubview:self.avatarImageView];
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_big_avator"]];
        _avatarImageView.layer.cornerRadius = 35;
    }
    return _avatarImageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.equalTo(self.avatarImageView.mas_height);
    }];
}

@end
