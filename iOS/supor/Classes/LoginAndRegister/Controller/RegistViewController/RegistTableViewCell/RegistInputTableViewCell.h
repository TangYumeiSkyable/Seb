//
//  RegistTableViewCell.h
//  supor
//
//  Created by Ennnnnn7 on 2018/5/14.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CiphetSwitchBlock)(UIButton *button, UITextField *textField);

@interface RegistInputTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextField *inputTextField;

@property (nonatomic, strong) UIImageView *checkImageView;

@property (nonatomic, strong) UIButton *ciphetSwitchButton;

@property (nonatomic, copy) CiphetSwitchBlock ciphetSwitchBlock;

@end
