//
//  MessageTableViewCell.m
//  supor
//
//  Created by 白云杰 on 2017/5/11.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    RHBorderRadius(self.labelState, 3, 0, [UIColor clearColor]);
    
    self.labelTitle.numberOfLines = 0;
    self.labelTitle.textColor =  LJHexColor(@"#36424a");
    self.labelTitle.font = [UIFont fontWithName:Regular size:18];
    self.labelTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.lableTime.textColor = LJHexColor(@"#c8c8c8");
    self.lableTime.font = [UIFont fontWithName:Regular size:14];
    
    self.labelContent.textColor = LJHexColor(@"#848484");
    self.labelContent.font = [UIFont fontWithName:Regular size:18];
    self.labelContent.numberOfLines = 0;
}

@end
