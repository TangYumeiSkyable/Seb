//
//  RHMoreButton.m
//  supor
//
//  Created by 赵冰冰 on 2017/5/15.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "RHMoreButton.h"

@implementation RHMoreButton
{
    UIView * _line;
    UIView  * _bage;
}

#pragma mark - Init Method
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self createUI];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor classics_blue] forState:UIControlStateHighlighted];
    self.titleLabel.font = [UIFont fontWithName:Regular size:13];
    
    UIView * line = [UIView new];
    [self addSubview:line];
    line.backgroundColor = [UIColor classics_blue];
    line.hidden = YES;
    _line = line;
    
    UIView * bage = [UIView new];
    bage.backgroundColor = [UIColor redColor];
    bage.frame = CGRectMake(0, 0, 6, 6);
    RHBorderRadius(bage, 3, 0.1, [UIColor redColor]);
    bage.hidden = YES;
    _bage = bage;
    [self addSubview:bage];
}

#pragma mark - Public Methods
- (UIView *)bottomLine {
    return _line;
}

- (void)setBageOn:(BOOL)bageOn {
    _bage.hidden = !bageOn;
    _bageOn = bageOn;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect frame = CGRectMake(15 + 25 + 10, contentRect.size.height / 2 - 15,  contentRect.size.width -  (15 + 25 + 10) , 30);
    return frame;
}

#pragma mark - Touch Action
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect frame = CGRectMake(15, contentRect.size.height / 2 - 25.0 / 2, 25, 25);
    _bage.frame = CGRectMake(CGRectGetMaxX(frame), CGRectGetMinY(frame), 6, 6);
    return frame;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    _line.hidden = NO;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, point)) {
        _line.hidden = NO;
    }else{
        _line.hidden = YES;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    _line.hidden = YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    _line.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(4);
    }];
    
}

@end
