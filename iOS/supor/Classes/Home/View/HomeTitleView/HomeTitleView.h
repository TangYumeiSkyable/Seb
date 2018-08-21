//
//  HomeTitleView.h
//  supor
//
//  Created by 赵冰冰 on 16/6/20.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTitleView : UIView

@property (nonatomic, strong) UILabel * gradeLbl;
@property (nonatomic, strong) UILabel * pmLbl;
@property (nonatomic, strong) UILabel * scoreLbl;

-(void)refreshGradeLbl:(NSString *)grade pmLbl:(NSString *)pm scroe:(NSString *)score;

@end
