//
//  ACFAQLeafCell.m
//  supor
//
//  Created by Jun Zhou on 2018/3/5.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "ACFAQLeafCell.h"

@interface ACFAQLeafCell ()

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UIImageView *arrowImageView;

@property (strong, nonatomic) UIView *lineView;

@end

@implementation ACFAQLeafCell


- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = RGB(164, 164, 164);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"ico_more.png"];
        _arrowImageView.hidden = YES;
    }
    return _arrowImageView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.hidden = YES;
    }
    return _lineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
        [self setupSubViews];
    }
    return self;
}

- (void)configUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    WEAKSELF(ws);
    [ws.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView).offset(15);
        make.right.equalTo(ws.contentView).offset(-15);
        make.centerY.equalTo(ws.contentView);
    }];
    
    [ws.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.right.equalTo(ws.contentView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    [ws.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView);
        make.bottom.equalTo(ws.contentView);
        make.right.equalTo(ws.contentView);
        make.height.equalTo(@(0.5));
    }];
}

- (void)cellFillData:(NSString *)string color:(UIColor *)color {
    self.nameLabel.text = string;
    self.nameLabel.textColor = color ? color : RGB(164, 164, 164);
}


@end
