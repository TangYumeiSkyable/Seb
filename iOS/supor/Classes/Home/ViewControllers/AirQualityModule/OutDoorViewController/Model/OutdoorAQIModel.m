//
//  OutdoorAQIModel.m
//  supor
//
//  Created by 刘杰 on 2018/3/26.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "OutdoorAQIModel.h"

@interface OutdoorAQIModel ()

@property (nonatomic, strong) NSArray *AQITitleArray;

@property (nonatomic, strong) NSArray *AQIDescriptionArray;

@property (nonatomic, strong) NSArray *airLevelImageNameArray;

@property (nonatomic, strong) NSArray *airLevelTextArray;

@end

@implementation OutdoorAQIModel

- (NSMutableArray *)retreatmentWithDictionary:(NSDictionary *)dataDictionary {
    NSMutableArray *tempArray = [NSMutableArray array];
    
    NSString *NO2String= [NSString stringWithFormat:@"%@", dataDictionary[@"NO2"]];
    NSString *O3String = [NSString stringWithFormat:@"%@", dataDictionary[@"O3"]];
    NSString *PM25String = [NSString stringWithFormat:@"%@", dataDictionary[@"PM2_5"]];
    NSString *PM10String = [NSString stringWithFormat:@"%@", dataDictionary[@"PM10"]];
    NSInteger airPollutionNumber = [[NSString stringWithFormat:@"%@", dataDictionary[@"overall"]] integerValue];
    NSArray *AQIValueArray = @[NO2String, O3String, PM25String, PM10String];
    
    [self lj_getAirLevelTextWithAirPollutionValue:airPollutionNumber];
    
    for (int i = 0; i < AQIValueArray.count; i++) {
        OutdoorAQIModel *tempModel = [[OutdoorAQIModel alloc] init];
        tempModel.AQIName = self.AQITitleArray[i];
        tempModel.AQIValue = AQIValueArray[i];
        tempModel.AQIDescription = self.AQIDescriptionArray[i];
        tempModel.isSelected = i == 0 ? YES : NO;
        
        [tempArray addObject:tempModel];
    }
    return tempArray;
}

- (void)lj_getAirLevelTextWithAirPollutionValue:(NSInteger)pollutionValue {
    if (pollutionValue < 20) {
        self.airLevelText = self.airLevelTextArray[0];
        self.airLevelImageName = self.airLevelImageNameArray[0];
    } else if (20 <= pollutionValue && pollutionValue < 50) {
        self.airLevelText = self.airLevelTextArray[1];
        self.airLevelImageName = self.airLevelImageNameArray[1];
    } else if (50 <= pollutionValue && pollutionValue < 100) {
        self.airLevelText = self.airLevelTextArray[2];
        self.airLevelImageName = self.airLevelImageNameArray[2];
    } else if (100 <= pollutionValue && pollutionValue < 150) {
        self.airLevelText = self.airLevelTextArray[3];
        self.airLevelImageName = self.airLevelImageNameArray[3];
    } else if (150 <= pollutionValue && pollutionValue < 200) {
        self.airLevelText = self.airLevelTextArray[4];
        self.airLevelImageName = self.airLevelImageNameArray[4];
    }else if (200 <= pollutionValue && pollutionValue < 300) {
        self.airLevelText = self.airLevelTextArray[5];
        self.airLevelImageName = self.airLevelImageNameArray[5];
    } else if (pollutionValue >= 300) {
        self.airLevelText = self.airLevelTextArray[6];
        self.airLevelImageName = self.airLevelImageNameArray[6];
    }
}

#pragma mark - Lazyload Methods
- (NSArray *)AQITitleArray {
    if (!_AQITitleArray) {
        _AQITitleArray = @[GetLocalResStr(@"airpurifier_more_airquality_tvno2"),
                           GetLocalResStr(@"airpurifier_more_airquality_tvo3"),
                           GetLocalResStr(@"airpurifier_more_airquality_tvpm25"),
                           GetLocalResStr(@"airpurifier_more_airquality_tvpm10")
                           ];
    }
    return _AQITitleArray;
}

- (NSArray *)AQIDescriptionArray {
    if (!_AQIDescriptionArray) {
        _AQIDescriptionArray = @[GetLocalResStr(@"airpurifier_more_airquality_no2"),
                                 GetLocalResStr(@"airpurifier_more_airquality_o3"),
                                 GetLocalResStr(@"airpurifier_more_airquality_pm25"),
                                 GetLocalResStr(@"airpurifier_more_airquality_pm10")
                                 ];
    }
    return _AQIDescriptionArray;
}

- (NSArray *)airLevelTextArray {
    if (!_airLevelTextArray) {
        _airLevelTextArray = @[GetLocalResStr(@"airpurifier_more_airquality_fresh"),
                               GetLocalResStr(@"airpurifier_more_airquality_moderate"),
                               GetLocalResStr(@"airpurifier_more_airquality_high"),
                               GetLocalResStr(@"airpurifier_more_airquality_very"),
                               GetLocalResStr(@"airpurifier_more_airquality_excessive"),
                               GetLocalResStr(@"airpurifier_more_airquality_extreme"),
                               GetLocalResStr(@"airpurifier_more_airquality_airpocalypse")
                               ];
    }
    return _airLevelTextArray;
}

- (NSArray *)airLevelImageNameArray {
    if (!_airLevelImageNameArray) {
        _airLevelImageNameArray = @[@"ico_air_01m_sel",
                                    @"ico_air_02m_sel",
                                    @"ico_air_03m_sel",
                                    @"ico_air_04m_sel",
                                    @"ico_air_05m_sel",
                                    @"ico_air_06m_sel",
                                    @"ico_air_07m_sel"
                                    ];
    }
    return _airLevelImageNameArray;
}

@end

