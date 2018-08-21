//
//  HepaView.m
//  supor
//
//  Created by 赵冰冰 on 2017/5/11.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "HepaView.h"
#import "UIImage+FlatUI.h"
#import "SProgressView.h"
@implementation HepaView
{
    SProgressView * _progressView;
    UILabel * _progressLabel;
    UILabel * _hepaLabel;
}
- (void)createUI {
    
    self.backgroundColor = [UIColor greenColor];
    UIImageView * pointIv = [UIImageView new];
    pointIv.image = [UIImage circularImageWithColor:[UIColor grayColor] size:CGSizeMake(RATIO(30), RATIO(30))];
    [self addSubview:pointIv];
    
    UILabel * hepaLbl = [UILabel new];
    hepaLbl.font = [UIFont fontWithName:Regular size:13];
    hepaLbl.textColor = [UIColor grayColor];
    hepaLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:hepaLbl];
    _hepaLabel = hepaLbl;
    
    SProgressView * progress = [[SProgressView alloc]initWithProgressViewStyle: UIProgressViewStyleDefault];
    progress.progress = 0;
    [self addSubview:progress];
    _progressView = progress;
    
    progress.ggTrackImage = [UIImage imageWithColor:RGBA(242, 242, 242, 0.3) cornerRadius:4];
    progress.progressTintColor = [UIColor colorFromHexCode:@"#c8c8c8"];
    progress.ggProgressImage = [UIImage imageWithColor:[UIColor colorFromHexCode:@"#c8c8c8"] cornerRadius:4];
    
    UILabel * progressLabl = [UILabel new];
    progressLabl.font = [UIFont fontWithName:Regular size:14];
    progressLabl.textColor = [UIColor whiteColor];
    progressLabl.textAlignment = NSTextAlignmentLeft;
    progressLabl.text = @"";
    [self addSubview:progressLabl];
    _progressLabel = progressLabl;
    
    [pointIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(RATIO(30), RATIO(30)));
        make.left.mas_equalTo(progress);
        make.top.mas_equalTo(5);
    }];
    
    [hepaLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(pointIv);
        make.left.mas_equalTo(pointIv.mas_right).with.offset(RATIO(36));
    }];
    
    [progress mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.mas_equalTo(pointIv);
        make.width.mas_equalTo(self).multipliedBy(0.6);
        make.top.mas_equalTo(hepaLbl.mas_bottom).with.offset(3);
        make.height.mas_equalTo(RATIO(24));
        make.centerX.mas_equalTo(self);
    }];
    
    [progressLabl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(progress.mas_right).with.offset(0);
        make.right.mas_equalTo(self).offset(20);
        make.centerY.mas_equalTo(progress);
    }];
}

- (void)setFilterText:(NSString *)text {
    _hepaLabel.text = text;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    _progress = _progress <= 0 ? 0 : _progress;
            _progressLabel.text = [NSString stringWithFormat:@"   %.0lf%%", _progress];

    _progressView.progress = _progress / 100;
    
}

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

@end
