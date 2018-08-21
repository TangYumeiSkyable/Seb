//
//  RHAgreementViewController.m
//  supor
//
//  Created by 赵冰冰 on 16/6/30.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHAgreementViewController.h"
#import "PersonalDataViewController.h"
#import "RegistViewController.h"
#import "UIWebView+Category.h"
#import "UINavigationBar+FlatUI.h"
#import "JSAgreementModel.h"
#import "AppDelegate.h"
#import "UIView+WhenTappedBlocks.h"

@interface RHAgreementViewController ()<UIWebViewDelegate>
{
    BOOL _selected;
}

@property (nonatomic, strong) UILabel *welcomeLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIWebView *agreementWebView;

@property (nonatomic, strong) UIImageView *checkImageView;

@property (nonatomic, strong) UILabel *checkNoticeLabel;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, assign) CGFloat HEIGHT;

@end

@implementation RHAgreementViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
    [self requestAgreementText];
    [self setupCheckImageAction];
}

#pragma mark - Common Methods
- (void)configUI {
    _HEIGHT = kMainScreenWidth > 375 ? 55 : 45;
    self.view.backgroundColor = RGB(242, 242, 242);
    self.navigationItem.title = GetLocalResStr(@"airpurifier_login_show_register_agreementtitle_text");
    self.navigationController.navigationBarHidden = NO;
    self.fd_prefersNavigationBarHidden = NO;
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor classics_blue]];
}

- (void)initViews {
    [self.view addSubview:self.welcomeLabel];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.agreementWebView];
    [self.view addSubview:self.checkImageView];
    [self.view addSubview:self.checkNoticeLabel];
    [self.view addSubview:self.confirmButton];
}

- (void)requestAgreementText {
    [DCPServiceUtils syncContent:DCPServiceContentTypeTermOfUse
                        callback:^(ACMsg *responseMsg, NSError *error) {
                            @try {
                                NSArray *array  = [[[responseMsg get:@"content"] getObjectData] objectForKey:@"objects"];
                                NSDictionary *dict = array[0];
                                NSString *agreement = dict[@"body"];
                                [self.agreementWebView loadHTMLString:agreement baseURL:nil];
                            } @catch (NSException *exception) {
                            } @finally {
                            }
    }];
}

- (void)setupCheckImageAction {
    WEAKSELF(weakSelf);
    _selected = NO;
    // check whether agreed the agreement
    [self.checkImageView whenTapped:^{
        _selected = !_selected;
        if (_selected) {
            [weakSelf.confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor classics_blue] cornerRadius:_HEIGHT / 2] forState:UIControlStateNormal];
            weakSelf.checkImageView.image = [UIImage imageNamed:@"ico_accept_sel"];
        }else{
            [weakSelf.confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor classics_gray] cornerRadius:_HEIGHT / 2] forState:UIControlStateNormal];
            weakSelf.checkImageView.image = [UIImage imageNamed:@"ico_accept_nor"];
        }
    }];
    
    [self.checkNoticeLabel whenTapped:^{
        PersonalDataViewController *personalVC = [[PersonalDataViewController alloc] init];
        personalVC.requestType = PersonalRequestDataType;
        [self.navigationController pushViewController:personalVC animated:YES];
    }];
}

#pragma mark - WebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *textJSString = @"document.body.style.fontFamily='pingFangSC-Regular';document.body.style.webkitTextSizeAdjust='80%';document.body.style.webkitTextFillColor= '#36424a'";
    [self.agreementWebView stringByEvaluatingJavaScriptFromString:textJSString];
}

#pragma mark - Target Action
- (void)confirmAction {
    if (!_selected) {
        return;
    }
    RegistViewController *registerVC = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
    return;
}

#pragma mark - Lazy Methods
- (UILabel *)welcomeLabel {
    if (!_welcomeLabel) {
        _welcomeLabel = [[UILabel alloc] init];
        _welcomeLabel.font = [UIFont fontWithName:Regular size:14];
        _welcomeLabel.textColor = LJHexColor(@"#848484");
        _welcomeLabel.text = GetLocalResStr(@"airpurifier_login_show_registerwelcome_text");
        _welcomeLabel.numberOfLines = 0;
        
        [_welcomeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_welcomeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired  forAxis:UILayoutConstraintAxisVertical];
    }
    return _welcomeLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:Regular size:18];
        _titleLabel.textColor = LJHexColor(@"#36424a");
        _titleLabel.text = GetLocalResStr(@"airpurifier_login_show_register_agreementtitle_text");
    }
    return _titleLabel;
}

- (UIWebView *)agreementWebView {
    if (!_agreementWebView) {
        _agreementWebView = [[UIWebView alloc] init];
        _agreementWebView.backgroundColor = RGB(242, 242, 242);
        _agreementWebView.opaque = NO;
        _agreementWebView.delegate = self;
    }
    return _agreementWebView;
}

- (UIImageView *)checkImageView {
    if (!_checkImageView) {
        _checkImageView = [UIImageView new];
        _checkImageView.image = [UIImage imageNamed:@"ico_accept_nor"];
    }
    return _checkImageView;
}

- (UILabel *)checkNoticeLabel {
    if (!_checkNoticeLabel) {
        _checkNoticeLabel = [UILabel new];
        _checkNoticeLabel.textColor = LJHexColor(@"#848484");
        _checkNoticeLabel.attributedText = [self configAgreementText];
        _checkNoticeLabel.numberOfLines = 0;
        _checkNoticeLabel.font = [UIFont fontWithName:Regular size:16];
        _checkNoticeLabel.userInteractionEnabled = YES;
    }
    return _checkNoticeLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:GetLocalResStr(@"airpurifier_login_show_registeracceptagreement_text") forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:Regular size:18];
        [_confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor classics_gray] cornerRadius:_HEIGHT / 2] forState:UIControlStateNormal];
        BTN_ADDTARGET(_confirmButton, @selector(confirmAction));
    }
    return _confirmButton;
}

#pragma mark - 待用方法
- (NSString *)htmlEntityDecode:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    return string;
}

- (NSAttributedString *)configAgreementText {
    // set tip Attributed String
    NSString *agreementString = [NSString stringWithFormat:@"%@ %@",GetLocalResStr(@"airpurifier_login_show_registerreadagreement_text"), GetLocalResStr(@"airpurifier_user_agreement_content")];
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:agreementString attributes:@{NSForegroundColorAttributeName : LJHexColor(@"#848484")}];
    [resultString addAttribute:NSForegroundColorAttributeName value:[UIColor classics_blue] range:[agreementString rangeOfString:GetLocalResStr(@"airpurifier_user_agreement_content")]];
    return resultString;
}

#pragma mark - System Method
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    WEAKSELF(weakSelf);
    [weakSelf.welcomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).with.offset(RATIO(90));
        make.left.mas_equalTo(RATIO(90));
        make.right.mas_equalTo(-RATIO(90));
    }];
    
    [weakSelf.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(weakSelf.welcomeLabel.mas_bottom).with.offset(RATIO(132));
    }];
    
    [weakSelf.agreementWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RATIO(90));
        make.right.mas_equalTo(RATIO(-90));
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).with.offset(RATIO(72));
    }];
    
    [weakSelf.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(RATIO(48), RATIO(48)));
        make.left.equalTo(weakSelf.agreementWebView);
        make.top.mas_equalTo(weakSelf.agreementWebView.mas_bottom).with.offset(RATIO(72));
    }];
    
    [weakSelf.checkNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.checkImageView.mas_right).offset(5);
        make.right.mas_equalTo(weakSelf.agreementWebView);
        make.top.equalTo(weakSelf.checkImageView.mas_top).offset(-4);
        make.bottom.mas_equalTo(weakSelf.confirmButton.mas_top).with.offset(RATIO(-120));
    }];
    
    [weakSelf.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.agreementWebView);
        make.bottom.mas_equalTo(RATIO(-174));
        make.height.mas_equalTo(_HEIGHT);
    }];
}

@end
