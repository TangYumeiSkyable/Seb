//
//  PersonalDataViewController.m
//  supor
//
//  Created by 白云杰 on 2017/5/22.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "NSString+LKExtension.h"

@interface PersonalDataViewController ()

@property (strong, nonatomic) UIWebView *webView;

@property (strong, nonatomic) UIView *safeAreaView;

@end

@implementation PersonalDataViewController

// MARK: - Lazyload Methods
- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

- (UIView *)safeAreaView {
    if (_safeAreaView == nil) {
        _safeAreaView = [[UIView alloc] init];
    }
    return _safeAreaView;
}

// MARK: - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
    [self setupSubViews];
    [self requestData];
}

// MARK: - config UI
- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
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
        make.top.equalTo(ws.view);
        make.left.equalTo(ws.view);
        make.bottom.equalTo(ws.view).offset(-DeviceUtils.bottomSafeHeight);
        make.right.equalTo(ws.view);
    }];
    
    
    [ws.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.safeAreaView);
    }];
}

- (void)requestData {
    DCPServiceContentType type;
    switch (_requestType) {
        case PersonalRequestDataType:
            type = DCPServiceContentPersonalData;
            self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_personaldata_text");
            break;
        case PersonalRequestLegalNoticeType:
            type = DCPServiceContentTypeLegalNotice;
            self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_legalnotice_text");
            break;
        case PersonalRequestTermOfUseType:
            type = DCPServiceContentTypeTermOfUse;
            self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_termsofuse_text");
            break;
        default:
            break;
    }
    
    WEAKSELF(ws);
    [DCPServiceUtils syncContent:type callback:^(ACMsg *responseMsg, NSError *error) {
        
        @try {
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
