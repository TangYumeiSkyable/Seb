//
//  MyshebeiTableViewCell.m
//  supor
//
//  Created by huayiyang on 16/6/27.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "MyshebeiTableViewCell.h"

@implementation MyshebeiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLabel.textColor = LJHexColor(@"#36424a");
    self.nameLabel.font = [UIFont fontWithName:Regular size:18];
    
    self.xinghaoLabel.textColor = LJHexColor(@"#848484");
    self.xinghaoLabel.font = [UIFont fontWithName:Regular size:14];
    
    self.shebeiImageView.backgroundColor = [UIColor clearColor];
    
}

@end
