//
//  ACContactUsController.m
//  supor
//
//  Created by Jun Zhou on 2018/3/2.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "ACContactUsController.h"
#import "UINavigationBar+FlatUI.h"

static NSString * const testContentString = @"<p>Service Consommateurs ROWENTA</p>\n\n<p>TSA 92002</p>\n\n<p>69134 Ecully Cedex</p>\n\n<p>Tel. 09 74 50 36 23 from Monday to Friday 9:00 to 19:00</p>\n\n<p>applications.seb@groupeseb.com</p>\n\n<p>&nbsp;</p>\n";

static NSString * const testHotlineString = @"09 74 50 36 23";

@interface ACContactUsController ()

@property (strong, nonatomic) UIView *safeAreaView;

@property (strong, nonatomic) NSString *hotlineString;

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation ACContactUsController

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
    [self dcpRequestAfterSales];
}

// MARK: - Private Methods
- (NSString *)htmlEntityDecode:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    string = [string stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    return string;
}

// MARK: - Common Methods

- (void)configUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_contact_us");
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor classics_blue]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
}

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

- (void)dcpRequestAfterSales {
    ACMsg *msg = [ACMsg msgWithName:[NSString stringWithFormat:@"dcp-syncContent"]];
    NSString *contentType = @"sync";
    contentType = [contentType stringByAppendingString:@"AfterSales"];
    
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
        NSDictionary *dict = array[0];
        [ws dcpRequestHotlineWithHTMLString:dict[@"body"]];
    }];
}

- (void)dcpRequestHotlineWithHTMLString:(NSString *)htmlString {
    ACMsg *msg = [ACMsg msgWithName:[NSString stringWithFormat:@"dcp-syncContent"]];
    NSString *contentType = @"sync";
    contentType = [contentType stringByAppendingString:@"HotLine"];
    
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
        NSDictionary * dict = array[0];
        NSString * contentString = dict[@"body"];
        ws.hotlineString = [ws htmlEntityDecode:contentString];
        ws.hotlineString = [ws.hotlineString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSString *finalString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<p>%@</p>",ws.hotlineString]];
        
        [ws.webView loadHTMLString:finalString  baseURL:nil];
    }];
}

@end
