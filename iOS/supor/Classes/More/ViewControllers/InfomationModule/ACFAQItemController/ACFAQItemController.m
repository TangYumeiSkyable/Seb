//
//  ACFAQItemController.m
//  supor
//
//  Created by Jun Zhou on 2018/3/5.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "ACFAQItemController.h"
#import "UINavigationBar+FlatUI.h"
#import "ACFAQItemCell.h"
#import "ACFAQLeafController.h"

@interface ACFAQItemController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *safeAreaView;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@end

@implementation ACFAQItemController

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
        [_tableView registerClass:[ACFAQItemCell class] forCellReuseIdentifier:@"ACFAQItemCell"];
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
    
    [self.dataSourceArray removeAllObjects];
    if (self.dataSourceDic.count != 0) {
        [self.dataSourceArray addObjectsFromArray:self.dataSourceDic[@"sonContents"]];
    }
}


// MARK: - config UI

- (void)configUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.dataSourceDic.count != 0) {
        self.navigationItem.title = self.dataSourceDic[@"title"];
    }
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
    ACFAQItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACFAQItemCell" forIndexPath:indexPath];
    cell.dataSourceDic = self.dataSourceArray[indexPath.row];
    return cell;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ACFAQLeafController *faqLeafController = [[ACFAQLeafController alloc] init];
    faqLeafController.dataSourceDic = self.dataSourceArray[indexPath.row];
    [self.navigationController pushViewController:faqLeafController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


// MARK: - action


// MARK: - request



@end
