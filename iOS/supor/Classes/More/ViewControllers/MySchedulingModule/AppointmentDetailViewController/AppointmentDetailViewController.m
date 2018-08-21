//
//  AppointmentDetailViewController.m
//  supor
//
//  Created by 赵冰冰 on 16/7/1.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "AppointmentDetailViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "JSWorkTimeModel.h"
#import "JSTimerModel.h"

@interface AppointmentDetailViewController ()

@property (nonatomic, strong) NSString *localizableJSString;

@end

@implementation AppointmentDetailViewController

#pragma mark - View LifeCycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [self nameWithUrl:@"repeat"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self refreshWeekNavigationItem];
}

#pragma mark - Private Methods
- (void)refreshWeekNavigationItem {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0);
    [btn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    BTN_ADDTARGET(btn, @selector(checkWeekSelectAction));
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Target Action Method
- (void)checkWeekSelectAction {
    [self.webView stringByEvaluatingJavaScriptFromString:@"get_week()"];
}

-(void)updateTimerNotification:(NSNotification *)notify {
    NSArray *arr = notify.object;
    NSString *week = arr[0];
    NSString *repeat = arr[1];
    if (self.delegate && [self.delegate respondsToSelector:@selector(week:repeat:)]) {
        [self.delegate week:week repeat:repeat];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)setupNotify {
    [self registerMsgName:NOTIFY_SET_TIME selector:@selector(updateTimerNotification:)];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_repeatsetting_tex");
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSTimerModel *model = [[JSTimerModel alloc] init];
    self.jsContext[@"timer"] = model;
    model.jsContext = self.jsContext;
    model.webView = self.webView;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        RHLog(@"exception message ：%@",exceptionValue);
    };
    
    if (isExist(self.repeat)) {
        NSString * js = [NSString stringWithFormat:@"setValue('%@')", self.repeat];
        [self.webView stringByEvaluatingJavaScriptFromString:js];
    }
    [self.webView stringByEvaluatingJavaScriptFromString:self.localizableJSString];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
}

#pragma mark - Lazy Methods
- (NSString *)localizableJSString {
    if (!_localizableJSString) {
        _localizableJSString = [NSString stringWithFormat:@"setLabelIos('{\"sunday_word\":\"%@\", \"monday_word\":\"%@\", \"tuesday_word\":\"%@\", \"wednesday_word\":\"%@\", \"thursday_word\":\"%@\", \"friday_word\":\"%@\", \"saturday_word\":\"%@\", \"once_word\":\"%@\"}')", GetLocalResStr(@"airpurifier_more_show_sundayword_text"), GetLocalResStr(@"airpurifier_more_show_mondayword_text"), GetLocalResStr(@"airpurifier_more_show_tuesdayword_text"), GetLocalResStr(@"airpurifier_more_show_wednesdayword_text"), GetLocalResStr(@"airpurifier_more_show_thursdayword_text"), GetLocalResStr(@"airpurifier_more_show_fridayword_text"),
                                GetLocalResStr(@"airpurifier_more_show_saturdayword_text"), GetLocalResStr(@"airpurifier_more_show_onceword_tex")];
    }
    return _localizableJSString;
}

@end
