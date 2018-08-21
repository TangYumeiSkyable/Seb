//
//  JNavigationView.m
//  supor
//
//  Created by 赵冰冰 on 2017/5/10.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "JNavigationView.h"
#import "SDCycleScrollView.h"
#import "UIImage+FlatUI.h"
#import "UIView+WhenTappedBlocks.h"
#import "RHAccount.h"
#import "RHAccountTool.h"
#import "UAlertView.h"
@interface RHPMItem : NSObject
@property (nonatomic, strong) NSString * itemText;
@property (nonatomic, strong) NSString * itemValue;


@end

@implementation RHPMItem

@end

@interface JNavigationView ()<SDCycleScrollViewDelegate, UAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray * datas;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) UILabel * cityNameLbl;
@property (nonatomic, strong) UILabel * airFresh;
@property (nonatomic, strong) UIImageView * airIv;
@end
@implementation JNavigationView

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        NSArray * titles = @[@"PM", @"NO₂", @"O₃"];
        _datas = @[].mutableCopy;
        for (int i = 0; i < titles.count; i++) {
            RHPMItem * item = [RHPMItem new];
            item.itemText = titles[i];
            [_datas addObject:item];
            if (i == 0) {
                item.itemValue = @"--";
            }else if (i == 1){
                item.itemValue = @"--";
            }else{
                item.itemValue = @"--";
            }
        }
    }
    return _datas;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    
    return _dataArr;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"cityChange" object:nil];
    
    UIImageView * iv = [UIImageView new];
    iv.image = [UIImage imageNamed:@"ico_more5"];
    iv.tag = 1000;
    [self addSubview:iv];

    UIButton * toCityButton = [UIButton new];
    [toCityButton setBackgroundImage:[UIImage imageNamed:@"ico_more4"] forState:UIControlStateNormal];
    [self addSubview:toCityButton];
    _cityNameLbl = [UILabel new];
    //[UIColor whiteColor]
    _cityNameLbl.textColor = [UIColor colorFromHexCode:@"#f2f2f2"];
    _cityNameLbl.font = [UIFont fontWithName:Regular size:17];
//    _cityNameLbl.text = @"Pairs";
    [self addSubview:_cityNameLbl];
    
    [_cityNameLbl whenTapped:^{
        [self.delegate didSelectAtIndex:0];
    }];
    
    
    [toCityButton whenTapped:^{
        [self.delegate didSelectAtIndex:0];
    }];
    
    _airIv = [UIImageView new];
    _airIv.image = [UIImage imageNamed:@"ico_air_s_01"];
    [self addSubview:_airIv];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 20, kMainScreenWidth / 3, 44) shouldInfiniteLoop:YES imageNamesGroup:@[@"PM", @"NO₂", @"O₃"]];
    cycleScrollView.autoScrollTimeInterval = 2;
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle =  SDCycleScrollViewPageContolStyleClassic;
    [self addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    cycleScrollView.pageDotImage = [UIImage circularImageWithColor:[UIColor clearColor] size:CGSizeMake(5, 5)];
    cycleScrollView.currentPageDotImage = [UIImage circularImageWithColor:[UIColor whiteColor] size:CGSizeMake(5, 5)];
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.equalTo(toCityButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kMainScreenWidth / 4, 44));
    }];
    
    [cycleScrollView whenTapped:^{
        
    }];
    
    _airFresh = [UILabel new];
    _airFresh.textColor = [UIColor whiteColor];
    _airFresh.font = [UIFont fontWithName:Regular size:12];
//    _airFresh.numberOfLines = 0;
    [self addSubview:_airFresh];
    
    [_airFresh whenTapped:^{
        [self.delegate didSelectAtIndex:1];
    }];
    
    [_airIv whenTapped:^{
        [self.delegate didSelectAtIndex:1];
    }];
    
    [iv whenTapped:^{
        [self.delegate didSelectAtIndex:1];
    }];
    
    
    [_airFresh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(iv);
        make.right.mas_equalTo(iv.mas_left).with.offset(-3);
    }];

    [_airIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(RATIO(66), RATIO(66)));
        make.right.mas_equalTo(_airFresh.mas_left).with.offset(-RATIO(18));
//        make.bottom.mas_equalTo(_airFresh);
        make.centerY.equalTo(toCityButton.mas_centerY);
        make.left.greaterThanOrEqualTo(cycleScrollView.mas_right);
    }];
    
    [_cityNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(toCityButton.mas_right).offset(RATIO(18));
        make.centerY.equalTo(toCityButton.mas_centerY);
        make.right.mas_equalTo(cycleScrollView.mas_left);
    }];
    
    [toCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(RATIO(48), RATIO(48)));
        make.centerY.equalTo(self.mas_centerY).offset(DeviceUtils.isIPhoneX ? 20 : 10);
    }];
    
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toCityButton.mas_centerY);
        make.right.mas_equalTo(RATIO(-48));
        make.size.mas_equalTo(CGSizeMake(RATIO(48), RATIO(48)));
    }];
    [self bringSubviewToFront:iv];
    [self bringSubviewToFront:_airIv];
    
    [self httpRequest];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
}

///** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
}

- (void)collectionViewWillDisplay:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UIView * container = [cell.contentView viewWithTag:1111];
    if (![cell.contentView viewWithTag:1111]) {
        container  = [UIView new];
        container.backgroundColor = [UIColor clearColor];
        container.tag = 1111;
        [cell.contentView addSubview:container];
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cell.contentView);
        }];
        
        UILabel * label = [UILabel new];
        label.tag = 100;
        label.font = [UIFont fontWithName:Regular size:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [container addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(container);
            make.top.mas_equalTo(container);
            make.bottom.mas_equalTo(container).with.offset(-20);
        }];
    }
    UILabel * label = [container viewWithTag:100];
    NSInteger idx = indexPath.row % 3;
    
    RHPMItem * item = [[RHPMItem alloc] init];
    if (self.dataArr.count) {
        item = self.dataArr[idx];
    } else {
        item = self.datas[idx];
    }
    
    label.text = [NSString stringWithFormat:@"%@ %@", item.itemText, item.itemValue];
    
    RHAccount * acc = [RHAccountTool account];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:CityInfo];
    
    NSString *name = [NSString stringWithFormat:@"%@", dic[@"name"]];
    if (dic) {
       _cityNameLbl.text = name;
    } else {
        
        if (acc.city.length) {
            _cityNameLbl.text = acc.city;
        } else {
            _cityNameLbl.text = @"--";
        }
    }
}

- (UIImageView *)more
{
    return [self viewWithTag:1000];
}

- (void)tongzhi:(NSNotification *)text
{
    
    RHLog(@"%@",text.userInfo);
    
    RHLog(@"-------receive notification------");
    [self httpRequest];
}

- (void)httpRequest
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:CityInfo];
    
    RHAccount * acc = [RHAccountTool account];
    
    _airFresh.text = GetLocalResStr(@"airpurifier_more_airquality_fresh");
    _airIv.image = [UIImage imageNamed:@"ico_air_s_01"];
    
    NSString *name = @"";
    NSString *latitude = @"";
    NSString *longitude = @"";
    
    if (dic) {
//        _cityNameLbl.text = @"--";
        name = [NSString stringWithFormat:@"%@", dic[@"name"]];
        latitude = [NSString stringWithFormat:@"%@", dic[@"latitude"]];
        longitude = [NSString stringWithFormat:@"%@", dic[@"longitude"]];
    } else {
        
        name = acc.city;
        latitude = acc.latitude;
        longitude = acc.longtidude;
    }


    _cityNameLbl.text = name;
    
    [http_ requestWithMessageName:@"queryWeather" callback:^(ACMsg *responseObject, NSError *error) {
        
        ACObject * obj = [responseObject getACObject:@"actionData"];
        NSDictionary * data = [obj getObjectData];
        
        NSString *noText= [NSString stringWithFormat:@"%@", data[@"NO2"]];
        NSString *oText = [NSString stringWithFormat:@"%@", data[@"O3"]];
        NSString *pm2Text = [NSString stringWithFormat:@"%@", data[@"PM"]];
        
        [self.dataArr removeAllObjects];
        
        NSArray * titles = @[@"PM", @"NO₂", @"O₃"];
        for (int i = 0; i < titles.count; i++) {
            RHPMItem * item = [RHPMItem new];
            item.itemText = titles[i];
            if (i == 0) {
                item.itemValue = pm2Text;
            }else if (i == 1){
                item.itemValue = noText;
            }else{
                item.itemValue = oText;
            }
            
            if (!data.allKeys.count) {
                item.itemValue = @"--";
            }
            
            [self.dataArr addObject:item];
        }
        
        NSInteger overall = [[NSString stringWithFormat:@"%@", data[@"overall"]] integerValue];
        NSInteger airInteger = 0;
        
        if (overall < 20) {
            _airFresh.text = GetLocalResStr(@"airpurifier_more_airquality_fresh");
            _airIv.image = [UIImage imageNamed:@"ico_air_s_01"];
            airInteger = 1;
            
        } else if (20 <= overall && overall < 50) {
            _airFresh.text = GetLocalResStr(@"airpurifier_more_airquality_moderate");
            _airIv.image = [UIImage imageNamed:@"ico_air_02s"];
            airInteger = 2;
            
        } else if (50 <= overall && overall < 100) {
            _airFresh.text = GetLocalResStr(@"airpurifier_more_airquality_high");
            _airIv.image = [UIImage imageNamed:@"ico_air_03s"];
            airInteger = 3;
            
        } else if (100 <= overall && overall < 150) {
            _airFresh.text = GetLocalResStr(@"airpurifier_more_airquality_very");
            _airIv.image = [UIImage imageNamed:@"ico_air_04s"];
            airInteger = 4;
            
        } else if (150 <= overall && overall < 200) {
            _airFresh.text = GetLocalResStr(@"airpurifier_more_airquality_excessive");
            _airIv.image = [UIImage imageNamed:@"ico_air_05s"];
            airInteger = 5;
            
        }else if (200 <= overall && overall < 300) {
            _airFresh.text = GetLocalResStr(@"airpurifier_more_airquality_extreme");
            _airIv.image = [UIImage imageNamed:@"ico_air_06s"];
            airInteger = 6;
            
        } else if (overall >= 300) {
            _airFresh.text = GetLocalResStr(@"airpurifier_more_airquality_airpocalypse");
            _airIv.image = [UIImage imageNamed:@"ico_air_07s"];
            airInteger = 7;
        }
        
        
    } andKeyValues:@"city", name, @"latitude", @(latitude.doubleValue), @"longitude", @(longitude.doubleValue), nil];
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)airQualityRemind:(NSInteger)airInteger
{
    
    
    UAlertView * alert = [[UAlertView alloc]initWithTitle:GetLocalResStr(@"airpurifier_push_pm_alert_title_ios") msg:@"" cancelTitle:GetLocalResStr(@"airpurifier_public_ok") okTitle:nil];
    alert.delegate = self;
    [alert show];

}

- (void)alertView:(UAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
