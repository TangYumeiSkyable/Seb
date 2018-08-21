//
//  PMViewController.m
//  supor
//
//  Created by 白云杰 on 2017/5/19.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "PMViewController.h"
#import "NSString+LKExtension.h"
#import "UIImage+FlatUI.h"
#import "ACObject.h"

@interface PMViewController ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UILabel *airLevelLabel;

@property (nonatomic, strong) UILabel *airNumberLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *powerButton;

@end

@implementation PMViewController

#pragma mark - Lazy Load
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundView;
}

- (UILabel *)airLevelLabel {
    if (!_airLevelLabel) {
        _airLevelLabel = [[UILabel alloc] init];
        _airLevelLabel.text = GetLocalResStr(@"airpurifier_more_show_pm_text_ios");
        _airLevelLabel.textColor = LJHexColor(@"#36424a");
        _airLevelLabel.font = [UIFont fontWithName:Regular size:18];
        _airLevelLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _airLevelLabel;
}

- (UILabel *)airNumberLabel {
    if (!_airNumberLabel) {
        _airNumberLabel = [[UILabel alloc] init];
        _airNumberLabel.textColor = LJHexColor(@"#009dc2");
        _airNumberLabel.font = [UIFont fontWithName:Medium size:22];
        _airNumberLabel.text = [NSString stringWithFormat:@"%@", _dic[@"PM25"]];
        if ([_dic[@"PM25"] integerValue] >= 100) {
            _airNumberLabel.textColor = [UIColor redColor];
        }
    }
    return _airNumberLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = LJHexColor(@"c8c8c8");
        _dateLabel.font = [UIFont fontWithName:Regular size:14];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.text = [self calculateDateWithTimeStamp:[[_dic[@"createTime"] substringToIndex:10] doubleValue]];
    }
    return _dateLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = GetLocalResStr(@"airpurifier_more_show_text_ios");
        _tipLabel.textColor = LJHexColor(@"#c8c8c8");
        _tipLabel.font = [UIFont fontWithName:Regular size:14];
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UIButton *)powerButton {
    if (!_powerButton) {
        _powerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_powerButton setTitle:GetLocalResStr(@"airpurifier_more_show_openair_text") forState:UIControlStateNormal];
        UIImage *image = [UIImage imageWithColor:[UIColor classics_blue] cornerRadius:[[NSString stringWithFormat:@"%.0f", RATIO(156) / 2] floatValue]];
        [_powerButton setBackgroundImage:image forState:UIControlStateNormal];
        _powerButton.titleLabel.font = [UIFont fontWithName:Regular size:14];
        _powerButton.adjustsImageWhenHighlighted = NO;
        BTN_ADDTARGET(_powerButton, @selector(openDeviceAction));
    }
    return _powerButton;
}

#pragma mark - View LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
    [self getMessageInfo];
}

#pragma mark - Common Methods
- (void)configUI {
    self.view.backgroundColor = LJHexColor(@"EEEEEE");
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_openairpurifier_text");
    self.navigationController.navigationBar.translucent = NO;
}

- (void)initViews {
    [self.view addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.airLevelLabel];
    [self.backgroundView addSubview:self.airNumberLabel];
    [self.backgroundView addSubview:self.dateLabel];
    [self.backgroundView addSubview:self.tipLabel];
    [self.view addSubview:self.powerButton];
}

- (void)getMessageInfo {
    [http_ requestWithMessageName:@"queryMessageInfo" callback:^(ACMsg *responseObject, NSError *error) {
        ACObject *obj = [responseObject getACObject:@"actionData"];
        NSDictionary *data = [obj getObjectData];
        
        if ([data[@"powerFlg"] integerValue] == 1) {
            UIImage *image = [UIImage imageWithColor:[UIColor classics_gray] cornerRadius:[[NSString stringWithFormat:@"%.0f", RATIO(156) / 2] floatValue]];
            [_powerButton setBackgroundImage:image forState:UIControlStateNormal];
            _powerButton.userInteractionEnabled = NO;
        } else {
            UIImage * image = [UIImage imageWithColor:[UIColor classics_blue] cornerRadius:[[NSString stringWithFormat:@"%.0f", RATIO(156) / 2] floatValue]];
            [_powerButton setBackgroundImage:image forState:UIControlStateNormal];
            _powerButton.userInteractionEnabled = YES;
        }
    } andKeyValues:@"messageId", @([_dic[@"messageId"] longLongValue]), nil];
}

#pragma mark - Target Methods
- (void)openDeviceAction {
    [self openAirCleaner:[_dic[@"deviceId"] longLongValue] value:1 command:@"on_off"];
}
- (void)openAirCleaner:(long long)deviceId value:(NSInteger)value command:(NSString *)commond {
    
    __block NSString *subDomainName = @"";
    // check subDomain
    [ACBindManager listDevicesWithCallback:^(NSArray *devices, NSError *error) {
        
        if (devices.count) {
            
            for (ACUserDevice *device in devices) {
                if ([_dic[@"deviceId"] integerValue] == device.deviceId) {
                    
                    subDomainName = device.subDomain;
                }
            }
        }
        // control device
        [http_ requestWithMessageName:@"controlDeviceInfo" callback:^(ACMsg *responseObject, NSError *error) {
            
            if (error == nil) {
                UIImage * image = [UIImage imageWithColor:[UIColor classics_gray] cornerRadius:[[NSString stringWithFormat:@"%.0f", RATIO(156) / 2] floatValue]];
                [_powerButton setBackgroundImage:image forState:UIControlStateNormal];
                _powerButton.userInteractionEnabled = NO;
            } else {
                if (error.code == 3807) {
                    [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_moredevice_show_devicenotonline_text")];
                }else{
                    [ZSVProgressHUD showSimpleText:TIPS_FAILED_CONTROL];
                }
            }
            
        } andKeyValues:@"deviceId", @(deviceId), @"value" , @(value), @"commend", commond, @"sn", @(1), @"subDomainName", subDomainName, nil];
        
    }];
}

#pragma mark - Private Methods
- (NSString *)calculateDateWithTimeStamp:(double)timeStamp {
    NSString *distanceStr;
    
    NSDate *beDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [dateFormatter stringFromDate:beDate];
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *nowDay = [dateFormatter stringFromDate:[NSDate date]];
    NSString *lastDay = [dateFormatter stringFromDate:beDate];
    
    if([nowDay isEqualToString:lastDay]){
        distanceStr = [NSString stringWithFormat:@"%@",timeStr];
    } else {
        NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:beDate];
        distanceStr = [weekday objectAtIndex:components.weekday];
    }
    return distanceStr;
}

#pragma mark - System Methods
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(RATIO(60));
        make.left.right.mas_equalTo(0);
    }];
    
    [self.airLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
    }];
    
    [self.airNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_top).offset(RATIO(36));
        make.left.equalTo(self.airLevelLabel.mas_right).offset(RATIO(60));
        make.centerY.equalTo(self.airLevelLabel.mas_centerY);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_top).offset(RATIO(40));
        make.right.mas_equalTo(-20);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.airLevelLabel.mas_left);
        make.top.equalTo(self.airNumberLabel.mas_bottom).offset(RATIO(30));
        make.right.mas_equalTo(-20);
        make.bottom.equalTo(self.backgroundView.mas_bottom).offset(-RATIO(50));
    }];
    
    [self.powerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RATIO(90));
        make.right.mas_equalTo(-RATIO(90));
        make.bottom.mas_equalTo(-RATIO(174));
        make.height.mas_equalTo(RATIO(156));
    }];
}

@end
