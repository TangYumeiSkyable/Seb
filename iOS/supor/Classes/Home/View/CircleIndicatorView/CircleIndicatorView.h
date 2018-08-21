//
//  CircleIndicatorView.h
//  supor
//
//  Created by 赵冰冰 on 2017/5/11.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHHomeItem.h"

@interface CircleIndicatorView : UIView

@property (nonatomic,strong) RHHomeItem *item;
@property (nonatomic, assign) CGFloat precent;
@property (nonatomic, assign) NSInteger hcho;
@property (nonatomic, assign) NSInteger pm25_level;
-(void)refreshWithTVOC:(NSInteger)tvoc;
-(UIImageView *)tvoc;
//- (void)setPrecentText:(RHHomeItem *)item;

@end
