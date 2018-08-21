//
//  UIView+Nib.h
//  RHYadu
//
//  Created by 赵冰冰 on 2017/4/20.
//  Copyright © 2017年 RiHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Nib)

+ (UINib *)loadNib;
+ (UINib *)loadNibNamed:(NSString *)nibName;
+ (UINib *)loadNibNamed:(NSString *)nibName bludle:(NSBundle *)bundle;
//直接获取xib关联的view
+ (instancetype)loadInstnceFromNib;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle;
@end
