//
//  AfterSaleViewController.m
//  supor
//
//  Created by 赵冰冰 on 2017/5/12.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "AfterSaleViewController.h"

@interface AfterSaleViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *afterSaleWebView;

@end

@implementation AfterSaleViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self.view addSubview:self.afterSaleWebView];
    [self dcpRequestExternalUrl];
}

#pragma mark - Common Methods
- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_aftersalesservicenetwork_text");
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - Private Methods
- (void)dcpRequestExternalUrl {
    ACMsg *msg = [ACMsg msgWithName:[NSString stringWithFormat:@"dcp-syncContent"]];
    NSString *contentType = [@"sync" stringByAppendingString:@"ExternalUrl"];
    
    [msg put:@"contentType" value:contentType];
    [msg put:@"lang" value:[DCPServiceUtils getLanguage]];
    [msg put:@"dcpToken" value:[DCPServiceUtils getDcpToken]];
    [msg put:@"dcpUid" value:[DCPServiceUtils getDcpUid]];
    [msg put:@"market" value:[DCPServiceUtils getMarket]];
    WEAKSELF(ws);
    [DCPServiceUtils sendToDCPService:msg callback:^(ACMsg *responseMsg, NSError *error) {
        if (error) {
            return;
        }
        
        NSArray * array  = [[[responseMsg get:@"content"] getObjectData] objectForKey:@"objects"];
        NSDictionary *dictionary = array[0];
        NSString *urlString = dictionary[@"externalLink"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws.afterSaleWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
        });
    }];
}

#pragma mark - Lazyload Methods
- (UIWebView *)afterSaleWebView {
    if (!_afterSaleWebView) {
        _afterSaleWebView = [[UIWebView alloc] init];
        _afterSaleWebView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _afterSaleWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _afterSaleWebView;
}

#pragma mark - System Methods
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.afterSaleWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

@end
