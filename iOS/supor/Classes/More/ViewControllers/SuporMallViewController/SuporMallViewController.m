//
//  SuporMallViewController.m
//  supor
//
//  Created by 赵冰冰 on 16/9/2.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "SuporMallViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "AppDelegate.h"

@interface SuporMallViewController ()

@end

@implementation SuporMallViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self queryMallURL];
    self.webView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - Common Methods
- (void)configUI {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0);
    [btn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    BTN_ADDTARGET(btn, @selector(back));
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = left;
}

#pragma mark - Private Methods
- (void)queryMallURL {
    [SVProgressHUD show];
    [DCPServiceUtils syncContent:DCPServiceContentApplianceShop callback:^(ACMsg *responseMsg, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            
        } else {
            NSArray *tempArray  = [[[responseMsg get:@"content"] getObjectData] objectForKey:@"objects"];
            if (tempArray.count > 0) {
                NSDictionary *infoDic = tempArray[0];
                NSString *mallURLString = infoDic[@"externalLink"];
                NSString *titleString = infoDic[@"title"];
                self.title = titleString;
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mallURLString]]];
            }
        }
    }];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

#pragma mark - Target Action
- (void)back {
    if (self.fromType == 1) {
        AppDelegate *app = [AppDelegate sharedInstance];
        UINavigationController *nc = (UINavigationController *)app.window.rootViewController;
        [nc dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
