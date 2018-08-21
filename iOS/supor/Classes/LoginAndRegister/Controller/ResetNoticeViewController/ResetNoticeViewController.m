//
//  ResetNoticeViewController.m
//  supor
//
//  Created by Ennnnnn7 on 2018/5/11.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "ResetNoticeViewController.h"
#import "UIImage+FlatUI.h"

@interface ResetNoticeViewController ()

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *signInButton;

@end

@implementation ResetNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
}

// MARK: - Common Methods
- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = GetLocalResStr(@"airpurifier_login_show_reset_title_text");
}

- (void)initViews {
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.signInButton];
}

// MARK: - Target Action Method
- (void)signInButtonAction {
    // back to loginViewController
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// MARK: Private Method
- (void)setLabelAttributeText {
    NSMutableAttributedString *tempString = [[NSMutableAttributedString alloc] initWithString:self.tipLabel.text];
    [tempString addAttribute:NSForegroundColorAttributeName value:[UIColor classics_blue] range:[self.tipLabel.text rangeOfString:_emailText]];
    self.tipLabel.attributedText = tempString;
}

// MARK: Lazyload Methods
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = [NSString stringWithFormat:GetLocalResStr(@"airpurifier_login_show_psdinfo_text_ios"), _emailText];
        _tipLabel.textColor = LJHexColor(@"#36424a");
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        [self setLabelAttributeText];
    }
    return _tipLabel;
}

- (UIButton *)signInButton {
    if (!_signInButton) {
        _signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _signInButton.titleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        [_signInButton setTitle:GetLocalResStr(@"airpurifier_login_show_login_text") forState:UIControlStateNormal];
        [_signInButton setBackgroundImage:[UIImage imageWithColor:[UIColor  classics_blue] cornerRadius:22] forState:UIControlStateNormal];
        _signInButton.adjustsImageWhenHighlighted = NO;
        [_signInButton addTarget:self action:@selector(signInButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signInButton;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(74);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(50);
        make.left.equalTo(self.tipLabel.mas_left);
        make.right.equalTo(self.tipLabel.mas_right);
        make.height.mas_equalTo(44);
    }];
}

@end
