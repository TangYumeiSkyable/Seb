//
//  JNavigationView.h
//  supor
//
//  Created by 赵冰冰 on 2017/5/10.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JNavigationDelegate <NSObject>

- (void)didSelectAtIndex:(NSInteger)index;

@end

@interface JNavigationView : UIView

@property (nonatomic, weak) id<JNavigationDelegate> delegate;

- (UIImageView *)more;

@end
