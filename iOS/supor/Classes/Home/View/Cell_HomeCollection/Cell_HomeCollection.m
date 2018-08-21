//
//  Cell_HomeCollection.m
//  supor
//
//  Created by 赵冰冰 on 16/6/27.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "Cell_HomeCollection.h"
#import "RHHomeView.h"

@implementation Cell_HomeCollection

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        RHHomeView *homeView = [RHHomeView new];
        [self.contentView addSubview:homeView];
        self.homeView = homeView;
        [homeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}

@end
