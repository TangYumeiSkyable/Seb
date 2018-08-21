//
//  UIView+Category.m
//  
//
//  Created by Jun on 2017/7/11.
//  Copyright © 2017年 ZHJ. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

- (void)setX:(CGFloat)x {
    
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = x;
    self.frame = tempFrame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}


- (void)setY:(CGFloat)y {
    
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = y;
    self.frame = tempFrame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}


- (void)setWidth:(CGFloat)width {
    
    CGRect tempFrame = self.frame;
    tempFrame.size.width = width;
    self.frame = tempFrame;
}

- (CGFloat)width {
    return self.frame.size.width;
}


- (void)setHeight:(CGFloat)height {
    
    CGRect tempFrame = self.frame;
    tempFrame.size.height = height;
    self.frame = tempFrame;
}

- (CGFloat)height {
    return self.frame.size.height;
    
}


- (void)setOrigin:(CGPoint)origin {
    
    CGRect tempFrame = self.frame;
    tempFrame.origin = origin;
    self.frame = tempFrame;
}

- (CGPoint)origin {
    return self.frame.origin;
}


- (void)setSize:(CGSize)size {
    
    CGRect tempFrame = self.frame;
    tempFrame.size = size;
    self.frame = tempFrame;
}

- (CGSize)size {
    return self.frame.size;
}


- (void)setTop:(CGFloat)top {
    
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = top;
    self.frame = tempFrame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}


- (void)setLeft:(CGFloat)left {
    
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = left;
    self.frame = tempFrame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}


- (void)setBottom:(CGFloat)bottom {
    
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = bottom - self.frame.size.height;
    self.frame = tempFrame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


- (void)setRight:(CGFloat)right {
    
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = right - tempFrame.size.width;
    self.frame = tempFrame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerX {
    return self.center.x;
}


- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)centerY {
    return self.center.y;
}


- (CGFloat)screenCoordinateX {
    
    CGFloat x = 0.0f;
    for (UIView *view = self; view; view = view.superview) {
        
        x += view.left;
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            x -= scrollView.contentOffset.x;
        }
    }
    return x;
}

- (CGFloat)screenCoordinateY {
    
    CGFloat y = 0;
    for (UIView *view = self; view; view = view.superview) {
        
        y += view.top;
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}

- (CGRect)screenCoordinateFrame {
    return CGRectMake(self.screenCoordinateX, self.screenCoordinateY, self.width, self.height);
}


- (BOOL)isShowingOnKeyWindow {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}


- (UIViewController *)viewController {
    UIViewController *viewController = nil;
    UIResponder *next = self.nextResponder;
    while (next) {
        if ([next isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController *)next;
            break;
        }
        next = next.nextResponder;
    }
    return viewController;
}


@end
