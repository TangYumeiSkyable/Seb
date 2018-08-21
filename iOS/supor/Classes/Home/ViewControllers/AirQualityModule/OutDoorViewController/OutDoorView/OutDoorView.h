//
//  OutDoorView.h
//  supor
//
//  Created by 刘杰 on 2018/3/24.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQITypeTableViewCell.h"

static NSString  *const typeCellIdentifier = @"typeCell";

@interface OutDoorView : UIView

@property (nonatomic, strong) UIButton *selectCityButton;

@property (nonatomic, strong) UILabel *unitLabel;

@property (nonatomic, strong) UITableView *airQualityIndexTableView;

@property (nonatomic, strong) UIView *levelBackgroundView;

@property (nonatomic, strong) UIImageView *airLevelImageView;

@property (nonatomic, strong) UILabel *airLevelLabel;

@property (nonatomic, strong) UILabel *AQITypeTitleLabel;

@property (nonatomic, strong) UITextView *AQITypeDescriptionTextView;

@end
