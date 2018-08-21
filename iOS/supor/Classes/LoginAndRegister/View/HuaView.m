//
//  HuaView.m
//  supor
//
//  Created by huayiyang on 16/6/28.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "HuaView.h"
#define kWidth self.frame.size.width
#define kHeight self.frame.size.height

@interface HuaView ()

@end

@implementation HuaView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight/5*3)];
        self.label.textAlignment  = NSTextAlignmentCenter;
        [self addSubview:self.label];
        
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0,self.label.frame.origin.y+ self.label.frame.size.height, kWidth, 1)];
        view1.backgroundColor = [UIColor colorWithRed:0.922 green:0.922 blue:0.922 alpha:1.00];
        [self addSubview:view1];
        
        self.quButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.quButton.frame = CGRectMake(0, view1.frame.origin.y+view1.frame.size.height, (kWidth-2)/2, kHeight-(view1.frame.origin.y+view1.frame.size.height));
        [self.quButton setTitle:GetLocalResStr(@"airpurifier_public_cancel") forState:UIControlStateNormal];
        
        [self.quButton setTitleColor:[UIColor classics_blue] forState:UIControlStateNormal];
        self.quButton.backgroundColor = [UIColor clearColor];
        [self addSubview:self.quButton];
        
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(self.quButton.frame.origin.x+self.quButton.frame.size.width, self.quButton.frame.origin.y, 1, self.quButton.frame.size.height)];
        view2.backgroundColor = [UIColor colorWithRed:0.922 green:0.922 blue:0.922 alpha:1.00];
        [self addSubview:view2];
        
        self.quedingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.quedingButton.frame = CGRectMake(view2.frame.origin.x+view2.frame.size.width, self.quButton.frame.origin.y, self.quButton.frame.size.width, self.quButton.frame.size.height);
        [self.quedingButton setTitle:GetLocalResStr(@"airpurifier_public_ok") forState:UIControlStateNormal];
        
        [self.quedingButton setTitleColor:[UIColor classics_blue] forState:UIControlStateNormal];
        self.quedingButton.backgroundColor = [UIColor clearColor];
        [self addSubview:self.quedingButton];
    }
    
    return self;
}

@end
