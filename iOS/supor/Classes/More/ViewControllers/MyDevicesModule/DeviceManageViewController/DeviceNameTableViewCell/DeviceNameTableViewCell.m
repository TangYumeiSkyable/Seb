//
//  DeviceNameTableViewCell.m
//  supor
//
//  Created by 刘杰 on 2018/4/19.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "DeviceNameTableViewCell.h"

@implementation DeviceNameTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.textLabel.text = GetLocalResStr(@"airpurifier_moredevice_show_deviceinfo_text");
        self.textLabel.textColor = LJHexColor(@"#848484");
        self.textLabel.font = [UIFont fontWithName:Regular size:17];
        
        self.detailTextLabel.textColor = LJHexColor(@"#36424a");
        self.detailTextLabel.font = [UIFont fontWithName:Regular size:16];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

@end
