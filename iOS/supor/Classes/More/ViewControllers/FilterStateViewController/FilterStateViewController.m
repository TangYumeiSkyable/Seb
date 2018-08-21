//
//  FilterStateViewController.m
//  supor
//
//  Created by 赵冰冰 on 16/6/30.
//  Copyright © 2016年 XYJ. All rights reserved.
//
#define SUPOR_URL @"http://small.supor.com/?from=singlemessage&isappinstalled=0"
#import "FilterStateViewController.h"
#import "SuporMallViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "AppDelegate.h"
#import "JSGotoSuporModel.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface FilterStateViewController ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation FilterStateViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self requestAllFilterStatus];
    [self loadWebView];
}

#pragma mark - Private Methods
- (void)configUI {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.fd_prefersNavigationBarHidden = NO;
}

- (void)requestAllFilterStatus {
    AppDelegate * app = [AppDelegate sharedInstance];
    
    NSMutableArray * arrayM = [NSMutableArray array];
    
    for (ACUserDevice *device in app.deviceList) {
        ACObject *object = [[ACObject alloc] init];
        [object putLongLong:@"deviceId" value:device.deviceId];
        [arrayM addObject:object];
    }
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD show];
    
    WEAKSELF(ws);
    [http_ requestWithMessageName:@"queryAllFilterStatus" callback:^(ACMsg *responseObject, NSError *error) {
        if (error) {
            RHLog(@"err");
            [ZSVProgressHUD showErrorWithStatus:TIPS_REQUEST_ERROR];
        } else {
            
            [SVProgressHUD dismiss];
            NSDictionary *data = [responseObject getObjectData];
            NSArray *array = [data objectForKey:@"actionData"];
            
            NSMutableArray *arrayM = [NSMutableArray array];
            
            for (NSDictionary *dict in array) {
                NSMutableDictionary * mDict = [[NSMutableDictionary alloc] init];
                [mDict addEntriesFromDictionary:dict];
                for (ACUserDevice *device in app.deviceList) {
                    
                    if (device.deviceId == [dict[@"deviceId"] integerValue]) {
                        NSDictionary *dic = @{@"deviceName" : device.deviceName};
                        [mDict addEntriesFromDictionary:dic];
                        break;
                    }
                }
                [arrayM addObject:mDict];
            }
            
            [ws.datas removeAllObjects];
            [ws.datas addObjectsFromArray:arrayM];
            [ws loadWebView];
        }
    } andKeyValues:@"deviceList", arrayM, nil];
}

- (void)loadWebView {
    NSURL *url = [self nameWithUrl:@"filterstate"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSGotoSuporModel *model  = [[JSGotoSuporModel alloc] init];
    self.jsContext[@"filter"] = model;
    model.jsContext = self.jsContext;
    model.webView = self.webView;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        RHLog(@"exception message：%@", exceptionValue);
    };
    
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_filtercondition_tex");
    
    NSString *jsWord = [NSString stringWithFormat:@"setLabelIos('{\"filter_condition\":\"%@\", \"pre_filter\":\"%@\", \"active_filter\":\"%@\", \"hepa_filter\":\"%@\", \"nano_filter\":\"%@\", \"over_plus\":\"%@\", \"change_filter\":\"%@\", \"check_color\":\"%@\", \"to_buy\":\"%@\", \"clean_filter\":\"%@\"}')", GetLocalResStr(@"airpurifier_more_show_filtercondition_tex"), GetLocalResStr(@"airpurifier_more_show_prefilter_tex"), GetLocalResStr(@"airpurifier_more_show_activefilter_tex"), GetLocalResStr(@"airpurifier_more_show_hepafilter_tex"), GetLocalResStr(@"airpurifier_more_show_nanofilter_tex"), GetLocalResStr(@"airpurifier_more_show_overplus_tex"),
                        GetLocalResStr(@"airpurifier_more_show_change_filter_ios"), GetLocalResStr(@"airpurifier_more_show_check_color_ios"), GetLocalResStr(@"airpurifier_more_show_tobuy_tex"), GetLocalResStr(@"airpurifier_more_cleanfilter_tex")];
    
    [self.webView stringByEvaluatingJavaScriptFromString:jsWord];
    
    NSString * js = [NSString stringWithFormat:@"setValueIos('%@')", [self.datas mj_JSONString]];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    if ([webView.request.URL.absoluteString containsString:SUPOR_URL]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - Lazyload Methods
- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

#pragma mark - Target Action
- (void)gotoSupor:(NSNotification *)noti {
    SuporMallViewController * mallVC = [[SuporMallViewController alloc] init];
    [self.navigationController pushViewController:mallVC animated:YES];
}
// regist JS notify
-(void)setupNotify {
    [self registerMsgName:NOTIFY_GOTOSUPOR selector:@selector(gotoSupor:)];
}
@end
