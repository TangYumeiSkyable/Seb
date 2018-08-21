//
//  LicenseViewController.m
//  supor
//
//  Created by 赵冰冰 on 2017/4/28.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "LicenseViewController.h"
#import "AppDelegate.h"
#import "UILabel+Add.h"
#import "UINavigationBar+FlatUI.h"
#import "UIBarButtonItem+Extension.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

static NSString * const CookieSwtichKey = @"CookieSwtichKey";

@interface LicenseViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *cookiesSwitch;

@property (assign, nonatomic) BOOL isSwitchOn;

@end

@implementation LicenseViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
    [self initData];
}

#pragma mark - Common Methods
- (void)configUI {
    self.navigationItem.title = GetLocalResStr(@"airpurifier_login_cookies_title");
    
    self.fd_prefersNavigationBarHidden = NO;
    self.navigationController.fd_interactivePopDisabled = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor classics_blue]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UILabel new]];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:GetLocalResStr(@"airpurifier_more_show_agree_text") style:UIBarButtonItemStylePlain target:self action:@selector(agree)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
    
    if (_number == 1) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0);
        [btn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        BTN_ADDTARGET(btn, @selector(backAction));
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = left;
        self.navigationController.fd_interactivePopDisabled = YES;
    } else {
        id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
        [self.view addGestureRecognizer:pan];
    }
}

- (void)initViews {
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = LJHexColor(@"#EEEEEE");
}

- (void)initData {
    NSString *isSwitchOn = [[NSUserDefaults standardUserDefaults] objectForKey:UD_COOKIES];
    if ([isSwitchOn isEqualToString:@"1"]) {
        [self.cookiesSwitch setOn:YES];
        self.isSwitchOn = YES;
    } else {
        [self.cookiesSwitch setOn:NO];
        self.isSwitchOn = NO;
    }
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 55;
    } else if (indexPath.row == 1){
        NSString * str = GetLocalResStr(@"airpurifier_more_show_cookiestitleTwoitem_text");
        CGSize size = [UILabel labelRectWithSize:CGSizeMake(kMainScreenWidth - 30, 0) labelText:str Font:[UIFont fontWithName:Regular size:16]];
        return size.height + 30;
    } else if (indexPath.row == 2){
        return RATIO(132);
    } else if (indexPath.row == 3){
        return 120;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.backgroundColor = LJHexColor(@"#EEEEEE");
    
    if (indexPath.row == 2) {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if (indexPath.row == 0) {
        UILabel *label = [cell.contentView viewWithTag:100];
        label.textColor = [UIColor colorFromHexCode:@"#36424a"];
        label.font = [UIFont fontWithName:Regular size:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = GetLocalResStr(@"airpurifier_more_show_cookiestitle_text");
    } else if (indexPath.row == 1) {
        UILabel *label = [cell.contentView viewWithTag:100];
        label.textColor = [UIColor colorFromHexCode:@"#36424a"];
        label.font = [UIFont fontWithName:Regular size:16];
        label.text = GetLocalResStr(@"airpurifier_more_show_cookiestitleTwoitem_text");
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell.contentView);
            make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
            make.right.mas_equalTo(cell.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(cell.contentView.mas_bottom).offset(-20);
        }];
    } else if (indexPath.row == 2) {
        UILabel *label = [cell.contentView viewWithTag:101];
        label.textColor = [UIColor colorFromHexCode:@"#848484"];
        label.font = [UIFont fontWithName:Regular size:18];
        label.text = GetLocalResStr(@"airpurifier_more_show_cookiestitles_text");
        UISwitch *sw = [cell.contentView viewWithTag:102];
        [sw setOnTintColor:[UIColor classics_blue]];
    } else {
        UILabel *label = [cell.contentView viewWithTag:100];
        label.textColor = [UIColor colorFromHexCode:@"#848484"];
        label.font = [UIFont fontWithName:Regular size:16];
        label.text = GetLocalResStr(@"airpurifier_more_show_cookiestitleitem_text");
    }
    return cell;
}

#pragma mark - Target Action
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)agree:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)agree {
    NSString *tmp = nil;
    if (self.isSwitchOn) {
        tmp = @"1";
    } else {
        tmp = @"0";
    }
    [[NSUserDefaults standardUserDefaults] setObject:tmp forKey:UD_COOKIES];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    AppDelegate * app = [AppDelegate sharedInstance];
    [app initializeLocationService];
}

- (IBAction)cookiesSwitchValueChanged:(UISwitch *)sender {
    self.isSwitchOn = sender.isOn;
}

@end
