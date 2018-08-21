//
//  RHBrezzeView.m
//  supor
//
//  Created by 赵冰冰 on 16/6/27.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHBrezzeView.h"
#import "BrezzeSpeenButton.h"
#import "UIView+WhenTappedBlocks.h"
#import "RHHomeView.h"
@interface RHBrezzeView ()<CAAnimationDelegate>
{
    CGPoint start;
}
@property (nonatomic, assign) BOOL showing;
@property (nonatomic, assign) CGRect mFrame;
@property (nonatomic, strong) UIView * coverView;

@property (nonatomic, strong) NSArray * array1;
@property (nonatomic, strong) NSArray * array2;
@property (nonatomic, strong) NSArray * array3;
@property (nonatomic, strong) NSArray * array5;

@property (nonatomic, strong) BrezzeSpeenButton * btn;
@end
@implementation RHBrezzeView

-(UIView *)coverView
{
    if (_coverView == nil) {
        _coverView = [UIView new];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDismiss:)];
        _coverView.userInteractionEnabled = YES;
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

-(void)tapDismiss:(UITapGestureRecognizer *)tap
{

    CGPoint point = [tap locationInView:self.coverView];
    point = [self.coverView convertPoint:point toView:self.superview];
    CGRect frame = [self.brezzeBtn.superview convertRect:self.brezzeBtn.frame toView:self.superview];
    frame.origin.x -=5;
    frame.size.width += 10;
    frame.size.height += 6;
    frame.origin.y -= 3;

    if (CGRectContainsPoint(frame, point)) {
        [self btnClicked:self.brezzeBtn];
    }else{
        [self dismiss];
    }
   
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        self.mFrame = frame;
        //扇叶 蓝色
        NSArray * array1 = @[@"极速.png", @"高速.png" , @"中速.png", @"低速.jpg"];
        //扇叶 灰色
        NSArray * array2 = @[@"扇叶-极速-灰.png",  @"扇叶-高速-灰.png",@"扇叶-中速-灰.png",  @"扇叶-微风-灰.png"];
        //背景 蓝色
        NSArray * array3 = @[ @"极速bg.jpg" ,  @"高速bg.jpg", @"中速bg.jpg", @"微风风bg.jpg"];
        //背景 灰色
        NSArray * array5 = @[@"bg-极速-灰.png",  @"bg-高速-灰.png",@"bg-中速-灰.png",  @"bg-微风-灰.png"];
        self.array1 = array1;
        self.array2 = array2;
        self.array3 = array3;
        self.array5 = array5;
        WEAKSELF(ws);
        UIView * last = nil;
        for (NSInteger i = 0; i < 3; i++) {
            
            BrezzeSpeenButton * btn = [[BrezzeSpeenButton alloc]init];
            
            btn.tag = 100 + i;
            [btn setBackgroundImage:[UIImage imageNamed:array1[i]] forState:UIControlStateNormal];
            
            [btn setImage:[UIImage imageNamed:array3[i]] forState:UIControlStateNormal];
            [self addSubview:btn];
            
            if (last == nil) {
                
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.top.mas_equalTo(0);
                    make.left.and.right.mas_equalTo(ws);
                    make.height.mas_equalTo(btn.mas_width).multipliedBy(140 / 284.0);
                }];

                
            }else{
                
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(last.mas_bottom).with.offset(1).with.offset(- 4);
                    make.left.and.right.mas_equalTo(ws);
                    make.height.mas_equalTo(btn.mas_width).multipliedBy(140 / 284.0);
                }];
            }
            
            last = btn;
            
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
    }
    return self;
}

-(void)showAtPoint:(CGPoint)point
{
    self.showing = YES;
    [self coverView];
    WEAKSELF(ws);
    
    NSMutableArray * arr1 = [[NSMutableArray alloc]initWithArray:self.array1];
    NSMutableArray * arr2 = [[NSMutableArray alloc]initWithArray:self.array2];
    NSMutableArray * arr3 = [[NSMutableArray alloc]initWithArray:self.array3];
    NSMutableArray * arr4 = [[NSMutableArray alloc]initWithObjects:@4, @3, @2, @1, nil];
    NSMutableArray * arr5 = [[NSMutableArray alloc]initWithArray:self.array5];
    NSInteger index = self.brezzeBtn.brezze - 1;
    
    //先预防下脏数据
    if (index < 0) {
        index = 0;
    }
    
    [arr1 removeObjectAtIndex:3 - index];
    [arr2 removeObjectAtIndex:3 - index];
    [arr3 removeObjectAtIndex:3 - index];
    [arr4 removeObjectAtIndex:3 - index];
    [arr5 removeObjectAtIndex:3 - index];
    for (NSInteger i = 0; i < 3; i++) {
        
         BrezzeSpeenButton * btn = [self viewWithTag:100 + i];
        [btn setBackgroundImage:[UIImage imageNamed:arr5[i]] forState:UIControlStateNormal];
        btn.brezze = [arr4[i] integerValue];
        [btn setImage:[UIImage imageNamed:arr2[i]] forState:UIControlStateNormal];
    }
   
    [self.superview insertSubview:self.coverView belowSubview:self];
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws.superview);
    }];
    start = point;
    __block CGRect frame = CGRectMake(point.x, point.y - self.mFrame.size.height + 17, self.mFrame.size.width, self.mFrame.size.height);
    self.frame = frame;
    self.alpha = 0;
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.8 animations:^{
        
        self.alpha = 1;
        [self layoutIfNeeded];
        
    }];
    
    for (NSInteger i = -1; i < 3; i++) {
        
        CABasicAnimation *rotationAni = [CABasicAnimation animation];
        rotationAni.keyPath = @"transform.rotation";
        rotationAni.fromValue = @(0);
        rotationAni.toValue = @(M_PI * 2);
        rotationAni.duration = 0.8;
        rotationAni.delegate = self;
        UIButton * btn = nil;
        if (i == -1) {
            btn = self.brezzeBtn;
        }else{
            btn  = [self viewWithTag:100 + i];
        }
        [btn.imageView.layer addAnimation:rotationAni forKey:@"rotation"];
    }
}

-(void)close
{
    if (self.showing == YES) {
        self.showing = NO;
        
        [UIView animateWithDuration:0 animations:^{
            [self.coverView removeFromSuperview];
            self.alpha = 0;
        }];
        
        for (NSInteger i = -1; i < 3; i++) {
            
            CABasicAnimation *rotationAni = [CABasicAnimation animation];
            rotationAni.keyPath = @"transform.rotation";
            rotationAni.fromValue = @(0);
            rotationAni.toValue = @(-M_PI * 2);
            rotationAni.duration = 0.8;
            rotationAni.delegate = self;
            UIButton * btn = nil;
            if (i == -1) {
                btn = self.brezzeBtn;
            }else{
                btn  = [self viewWithTag:100 + i];
            }
            
            [btn.imageView.layer addAnimation:rotationAni forKey:@"rotation"];
        }
    }
}

-(void)dismiss
{
    if (self.showing == YES) {
      self.showing = NO;
        
        [UIView animateWithDuration:0.8 animations:^{
            [self.coverView removeFromSuperview];
            self.alpha = 0;
        }];
        
        for (NSInteger i = -1; i < 3; i++) {
           
            CABasicAnimation *rotationAni = [CABasicAnimation animation];
            rotationAni.keyPath = @"transform.rotation";
            rotationAni.fromValue = @(0);
            rotationAni.toValue = @(-M_PI * 2);
            rotationAni.duration = 0.8;
            rotationAni.delegate = self;
            UIButton * btn = nil;
            if (i == -1) {
                btn = self.brezzeBtn;
            }else{
               btn  = [self viewWithTag:100 + i];
            }
            
            [btn.imageView.layer addAnimation:rotationAni forKey:@"rotation"];
        }
    }
}

-(void)btnClicked:(BrezzeSpeenButton *)btn
{

    if (self.btn) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayCarryOn) object:self.btn];
    }
    self.btn = btn;
    //延迟2秒之后执行
    [self performSelector:@selector(delayCarryOn) withObject:btn afterDelay:0.0001];
    
   
}

-(void)delayCarryOn
{
    //先更换图片的位置
    
    self.brezzeBtn.brezze = self.btn.brezze;
    NSInteger index = self.brezzeBtn.brezze - 1;
    
    if (index < 0) {
        index = 0;
    }
    
    NSMutableArray * arrayM1 = [NSMutableArray arrayWithArray:self.array1];
    NSMutableArray * arrayM2 = [NSMutableArray arrayWithArray:self.array2];
    NSMutableArray * arrayM3 = [NSMutableArray arrayWithArray:self.array3];
    NSMutableArray * arrayM5 = [NSMutableArray arrayWithArray:self.array5];
    NSMutableArray * arrayM4 = [[NSMutableArray alloc]initWithObjects:@4, @3, @2, @1, nil];
    
    //是否是开关状态
    int isOpen = NO;
    for (NSString * str in self.array1) {
        
        UIImage * img = [UIImage imageNamed:str];
        
        if ([self.brezzeBtn.currentImage isEqual:img]) {
            isOpen = YES;
        }
    }
    
    [self.brezzeBtn setBackgroundImage:[UIImage imageNamed:arrayM1[3 - index]] forState:UIControlStateNormal];
    [self.brezzeBtn setImage:[UIImage imageNamed:arrayM3[3 - index]] forState:UIControlStateNormal];
    
    [arrayM1 removeObjectAtIndex:3 - index];
    [arrayM2 removeObjectAtIndex:3 - index];
    [arrayM3 removeObjectAtIndex:3 - index];
    [arrayM4 removeObjectAtIndex:3 - index];
    [arrayM5 removeObjectAtIndex:3 - index];
    for (NSInteger i = 0; i < 3; i++) {
        
        BrezzeSpeenButton * brezzeBtn = [self viewWithTag:100 + i];
        [brezzeBtn setBackgroundImage:[UIImage imageNamed:arrayM5[i]] forState:UIControlStateNormal];
        [brezzeBtn setImage:[UIImage imageNamed:arrayM2[i]] forState:UIControlStateNormal];
    }
    
    if (self.delegate&& [self.delegate respondsToSelector:@selector(brezzeClicked:)]) {
        [self.delegate brezzeClicked:self.btn];
    }
    [self dismiss];
}

@end
