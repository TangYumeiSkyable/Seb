//
//  RHBaseWebVC.h
//  supor
//
//  Created by 赵冰冰 on 16/6/29.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "UIWebView+Category.h"

@interface RHBaseWebVC : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, strong) JSContext * jsContext;

- (void)registerMsgName:(NSString *)msgName selector:(SEL)selector observer:(id)observer;

- (void)registerMsgName:(NSString *)msgName selector:(SEL)selector;

@end

@interface RHBaseWebVC (Category)

- (NSString *)jsonStringWithObject:(id)object;

- (NSURL *)nameWithUrl:(NSString *)url;

- (void)setupNotify;

@end
