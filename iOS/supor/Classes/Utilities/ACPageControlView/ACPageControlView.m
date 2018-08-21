//
//  ACPageControlView.m
//  supor
//
//  Created by Jun Zhou on 2017/11/15.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "ACPageControlView.h"

static CGFloat DotWitdth = 8;
static CGFloat DotMargin = 10;

@interface ACPageControlView ()

@property (strong, nonatomic) NSMutableArray<UIButton *> *buttonDotArray;

@property (assign, nonatomic) NSInteger pageControlNum;

@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation ACPageControlView

// MARK: - getter

- (NSMutableArray<UIButton *> *)buttonDotArray {
    if (_buttonDotArray == nil) {
        _buttonDotArray = @[].mutableCopy;
    }
    return _buttonDotArray;
}

// MARK: - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setupControlDotNum:self.pageControlNum currentPage:self.currentPage];
}

// MARK: - init

- (instancetype)initWithPageControlNum:(NSInteger)num currentPage:(NSInteger)currentPage {
    
    if (self = [super init]) {
        self.pageControlNum = num;
        self.currentPage = currentPage;        
        if (num <= 0) num = 6;
        for (NSInteger i = 0; i < num; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.layer.cornerRadius = DotWitdth * 0.5;
            button.layer.masksToBounds = YES;
            [self.buttonDotArray addObject:button];
            [self addSubview:button];
        }
    }
    return self;
}


// MARK: - fill data

- (void)setupControlDotNum:(NSInteger)num currentPage:(NSInteger)currentPage {
    
    WEAKSELF(ws);
    CGFloat leftMargin = (DeviceUtils.screenWidth - DotWitdth * num - DotMargin * (num - 1)) * 0.5;
    [ws.buttonDotArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(DotWitdth);
            make.left.mas_equalTo(leftMargin + (DotWitdth + DotMargin) * idx);
            make.centerY.equalTo(self);
        }];
        
        obj.backgroundColor = (idx <= currentPage ? [UIColor classics_blue] : [UIColor classics_gray]);
    }];
}

@end
