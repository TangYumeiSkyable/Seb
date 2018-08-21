//
//  LvWangTableViewCell.m
//  supor
//
//  Created by 白云杰 on 2017/5/19.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "LvWangTableViewCell.h"

@implementation LvWangTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _label.font = [UIFont fontWithName:Regular size:16];
    _label.textColor = [UIColor colorFromHexCode:@"#848484"];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
