//
//  ContentCollectionViewCell.h
//  supor
//
//  Created by 刘杰 on 2018/3/26.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *contentTextLabel;

@property (nonatomic, strong) UITextView *opinionTextView;

@end
