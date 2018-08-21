//
//  ShezhiTableViewController.m
//  supor
//
//  Created by huayiyang on 16/6/14.
//  Copyright © 2016年 XYJ. All rights reserved.
//

// 3 1 2
#import "ShezhiTableViewController.h"
#import "UAlertView.h"
#import "RHAccountTool.h"
#import "UIBarButtonItem+Extension.h"

@interface ShezhiTableViewController () <UAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *vesionLabel;

@property (weak, nonatomic) IBOutlet UISwitch *s1;

@property (weak, nonatomic) IBOutlet UISwitch *s2;

@property (weak, nonatomic) IBOutlet UISwitch *s3;

@property (weak, nonatomic) IBOutlet UISwitch *s4;

@property (nonatomic, strong) NSArray * datas;

@end

@implementation ShezhiTableViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - Common Methods

- (void)configUI {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_settings_text");
}

- (void)initViews {
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = LJHexColor(@"#EEEEEE");
    [self.s1 setOnTintColor:[UIColor classics_blue]];
    [self.s2 setOnTintColor:[UIColor classics_blue]];
    [self.s3 setOnTintColor:[UIColor classics_blue]];
    [self.s4 setOnTintColor:[UIColor classics_blue]];
}

- (void)initData {
    
    [SVProgressHUD show];
    WEAKSELF(ws);
    [ACAccountManager getUserProfile:^(ACObject *profile, NSError *error) {
        [SVProgressHUD dismiss];
        if (error == nil) {
            NSDictionary * dict = [profile getObjectData];
            [ws setNotificationDataWithDictionary:dict];
        }
    }];
    
}

- (void)setNotificationDataWithDictionary:(NSDictionary *)dictionary {
    BOOL notifyFlg1 = [dictionary[@"notifyFlg1"] boolValue];
    BOOL notifyFlg2 = [dictionary[@"notifyFlg2"] boolValue];
    BOOL notifyFlg3 = [dictionary[@"notifyFlg3"] boolValue];
    BOOL notifyFlg4 = [dictionary[@"notifyFlg4"] boolValue];
    
    [self.s1 setOn:notifyFlg1 animated:NO];
    [self.s2 setOn:notifyFlg2 animated:NO];
    [self.s3 setOn:notifyFlg3 animated:NO];
    [self.s4 setOn:notifyFlg4 animated:NO];
}

#pragma mark - Lazyload Methods
- (IBAction)indoorChanged:(UISwitch *)sender {
    [self updateNotificationWithType:@"notifyFlg1" sender:sender];
}

- (IBAction)outdoorChanged:(UISwitch *)sender {
    [self updateNotificationWithType:@"notifyFlg2" sender:sender];
}

- (IBAction)updateChanged:(UISwitch *)sender {
    [self updateNotificationWithType:@"notifyFlg3" sender:sender];
}

- (IBAction)wiftChange:(UISwitch *)sender {
    [self updateNotificationWithType:@"notifyFlg4" sender:sender];
}

- (void)updateNotificationWithType:(NSString *)type sender:(UISwitch *)sender {
    ACObject *profile = [[ACObject alloc] init];
    [profile putBool:type value:sender.on];
    
    [ACAccountManager setUserProfile:profile callback:^(NSError *err) {
        if (err == nil) {
            RHLog(@"修改通知类型成功");
        } else {
            
            [ZSVProgressHUD showSimpleText:TIPS_FAILED];
            sender.on = !sender.on;
        }
    }];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * v = [UIView new];
    if (section == 0) {
        v.frame = CGRectMake(0, 0, kMainScreenWidth, 20);
    } else {
        v.frame = CGRectMake(0, 0, kMainScreenWidth, 30);
    }
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * v = [UIView new];
    v.frame = CGRectMake(0, 0, kMainScreenWidth, 0);
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    if (section == 1) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *buildString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        self.vesionLabel.textColor = LJHexColor(@"#36424a");
        self.vesionLabel.font = [UIFont fontWithName:Regular size:16];
        self.vesionLabel.text = [NSString stringWithFormat:@"v%@-%@", versionString, buildString];
    }
    cell.textLabel.textColor = LJHexColor(@"#848484");
    cell.textLabel.font = [UIFont fontWithName:Regular size:18];
    cell.textLabel.text = self.datas[indexPath.section][indexPath.row];
    
    return cell;
}

#pragma mark - UAlertViewDelegate
- (void)alertView:(UAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        _s4.on = NO;
    } else {
        
    }
}

#pragma mark - Lazyload Methods
- (NSArray *)datas {
    if (!_datas) {
        NSArray *firstSectionTitleArray = @[GetLocalResStr(@"airpurifier_more_show_msgsend_text"),GetLocalResStr(@"airpurifier_more_show_airqualityalerm_text"), GetLocalResStr(@"airpurifier_more_show_memberupdatemetion_text"), GetLocalResStr(@"airpurifier_more_show_wifiupdatemetion_text")];
        NSArray *secondSectionTitleArray = @[GetLocalResStr(@"airpurifier_more_show_updatetipmsg_text_ios")];
        _datas = @[firstSectionTitleArray, secondSectionTitleArray];
    }
    return _datas;
}

@end
