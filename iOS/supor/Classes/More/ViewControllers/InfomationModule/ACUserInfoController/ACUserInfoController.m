//
//  ACUserInfoController.m
//  supor
//
//  Created by Jun Zhou on 2018/3/2.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "ACUserInfoController.h"
#import "UINavigationBar+FlatUI.h"
#import "ACUserInfoCell.h"
#import "IFUViewController.h"
#import "ACFAQListController.h"

@interface ACUserInfoController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *safeAreaView;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataSourceArray;

@end

@implementation ACUserInfoController

// MARK: - getter

- (UIView *)safeAreaView {
    if (_safeAreaView == nil) {
        _safeAreaView = [[UIView alloc] init];
    }
    return _safeAreaView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ACUserInfoCell class] forCellReuseIdentifier:@"ACUserInfoCell"];
    }
    return _tableView;
}

- (NSArray *)dataSourceArray {
    if (_dataSourceArray == nil) {
        _dataSourceArray = @[
                             @{
                                 @"title" : GetLocalResStr(@"airpurifier_more_userinfomation_user_guide"),
                                 },
                             @{
                                 @"title" : GetLocalResStr(@"airpurifier_more_userinfomation_FAQ"),
                                 },
                             ];
    }
    return _dataSourceArray;
}

// MARK: - view lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self setupSubViews];
}


// MARK: - config UI

- (void)configUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_userinfomation");
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor classics_blue]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
}

// MARK: - setup subviews

- (void)setupSubViews {
    [self.view addSubview:self.safeAreaView];
    [self.safeAreaView addSubview:self.tableView];
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
    
    [ws.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.safeAreaView);
    }];
}

// MARK: - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ACUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACUserInfoCell" forIndexPath:indexPath];
    cell.dataSourceDic = self.dataSourceArray[indexPath.row];
    return cell;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        IFUViewController *ifuVc = [[UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"IFUViewController"];
        [self.navigationController pushViewController:ifuVc animated:YES];
        
    } else if (indexPath.row == 1) {
        
        ACFAQListController *faqListController = [[ACFAQListController alloc] init];
        [self.navigationController pushViewController:faqListController animated:YES];
        
    } else {
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


// MARK: - action


// MARK: - request




@end
