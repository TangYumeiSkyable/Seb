//
//  HomeCell.m
//  supor
//
//  Created by 赵冰冰 on 16/6/17.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#define FONTSIZE 40
#import "HomeCell.h"

@implementation HomeCell

- (void)createUI01 {
    self.pmLabel = [UILabel new];
    self.pmLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.pmLabel];
 
    self.degreeLabel = [UILabel new];
    self.degreeLabel.textColor = [UIColor whiteColor];
    self.degreeLabel.font = [UIFont fontWithName:Regular size:FONTSIZE];
    [self.contentView addSubview:self.degreeLabel];
    
    self.filterLabel = [UILabel new];
    self.filterLabel.textColor = [UIColor whiteColor];
    self.filterLabel.font = [UIFont fontWithName:Regular size:15];
    [self.contentView addSubview:self.filterLabel];
    
    self.filterLabel2 = [UILabel new];
    self.filterLabel2.textColor = [UIColor whiteColor];
    self.filterLabel2.font = [UIFont fontWithName:Regular size:15];
    [self.contentView addSubview:self.filterLabel2];
    
    [self.degreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).with.offset(kMainScreenWidth / 5);
        make.centerY.mas_equalTo(self.contentView).with.offset(-8);
        make.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(40);
    }];
    
    [self.pmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.degreeLabel).with.offset(0);
        make.bottom.mas_equalTo(self.degreeLabel.mas_top);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(25);
    }];
    
    [self.filterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.degreeLabel).with.offset(5);
        make.top.mas_equalTo(self.degreeLabel.mas_bottom);
        make.height.mas_equalTo(25);
    }];

    [self.filterLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.filterLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.filterLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.degreeLabel).with.offset(5);
        make.top.mas_equalTo(self.filterLabel.mas_bottom);
        make.height.mas_equalTo(25);
    }];
    
    [self.filterLabel2 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.filterLabel2 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    self.pmLabel.text = @"";
    self.degreeLabel.text = @"";
    self.filterLabel.text = @"";

    if (kMainScreenWidth > 375) {
        self.filterLabel.font = [UIFont fontWithName:Regular size:15];
        self.filterLabel2.font = [UIFont fontWithName:Regular size:15];
    }else{
        self.filterLabel.font = [UIFont fontWithName:Regular size:15];
        self.filterLabel2.font = [UIFont fontWithName:Regular size:15];
    }
    
    self.filterLabel2.text = @"Nano filter:consumption59%";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI01];
    }
    return self;
}

@end
