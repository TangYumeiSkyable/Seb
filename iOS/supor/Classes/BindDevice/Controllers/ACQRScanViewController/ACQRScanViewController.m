//
//  ACQRScanViewController.m
//  supor
//
//  Created by Jun Zhou on 2017/11/24.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "ACQRScanViewController.h"
#import "RHScanView.h"
#import "UIBarButtonItem+Extension.h"
#import "UINavigationBar+FlatUI.h"
#import "UAlertView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "ACAPAddDeviceTurnOnController.h"
#import "RHBaseNavgationController.h"
#import "AppDelegate.h"

@interface ACQRScanViewController () <RHSanViewDelegate>

@property (strong, nonatomic) RHScanView *scanView;

@property (strong, nonatomic) UIView *safeAreaView;

@end

@implementation ACQRScanViewController

// MARK: - getter

- (UIView *)safeAreaView {
    if (_safeAreaView == nil) {
        _safeAreaView = [[UIView alloc] init];
    }
    return _safeAreaView;
}

- (RHScanView *)scanView {
    if (_scanView == nil) {
        CGFloat height = DeviceUtils.screenHeight - DeviceUtils.bottomSafeHeight;
        _scanView = [[RHScanView alloc] initWithFrame:CGRectMake(0, 0, DeviceUtils.screenWidth, height)];
        _scanView.delegate = self;
        [_scanView startScan];
    }
    return _scanView;
}

// MARK: - view lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.scanView startScan];
}

// MARK: - config UI

- (void)configUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = GetLocalResStr(@"add_a_product");
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor classics_blue]];
    
}

// MARK: - setup subviews

- (void)setupSubViews {
    [self.view addSubview:self.safeAreaView];
    [self.view addSubview:self.scanView];
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
    
    
}

// MARK: - RHSanViewDelegate

-(void)scanScuess:(NSString *)qrcode {
    
    NSLog(@"qrcode is: %@", qrcode);
    
    if ([qrcode containsString:@"#"]) { // 分享
        
        NSArray *listItems = [qrcode componentsSeparatedByString:@"#"];
        
        if(listItems.count == 2) {

            WEAKSELF(ws);
            [ACBindManager bindDeviceWithShareCode:qrcode  callback:^(ACUserDevice *userDevice, NSError *error) {
                
                if(error != nil){
                    if(error.code==3817){
                        [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"airpurifier_moredevice_show_validate_ios") duration:1];
                    }else{
                        [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"airpurifier_moredevice_show_addfail_ios") duration:1];
                    }
                    [ws.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_moredevice_show_addsuccess")];
                    [ws.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
            
            
        } else {
            
            [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_moredevice_show_qrcodeidwrong_text")];
            [self.scanView startScan];
        }

        
    } else if ([qrcode containsString:@"&"]) { // 添加设备
        
        NSArray *listItems = [qrcode componentsSeparatedByString:@"&"];
        NSDictionary *dataDic = nil;
        // 产品信息数组从接口请求
        for (NSDictionary *deviceDic in self.deviceArray) {
            if ([deviceDic[@"model"] isEqualToString:listItems[1]]) {
                dataDic = deviceDic;
                break;
            }
        }
        
        ACAPAddDeviceTurnOnController *turnOnController = [[ACAPAddDeviceTurnOnController alloc] init];
        turnOnController.pageIdx = 1;
        turnOnController.domesticSsid = self.domesticSsid;
        turnOnController.dataSourceDic = dataDic;
        [self.navigationController pushViewController:turnOnController animated:YES];
        
    } else { // 其他
        
        [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_moredevice_show_qrcodeidwrong_text")];
        [self.scanView startScan];
    }
    
}

-(void)scanFailure:(NSString *)failed {
    
}

@end
