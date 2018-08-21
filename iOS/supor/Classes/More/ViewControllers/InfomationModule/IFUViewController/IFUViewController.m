//
//  IFUViewController.m
//  supor
//
//  Created by 白云杰 on 2017/5/22.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "IFUViewController.h"
#import "NSString+LKExtension.h"

@interface IFUViewController ()


@property (strong, nonatomic) UIWebView *webView;

@property (strong, nonatomic) UIView *safeAreaView;

@end

@implementation IFUViewController


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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self setupSubViews];
    [self requestData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

// MARK: - config UI

- (void)configUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_theifuofproduct_text");
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

- (void)requestData {
    WEAKSELF(ws);
    
    [SVProgressHUD show];
    [DCPServiceUtils syncContent:DCPServiceContentManual callback:^(ACMsg *responseMsg, NSError *error) {
        @try {
            [SVProgressHUD dismiss];
            if (error == nil) {
                NSArray * array  = [[[responseMsg get:@"content"] getObjectData] objectForKey:@"objects"];
                NSDictionary * dict = array[0];
                [ws.webView loadHTMLString:dict[@"body"]  baseURL:nil];
            } else {
                [ZSVProgressHUD showErrorWithStatus:@"Request fail"];
            }
            
        } @catch (NSException *exception) {
        } @finally {
        }
    }];
}

@end
