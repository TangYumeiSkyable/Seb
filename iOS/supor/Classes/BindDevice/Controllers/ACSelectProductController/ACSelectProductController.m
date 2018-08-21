//
//  ACSelectProductController.m
//  supor
//
//  Created by Jun Zhou on 2017/11/14.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "ACSelectProductController.h"
#import "ACPageControlView.h"
#import "ACProductCell.h"
#import "ACAPAddDeviceTurnOnController.h"
#import "ACQRScanViewController.h"
#import "ACProductManager.h"
#import "ACProduct.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface ACSelectProductController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *safeAreaView;

@property (strong, nonatomic) ACPageControlView *pageControlView;

@property (strong, nonatomic) UIButton *qrContainerView;
@property (strong, nonatomic) UILabel *qrTitleLabel;
@property (strong, nonatomic) UIImageView *qrRightArrowImageView;
@property (strong, nonatomic) UIView *qrlineView;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataSourceArray;

@end

@implementation ACSelectProductController

// MARK: - getter

- (UIView *)safeAreaView {
    if (_safeAreaView == nil) {
        _safeAreaView = [[UIView alloc] init];
    }
    return _safeAreaView;
}

- (ACPageControlView *)pageControlView {
    if (_pageControlView == nil) {
        _pageControlView = [[ACPageControlView alloc] initWithPageControlNum:6 currentPage:0];
    }
    return _pageControlView;
}

- (UIButton *)qrContainerView {
    if (_qrContainerView == nil) {
        _qrContainerView = [[UIButton alloc] init];
        [_qrContainerView addTarget:self action:@selector(qrButtonDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _qrContainerView;
}

- (UILabel *)qrTitleLabel {
    if (_qrTitleLabel == nil) {
        _qrTitleLabel = [[UILabel alloc] init];
        _qrTitleLabel.text = GetLocalResStr(@"airpurifier_moredevice_show_scanqrcode_text");
        _qrTitleLabel.textColor = RGB(164, 164, 164);
        _qrTitleLabel.font = [UIFont fontWithName:Regular size:18];
    }
    return _qrTitleLabel;
}

- (UIImageView *)qrRightArrowImageView {
    if (_qrRightArrowImageView == nil) {
        _qrRightArrowImageView = [[UIImageView alloc] init];
        _qrRightArrowImageView.image = GETIMG(@"ico_more");
    }
    return _qrRightArrowImageView;
}

- (UIView *)qrlineView {
    if (_qrlineView == nil) {
        _qrlineView = [[UIView alloc] init];
        _qrlineView.backgroundColor = LineColor;
    }
    return _qrlineView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

// MARK: - view lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self setupSubViews];
    // 获取并配置设备相关属性
    [self requestData];
}

// MARK: - config UI

- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = GetLocalResStr(@"select_product");
    self.navigationController.navigationBar.translucent = YES;
    
    if (@available(ios 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.automaticallyAdjustsScrollViewInsets = NO;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

// MARK: - setup subview

- (void)setupSubViews {
    [self.view addSubview:self.safeAreaView];
    [self.safeAreaView addSubview:self.pageControlView];
    
    [self.safeAreaView addSubview:self.qrContainerView];
    [self.qrContainerView addSubview:self.qrTitleLabel];
    [self.qrContainerView addSubview:self.qrRightArrowImageView];
    [self.qrContainerView addSubview:self.qrlineView];
    
    [self.safeAreaView addSubview:self.tableView];
}

// MARK: - rquest

- (void)requestData {
    
    WEAKSELF(ws);
    [DCPServiceUtils syncContent:DCPServiceContentAppliances callback:^(ACMsg *responseMsg, NSError *error) {
        
        if (error == nil) {
            
            NSArray *array  = [[[responseMsg get:@"content"] getObjectData] objectForKey:@"objects"];
            
            NSMutableArray *tempArr = @[].mutableCopy;
            [ACProductManager fetchAllProducts:^(NSArray<ACProduct *> *products, NSError *error) {
    
                if (error != nil) {
                    [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"airpurifier_failed_get_device_list")];
                    return;
                }
                // compare DCP products with AC products
                // 比较dcp获取的设备和SDK获取的设备；名字相同则添加到设备数组
                for (ACProduct *product in products) {
                    for (NSDictionary *dic in array) {
                        if ([product.model isEqualToString:dic[@"id"]]) {
                            NSArray *medias = dic[@"medias"];
                            NSDictionary *desDic = medias[0];
                            NSDictionary *proDic = @{
                                                     @"subDomainId" : [NSString stringWithFormat:@"%zd",product.subDomainId],
                                                     @"subDomain" : product.subDomain ? product.subDomain : @"",
                                                     @"productModel" : product.name ? product.name : @"",
                                                     @"name" : dic[@"name"] ? dic[@"name"] : @"",
                                                     @"model" : product.model ? product.model : @"",
                                                     @"imgUrl" : desDic[@"thumbs"] ? desDic[@"thumbs"] : @"",
                                                     };
                            [tempArr addObject:proDic];
                        }
                    }
                }
                ws.dataSourceArray = tempArr.copy;
                [ws.tableView reloadData];
            }];
        }
    }];
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
    
    [ws.pageControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(ws.safeAreaView);
        make.height.mas_equalTo(60);
    }];
    
    [ws.qrContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.pageControlView.mas_bottom);
        make.left.right.equalTo(ws.safeAreaView);
        make.height.mas_equalTo(60);
    }];
    
    [ws.qrTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.qrContainerView);
        make.left.mas_equalTo(15);
    }];
    
    [ws.qrRightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.qrContainerView);
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(15);
    }];
    
    [ws.qrlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.qrContainerView).offset(15);
        make.bottom.equalTo(ws.qrContainerView);
        make.right.equalTo(ws.qrContainerView).offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    [ws.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.qrContainerView.mas_bottom);
        make.left.right.bottom.equalTo(ws.safeAreaView);
    }];
}

// MARK: - action

- (void)qrButtonDidClick:(UIButton *)sender {
    ACQRScanViewController *qrScanController = [[ACQRScanViewController alloc] init];
    qrScanController.domesticSsid = self.domesticSsid;
    qrScanController.deviceArray = self.dataSourceArray.copy;
    [self.navigationController pushViewController:qrScanController animated:YES];
}

// MARK: - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ACProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACProductCell"];
    if (cell == nil) {
        cell = [[ACProductCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ACProductCell"];
    }
    cell.dataSourceDic = self.dataSourceArray[indexPath.section];
    return cell;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ACAPAddDeviceTurnOnController *turnOnController = [[ACAPAddDeviceTurnOnController alloc] init];
    turnOnController.pageIdx = 1;
    turnOnController.domesticSsid = self.domesticSsid;
    turnOnController.dataSourceDic = self.dataSourceArray[indexPath.section];
    [self.navigationController pushViewController:turnOnController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = RGB(240, 239, 244);
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

@end

