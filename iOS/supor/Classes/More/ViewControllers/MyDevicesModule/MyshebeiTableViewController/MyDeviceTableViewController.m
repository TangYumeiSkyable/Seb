//
//  MyshebeiTableViewController.m
//  supor
//
//  Created by huayiyang on 16/6/14.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "MyDeviceTableViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MyshebeiTableViewCell.h"
#import "ACUserDevice.h"
#import "RHAccountTool.h"
#import "UINavigationBar+FlatUI.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UIImageView+WebCache.h"

#import "ACSelectProductController.h"
#import "DeviceManageViewController.h"

@interface MyDeviceTableViewController ()

/**
 设备系统参数数组（subdomainID、subdomainName）
 */
@property (nonatomic,strong) NSMutableArray *deviceParameterArray;

/**
 设备信息数组（名称、图片URL）
 */
@property (nonatomic, strong) NSMutableArray *deviceInfoArray;

@end

@implementation MyDeviceTableViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    WEAKSELF(ws);
    [ACBindManager listDevicesWithStatusCallback:^(NSArray *devices, NSError *error) {
        
        if (error) {
            [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"airpurifier_failed_get_device_list")];
        } else {
            [ws.deviceParameterArray removeAllObjects];
            [ws.deviceInfoArray removeAllObjects];
//            [ws.deviceParameterArray addObjectsFromArray:devices];
//            [ws.deviceInfoArray addObjectsFromArray:devices];
            
            
            NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:Device];
            [self.deviceInfoArray addObjectsFromArray:arr];
            for (NSDictionary *dic in arr) {
                
                for (ACUserDevice *device in devices) {
                    
                    if ([[NSString stringWithFormat:@"%@", dic[@"subDomainId"]] isEqualToString:[NSString stringWithFormat:@"%@", @(device.subDomainId)]]) {
                        
//                        [_deviceInfoArray addObject:dic];
                        [ws.deviceParameterArray addObject:device];
                        
                    }
                }
            }
            
            [ws.tableView reloadData];
        }
    }];
}

#pragma mark - Common Methods
- (void)configUI {
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor classics_blue]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.fd_prefersNavigationBarHidden = NO;
    self.navigationItem.title = GetLocalResStr(@"airpurifier_moredevice_show_mydevice_title");
    UIBarButtonItem *rightItem = [UIBarButtonItem createRightItemWithFrame:CGRectMake(0, 0, 11*59/33, 11*59/33) title:nil image:[UIImage imageNamed:@"add_white"] highLightImage:nil target:self selector:@selector(addDeviceAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)initViews {
    self.tableView.backgroundColor = LJHexColor(@"#EEEEEE");
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.deviceParameterArray.count && self.deviceInfoArray.count) {
        return self.deviceParameterArray.count;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyshebeiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Myshebei" forIndexPath:indexPath];
    
    if (self.deviceInfoArray.count  || self.deviceParameterArray.count) {
        
        ACUserDevice *device = self.deviceParameterArray[indexPath.section];
        NSDictionary *deviceDic = nil;
        for (NSDictionary *dict in self.deviceInfoArray) {
            if ([[NSString stringWithFormat:@"%@", dict[@"subDomainId"]] isEqualToString:[NSString stringWithFormat:@"%@", @(device.subDomainId)]]) {
                deviceDic = dict;
                break;
            }
        }
        cell.nameLabel.text =  [NSString stringWithFormat:@"%@",device.deviceName];
        NSString *str = [NSString stringWithFormat:@"%@", deviceDic[@"thumbs"]];
        NSString *imgUrl = [str stringByReplacingOccurrencesOfString:@"{size}/" withString:@""];
        [cell.shebeiImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]  placeholderImage:[UIImage imageNamed:@"img_p1"]];
        cell.xinghaoLabel.text = deviceDic[@"name"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ACUserDevice *device = self.deviceParameterArray[indexPath.section];
    NSDictionary *deviceDic = self.deviceInfoArray[indexPath.section];
    
    DeviceManageViewController *deviceManageVC = [[DeviceManageViewController alloc] init];
    deviceManageVC.device = device;
    deviceManageVC.deviceDic = deviceDic;
    [self.navigationController pushViewController:deviceManageVC animated:YES];
}

#pragma mark - Target Methods
- (void)addDeviceAction {
    ACSelectProductController *selectProductController = [[ACSelectProductController alloc] init];
    [self.navigationController pushViewController:selectProductController animated:YES];
}

#pragma mark - Lazyload Methods
- (NSMutableArray *)deviceParameterArray {
    if (_deviceParameterArray == nil) {
        _deviceParameterArray = @[].mutableCopy;
    }
    return _deviceParameterArray;
}

- (NSMutableArray *)deviceInfoArray {
    if (_deviceInfoArray == nil) {
        _deviceInfoArray = @[].mutableCopy;
    }
    return _deviceInfoArray;
}

@end
