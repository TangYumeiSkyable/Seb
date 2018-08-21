//
//  PopAnimator.m
//  ViewControllersTransition
//
//  Created by YouXianMing on 15/7/21.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import "PopAnimation.h"

@implementation PopAnimation

- (void)animateTransitionEvent {

    [self.containerView addSubview:self.toViewController.view];
    
    self.toViewController.view.alpha   = 0.f;
    
    [UIView animateWithDuration:self.transitionDuration
                          delay:0.0f
         usingSpringWithDamping:1 initialSpringVelocity:0.f options:0 animations:^{
             
             self.fromViewController.view.alpha = 0.f;
             self.toViewController.view.alpha   = 1.f;
             
         } completion:^(BOOL finished) {
             
             [self completeTransition];
         }];
}

@end
