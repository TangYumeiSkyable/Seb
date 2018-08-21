//
//  SUIScrollView.m
//  supor
//
//  Created by 白云杰 on 2017/6/23.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "SUIScrollView.h"

@implementation SUIScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 判断 otherGestureRecognizer 是不是系统 POP 手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 判断 POP 手势的状态是 begin 还是 fail，同时判断 scrollView 的 ContentOffset.x 是不是在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}

@end
