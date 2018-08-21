//
//  MoreHeaderView.h
//  supor
//
//  Created by 刘杰 on 2018/5/3.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHMoreButton.h"

@interface MoreHeaderView : UIView

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIButton *avatarButton;

@property (nonatomic, strong) UILabel *accountLabel;

@property (nonatomic, strong) RHMoreButton *schedulingButton;

@property (nonatomic, strong) RHMoreButton *messageButton;

@end
