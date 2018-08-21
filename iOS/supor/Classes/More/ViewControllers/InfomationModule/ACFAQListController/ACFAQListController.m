//
//  ACFAQListController.m
//  supor
//
//  Created by Jun Zhou on 2018/3/5.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "ACFAQListController.h"
#import "UINavigationBar+FlatUI.h"
#import "ACFAQListCell.h"
#import "ACFAQItemController.h"


@interface ACFAQListController ()  <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *safeAreaView;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@end

@implementation ACFAQListController

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
        [_tableView registerClass:[ACFAQListCell class] forCellReuseIdentifier:@"ACFAQListCell"];
    }
    return _tableView;
}

- (NSMutableArray *)dataSourceArray {
    if (_dataSourceArray == nil) {
        _dataSourceArray = @[].mutableCopy;
    }
    return _dataSourceArray;
}

// MARK: - view lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self setupSubViews];
    
    [self dcpRequestFAQ];
}


// MARK: - config UI

- (void)configUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_userinfomation_FAQ");
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
    ACFAQListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACFAQListCell" forIndexPath:indexPath];
    NSDictionary *dictionary = self.dataSourceArray[indexPath.row];
    cell.dataSourceDic = dictionary;
    return cell;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ACFAQItemController *faqItemController = [[ACFAQItemController alloc] init];
    faqItemController.dataSourceDic = self.dataSourceArray[indexPath.row];
    [self.navigationController pushViewController:faqItemController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


// MARK: - action


// MARK: - request

- (void)dcpRequestFAQ {
    
    [SVProgressHUD show];
    ACMsg *msg = [ACMsg msgWithName:[NSString stringWithFormat:@"dcp-syncContent"]];
    NSString *contentType = @"sync";
    contentType = [contentType stringByAppendingString:@"Libraries"];
    
    [msg put:@"contentType" value:contentType];
    [msg put:@"lang" value:[DCPServiceUtils getLanguage]];
    [msg put:@"dcpToken" value:[DCPServiceUtils getDcpToken]];
    [msg put:@"dcpUid" value:[DCPServiceUtils getDcpUid]];
    [msg put:@"market" value:[DCPServiceUtils getMarket]];
    
    WEAKSELF(ws);
    [DCPServiceUtils sendToDCPService:msg callback:^(ACMsg *responseMsg, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            return;
        }
        
        NSArray * array  = [[[responseMsg get:@"content"] getObjectData] objectForKey:@"objects"];
        [ws.dataSourceArray removeAllObjects];
        [ws.dataSourceArray addObjectsFromArray:array];
        [ws.tableView reloadData];
    }];

}

@end
