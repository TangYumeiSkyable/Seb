//
//  OutDoorViewController.m
//  supor
//
//  Created by 赵冰冰 on 2017/5/16.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "OutDoorViewController.h"
#import "UINavigationBar+FlatUI.h"
#import "UIView+WhenTappedBlocks.h"
#import "OutdoorAirViewController.h"
#import "SelectCountryViewController.h"
#import "RHAccount.h"
#import "RHAccountTool.h"
#import "UIImage+FlatUI.h"
#import "OutDoorView.h"
#import "OutdoorAQIModel.h"

@interface OutDoorViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) OutDoorView *outDoorView;

@property (nonatomic, strong) NSMutableArray *airQualityInfoArray;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation OutDoorViewController

#pragma mark - View LifeCycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
    [self initData];
}

#pragma mark - Common Methods
- (void)initViews {
    [self.view addSubview:self.outDoorView];
}

- (void)configUI {
    self.view.backgroundColor = RGB(242, 242, 242);
    self.navigationItem.title = GetLocalResStr(@"airpurifier_outdoor_show_outdoortitle_text");
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:LJHexColor(@"009dc2")];
}

- (void)initData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCityChangedNotification:) name:@"cityChange" object:nil];
    
    NSDictionary *cityInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:CityInfo];
    RHAccount *accountInfo = [RHAccountTool account];

    NSString *cityName = @"";
    NSString *cityLatitude = @"";
    NSString *cityLongitude = @"";
    
    if (cityInfoDic) {
        cityName = [NSString stringWithFormat:@"%@", cityInfoDic[@"name"]];
        cityLatitude = [NSString stringWithFormat:@"%@", cityInfoDic[@"latitude"]];
        cityLongitude = [NSString stringWithFormat:@"%@", cityInfoDic[@"longitude"]];
    } else {
        cityName = accountInfo.city;
        cityLatitude = accountInfo.latitude;
        cityLongitude = accountInfo.longtidude;
    }
    
    [self.outDoorView.selectCityButton setTitle:cityName forState:UIControlStateNormal];
    [self requestAirQulityDataWithCity:cityName latitude:cityLatitude longitude:cityLongitude];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AQITypeTableViewCell *typeCell = [tableView dequeueReusableCellWithIdentifier:typeCellIdentifier forIndexPath:indexPath];
    if (self.airQualityInfoArray.count != 0) {
        OutdoorAQIModel *model = self.airQualityInfoArray[indexPath.row];
        typeCell.titleLabel.text = model.AQIName;
        if (model.AQIValue && model.AQIValue.length && ![model.AQIValue isEqualToString:@"(null)"]) {
            typeCell.numberLabel.text = model.AQIValue;
        } else {
            typeCell.numberLabel.text = @"--";
        }
        
//        if (indexPath.row==0) {
//            if ([model.AQIValue integerValue]<=40) {
//                typeCell.numberLabel.textColor = RGB(81, 173, 91);
//            } else if (40<[model.AQIValue integerValue]&&[model.AQIValue integerValue]<=80) {
//                typeCell.numberLabel.textColor = RGB(245, 194, 67);
//            } else if (80<[model.AQIValue integerValue]&&[model.AQIValue integerValue]<=200) {
//                typeCell.numberLabel.textColor = RGB(233, 72, 38);
//            } else {
//                typeCell.numberLabel.textColor = RGB(175, 36, 24);
//            }
//        } else if (indexPath.row==1) {
//            if ([model.AQIValue integerValue]<=50) {
//                typeCell.numberLabel.textColor = RGB(81, 173, 91);
//            } else if (50<[model.AQIValue integerValue]&&[model.AQIValue integerValue]<=100) {
//                typeCell.numberLabel.textColor = RGB(245, 194, 67);
//            } else if (100<[model.AQIValue integerValue]&&[model.AQIValue integerValue]<=160) {
//                typeCell.numberLabel.textColor = RGB(233, 72, 38);
//            } else {
//                typeCell.numberLabel.textColor = RGB(175, 36, 24);
//            }
//        } else if (indexPath.row==2) {
//            if ([model.AQIValue integerValue]<=10) {
//                typeCell.numberLabel.textColor = RGB(81, 173, 91);
//            } else if (10<[model.AQIValue integerValue]&&[model.AQIValue integerValue]<=25) {
//                typeCell.numberLabel.textColor = RGB(245, 194, 67);
//            } else if (25<[model.AQIValue integerValue]&&[model.AQIValue integerValue]<=50) {
//                typeCell.numberLabel.textColor = RGB(233, 72, 38);
//            } else {
//                typeCell.numberLabel.textColor = RGB(175, 36, 24);
//            }
//        } else {
//            if ([model.AQIValue integerValue]<=20) {
//                typeCell.numberLabel.textColor = RGB(81, 173, 91);
//            } else if (20<[model.AQIValue integerValue]&&[model.AQIValue integerValue]<=50) {
//                typeCell.numberLabel.textColor = RGB(245, 194, 67);
//            } else if (50<[model.AQIValue integerValue]&&[model.AQIValue integerValue]<=80) {
//                typeCell.numberLabel.textColor = RGB(233, 72, 38);
//            } else {
//                typeCell.numberLabel.textColor = RGB(175, 36, 24);
//            }
//        }
        [typeCell.pointView setHidden:!model.isSelected];
    }
    return typeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.airQualityInfoArray.count) return;
    if (indexPath.row != _selectedIndex) {
        OutdoorAQIModel *lastSelectedModel = self.airQualityInfoArray[_selectedIndex];
        lastSelectedModel.isSelected = NO;
        
        OutdoorAQIModel *currentModel = self.airQualityInfoArray[indexPath.row];
        currentModel.isSelected = YES;
        _selectedIndex = indexPath.row;
        [tableView reloadData];
        
        self.outDoorView.AQITypeTitleLabel.text = currentModel.AQIName;
        self.outDoorView.AQITypeDescriptionTextView.text = currentModel.AQIDescription;
    }
}

#pragma mark - Target Methods
- (void)selectCityAction:(UIButton *)sender {
    SelectCountryViewController *country = [[SelectCountryViewController alloc] init];
    country.popStyle = SelectCityVCPopToRoot;
    [self.navigationController pushViewController:country animated:YES];
}

#pragma mark - Private Methods
- (void)requestAirQulityDataWithCity:(NSString *)cityName latitude:(NSString *)latitude longitude:(NSString *)longitude {
    [http_ requestWithMessageName:@"queryWeather" callback:^(ACMsg *responseObject, NSError *error) {
        
        ACObject *airInfoObject = [responseObject getACObject:@"actionData"];
        NSDictionary *airInfoDic = [airInfoObject getObjectData];
        
        OutdoorAQIModel *model = [[OutdoorAQIModel alloc] init];
        _airQualityInfoArray = [model retreatmentWithDictionary:airInfoDic];
        self.outDoorView.airLevelLabel.text = model.airLevelText;
        self.outDoorView.airLevelImageView.image = [UIImage imageNamed:model.airLevelImageName];
        self.selectedIndex = 0;
        self.outDoorView.AQITypeTitleLabel.text = GetLocalResStr(@"airpurifier_more_airquality_tvno2");
        self.outDoorView.AQITypeDescriptionTextView.text = GetLocalResStr(@"airpurifier_more_airquality_no2");
        
        [self.outDoorView.airQualityIndexTableView reloadData];
    } andKeyValues:@"city", cityName, @"latitude", @(latitude.doubleValue), @"longitude", @(longitude.doubleValue), nil];
}

- (void)getCityChangedNotification:(NSNotification *)notification {
    NSDictionary *cityInfoDic = notification.userInfo;
    [self requestAirQulityDataWithCity:cityInfoDic[@"name"] latitude:cityInfoDic[@"latitude"] longitude:cityInfoDic[@"longitude"]];
    [self.outDoorView.selectCityButton setTitle:cityInfoDic[@"name"] forState:UIControlStateNormal];
}

#pragma mark - Lazyload Methods
- (OutDoorView *)outDoorView {
    if (!_outDoorView) {
        _outDoorView = [[OutDoorView alloc] initWithFrame:CGRectZero];
        _outDoorView.airQualityIndexTableView.delegate = self;
        _outDoorView.airQualityIndexTableView.dataSource = self;
        
        [_outDoorView.selectCityButton addTarget:self action:@selector(selectCityAction:) forControlEvents:UIControlEventTouchUpInside];
        WEAKSELF(weakself);
        [_outDoorView.levelBackgroundView whenTapped:^{
            OutdoorAirViewController *airLevelDetailVC = [[OutdoorAirViewController alloc] init];
            [weakself.navigationController pushViewController:airLevelDetailVC animated:YES];
        }];
    }
    return _outDoorView;
}

- (NSMutableArray *)airQualityInfoArray {
    if (!_airQualityInfoArray) {
        _airQualityInfoArray = [NSMutableArray array];
    }
    return _airQualityInfoArray;
}

#pragma mark - System Methods
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.outDoorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
