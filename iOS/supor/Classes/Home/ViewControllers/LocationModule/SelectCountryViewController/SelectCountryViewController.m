//
//  SelectCountryViewController.m
//  supor
//
//  Created by 白云杰 on 2017/5/31.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "SelectCountryViewController.h"
#import "SelectCityViewController.h"
#import "RHAccount.h"
#import "RHAccountTool.h"
#import "INTULocationManager.h"
#import "SelectCountryHeaderView.h"

@interface SelectCountryViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (strong, nonatomic) UILabel *cityLabel;

@property (nonatomic, strong) SelectCountryHeaderView *tableHeaderView;

@end

@implementation SelectCountryViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self initViews];
    [self httpRequest];
}

- (void)createUI {
    self.view.backgroundColor = RGB(242, 242, 242);
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = GetLocalResStr(@"airpurifier_adjust_show_modifycity_text");
}

- (void)initViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = LJHexColor(@"#EEEEEE");
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:_tableView];
    
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return RATIO(400);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return FLT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RATIO(156);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.textColor = LJHexColor(@"#36424a");
    cell.textLabel.font = [UIFont fontWithName:Regular size:18];
    cell.detailTextLabel.textColor = LJHexColor(@"#848484");
    cell.detailTextLabel.font = [UIFont fontWithName:Regular size:16];
    
    NSDictionary *selectedCityDic = [[NSUserDefaults standardUserDefaults] objectForKey:CityInfo];
    NSDictionary *currentDic = self.dataArr[indexPath.row];
    cell.textLabel.text = currentDic[@"country"];
    if ([selectedCityDic[@"country"] isEqualToString:currentDic[@"country"]]) {
        cell.detailTextLabel.text = selectedCityDic[@"name"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *currentCityDic = self.dataArr[indexPath.row];
    SelectCityViewController *selectCityVC = [[SelectCityViewController alloc] init];
    selectCityVC.country = currentCityDic[@"country"];
    selectCityVC.popStyle = self.popStyle;
    [self.navigationController pushViewController:selectCityVC animated:YES];
    
}

#pragma mark - Lazyload Methods
- (CLGeocoder *)geocoder  {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (SelectCountryHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[SelectCountryHeaderView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, RATIO(400))];
        [_tableHeaderView.locateButton addTarget:self action:@selector(locateButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSDictionary *cityInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:CityInfo];
        if (cityInfoDic[@"name"]) {
            _tableHeaderView.selectedCityLabel.text = cityInfoDic[@"name"];
        } else {
            RHAccount *accountInfo = [RHAccountTool account];
            if (accountInfo.city.length) {
                _tableHeaderView.selectedCityLabel.text = accountInfo.city;
            } else {
                _tableHeaderView.selectedCityLabel.text = @"--";
            }
        }
    }
    return _tableHeaderView;
}

#pragma mark - Private Methods
- (void)httpRequest {
    
    [http_ requestWithMessageName:@"queryCountryList" callback:^(ACMsg *responseObject, NSError *error) {
        if (error) {
             [ZSVProgressHUD showErrorWithStatus: GetLocalResStr(@"airpurifier_get_country_list_fail")];
            return;
        }
        NSDictionary * data = [responseObject getObjectData];
        NSArray * array = data[@"actionData"];
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:array];
        [self.tableView reloadData];
        
    } andKeyValues:nil];
}

#pragma mark - Target Methods
- (void)locateButtonDidClick:(UIButton *)sender {
    
    WEAKSELF(ws);
    INTULocationManager *locationManager = [INTULocationManager sharedInstance];
    [locationManager requestLocationWithDesiredAccuracy:(INTULocationAccuracyBlock) timeout:60 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        switch (status) {
            case INTULocationStatusSuccess: {
                RHLog(@"Current location detail:(latitude: %f, longitude: %f)", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
                if (currentLocation) {
                    [ws requestCurrentDistrict:currentLocation];
                }
            } break;
                
            case INTULocationStatusTimedOut: {
                RHLog(@"Got a location, but the desired accuracy level was not reached before timeout");
                [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"locate_fail") duration:0.5];
            } break;
                
            case INTULocationStatusServicesNotDetermined: {
                RHLog(@"User has not yet responded to the dialog that grants this app permission to access location services.");
                [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"locate_fail") duration:0.5];
            } break;
                
            case INTULocationStatusServicesDenied: {
                RHLog(@"User has explicitly denied this app permission to access location services.");
                [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"locate_fail") duration:0.5];
            } break;
                
            case INTULocationStatusServicesRestricted: {
                RHLog(@"User does not have ability to enable location services (e.g. parental controls, corporate policy, etc).");
                [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"locate_fail") duration:0.5];
            } break;
                
            case INTULocationStatusServicesDisabled: {
                RHLog(@"User has turned off location services device-wide (for all apps) from the system Settings app.");
                [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"locate_fail") duration:0.5];
            } break;
                
            case INTULocationStatusError: {
                RHLog(@"An error occurred while using the system location services.");
                [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"locate_fail") duration:0.5];
            } break;
        }
    }];
}

- (void)requestCurrentDistrict:(CLLocation *)currentLocation {
    // 请求所在地区 || 地理反编码
    WEAKSELF(ws);
    [ws.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error || placemarks.count == 0) {
            [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"locate_fail") duration:0.5];
            return;
        }
        CLPlacemark *placeMark = placemarks.firstObject;
        RHLog(@"placeMark: %@", placeMark.addressDictionary);
        NSDictionary *cityDic = @{
                                  @"name" : placeMark.locality,
                                  @"latitude" : [NSString stringWithFormat:@"%f",placeMark.location.coordinate.latitude],
                                  @"longitude" : [NSString stringWithFormat:@"%f",placeMark.location.coordinate.longitude],
                                  @"country" : placeMark.addressDictionary[@"CountryCode"],
                                  @"timezone" : @"",
                                  };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cityChange" object:nil userInfo:cityDic];
        [[NSUserDefaults standardUserDefaults] setObject:cityDic forKey:CityInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ws.tableHeaderView.selectedCityLabel.text = placeMark.locality;
    }];
}

@end
