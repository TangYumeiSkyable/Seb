//
//  ACFAQLeafController.m
//  supor
//
//  Created by Jun Zhou on 2018/3/5.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "ACFAQLeafController.h"
#import "UINavigationBar+FlatUI.h"
#import "ACFAQLeafCell.h"

@interface ACFAQLeafController ()

@property (strong, nonatomic) UIView *safeAreaView;

@property (strong, nonatomic) NSString *contentString;

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation ACFAQLeafController


// MARK: - getter

- (UIView *)safeAreaView {
    if (_safeAreaView == nil) {
        _safeAreaView = [[UIView alloc] init];
    }
    return _safeAreaView;
}



- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

// MARK: - view lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self setupSubViews];
    
    if (self.dataSourceDic.count != 0) {
        NSArray *array = self.dataSourceDic[@"sonContents"];
        NSDictionary *dictionary = array[0];
        
        [self.webView loadHTMLString:dictionary[@"body"]  baseURL:nil];
    }
}


// MARK: - config UI

- (void)configUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.dataSourceDic.count != 0) {
        self.navigationItem.title = self.dataSourceDic[@"title"];
    }
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor classics_blue]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
}

// MARK: - setup subviews

- (void)setupSubViews {
    [self.view addSubview:self.safeAreaView];
    [self.safeAreaView addSubview:self.webView];
}

// MARK: - layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    WEAKSELF(ws);
    [ws.safeAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(DeviceUtils.navigationStatusBarHeight);
        make.left.equalTo(ws.view);
        make.bottom.equalTo(ws.view).offset(-DeviceUtils.bottomSafeHeight);
        make.right.equalTo(ws.view);
    }];

    
    [ws.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.safeAreaView);
    }];
}


// MARK: - request


@end
