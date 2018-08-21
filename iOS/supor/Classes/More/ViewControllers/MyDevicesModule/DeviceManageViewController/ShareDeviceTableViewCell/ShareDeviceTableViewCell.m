//
//  ShareDeviceTableViewCell.m
//  supor
//
//  Created by 刘杰 on 2018/4/19.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "ShareDeviceTableViewCell.h"

@interface ShareDeviceTableViewCell ()

@property (nonatomic, strong) UIImageView *qrCodeImageView;

@end

@implementation ShareDeviceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.text = GetLocalResStr(@"airpurifier_moredevice_show_devicecode_text");
        self.textLabel.textColor = LJHexColor(@"#848484");
        self.textLabel.font = [UIFont fontWithName:Regular size:17];
        
        [self.contentView addSubview:self.qrCodeImageView];
    }
    return self;
}

#pragma mark - Lazyload Methods
- (UIImageView *)qrCodeImageView {
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[UIImageView alloc] init];
        _qrCodeImageView.image = [UIImage imageNamed:@"ico_qr_code"];
    }
    return _qrCodeImageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(25);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
}

@end
