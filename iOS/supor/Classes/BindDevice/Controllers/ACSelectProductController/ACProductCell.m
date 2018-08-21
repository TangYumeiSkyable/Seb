//
//  ACProductCell.m
//  supor
//
//  Created by Jun Zhou on 2017/11/15.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "ACProductCell.h"
#import "UIImageView+WebCache.h"

@interface ACProductCell ()

@property (strong, nonatomic) UIImageView *productImageView;

@property (strong, nonatomic) UILabel *modelLabel;

@property (strong, nonatomic) UILabel *nameLabel;

@end

@implementation ACProductCell

- (UIImageView *)productImageView {
    if (_productImageView == nil) {
        _productImageView = [[UIImageView alloc] init];
        _productImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _productImageView;
}

- (UILabel *)modelLabel {
    if (_modelLabel == nil) {
        _modelLabel = [[UILabel alloc] init];
        _modelLabel.font = [UIFont systemFontOfSize:18];
        _modelLabel.textColor = [UIColor blackColor];
        _modelLabel.textAlignment = NSTextAlignmentLeft;
        _modelLabel.numberOfLines = 2;
    }
    return _modelLabel;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = RGB(164, 164, 164);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
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
    [self.contentView addSubview:self.productImageView];
    [self.contentView addSubview:self.modelLabel];
    [self.contentView addSubview:self.nameLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    WEAKSELF(ws);
    [ws.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.left.equalTo(ws.contentView);
        make.centerY.equalTo(ws.contentView);
    }];

    [ws.modelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.productImageView).offset(5);
        make.left.equalTo(ws.productImageView.mas_right).offset(10);
        make.right.equalTo(ws.contentView).offset(-15);
    }];

    [ws.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.modelLabel);
        make.right.equalTo(ws.modelLabel);
        make.top.equalTo(ws.modelLabel.mas_bottom).offset(10);
    }];
}

- (void)setDataSourceDic:(NSDictionary *)dataSourceDic {
    _dataSourceDic = dataSourceDic;
    
    NSString *imgUrl = [dataSourceDic[@"imgUrl"] stringByReplacingOccurrencesOfString:@"{size}/" withString:@""];
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"img_p1"]];
    
    self.modelLabel.text = [NSString stringWithFormat:GetLocalResStr(@"airpurifier_more_show_devicemodelnumber_text"),dataSourceDic[@"name"]];
    
    //self.nameLabel.text = dataSourceDic[@"name"];
}

@end
