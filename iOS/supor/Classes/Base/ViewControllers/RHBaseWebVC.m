//
//  RHBaseWebVC.m
//  supor
//
//  Created by 赵冰冰 on 16/6/29.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHBaseWebVC.h"
#import "UINavigationBar+FlatUI.h"

@interface RHBaseWebVC ()

@end

@implementation RHBaseWebVC

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        if ([self respondsToSelector:@selector(setupNotify)]) {
            [self performSelector:@selector(setupNotify) withObject:nil];
        }
    }
    return self;
}

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    
    WEAKSELF(ws);
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self preferredStatusBarStyle];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor classics_blue]];
}

#pragma mark - Private Method
- (void)registerMsgName:(NSString *)msgName selector:(SEL)selector {
    [self registerMsgName:msgName selector:selector observer:self];
}

- (void)registerMsgName:(NSString *)msgName selector:(SEL)selector observer:(id)observer {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:msgName object:nil];
}

- (NSURL *)nameWithUrl:(NSString *)url {
    NSURL *murl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:url ofType:@"html" inDirectory:@"assets"]];
    return murl;
}

- (NSString*)jsonStringWithObject:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

#pragma mark - LazyLoad Method
- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [UIWebView new];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.webView.delegate = nil;
    [self.webView stopLoading];
    self.webView = nil;
}

@end
