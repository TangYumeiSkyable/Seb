//
//  ChangePWDView.h
//  supor
//
//  Created by 刘杰 on 2018/4/23.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePWDView : UIView

@property (nonatomic, strong) UILabel *pwdTitleLabel;

@property (nonatomic, strong) UITextField *pwdTextField;

@property (nonatomic, strong) UIButton *pwdSwitchButton;

@property (nonatomic, strong) UIImageView *pwdCheckImageView;

@property (nonatomic, strong) UILabel *confirmTitleLabel;

@property (nonatomic, strong) UITextField *confirmTextField;

@property (nonatomic, strong) UIButton *confirmSwitchButton;

@property (nonatomic, strong) UIImageView *confirmCheckImageView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *submitButton;

@end
