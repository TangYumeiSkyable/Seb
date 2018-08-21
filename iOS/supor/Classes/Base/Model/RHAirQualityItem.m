//
//  RHAirQualityItem.m
//  supor
//
//  Created by 赵冰冰 on 16/6/20.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHAirQualityItem.h"

@implementation RHAirQualityItem

- (void)refreshMaxGrade {
    [self refreshWithPM25];
    [self refreshWithTVOC];
    self.grade = MAX(self.grade1, self.grade2);
    
//    [self resetLbls:self.grade];
    [self resetLbls:self.grade2];
}

- (void)resetLbls:(NSInteger)g {
    if (g == 1) {
        _airQualityLevel = @"一级";
        _airQualityString = @"优";
        _airQualityString = GetLocalResStr(@"airpurifier_push_home_you_ios");
        _healthyAffectString = @"空气质量令人满意";
        _runingSuggestString = @"正常户外跑步";
    }else if (g == 2){
        _airQualityLevel = @"二级";
        _airQualityString = @"良";
        _airQualityString = GetLocalResStr(@"airpurifier_push_show_poor_text_ios");
        _healthyAffectString = @"极少数易敏感人群有较弱影响";
        _runingSuggestString = @"基本不受影响";
    }else if (g == 3){
        _airQualityLevel = @"三级";
        _airQualityString = @"轻度污染";
        _airQualityString = GetLocalResStr(@"airpurifier_push_qing_ios");
        _healthyAffectString = @"易感人群症轻度加剧 健康人群有刺激症状";
        _runingSuggestString = @"减少户外跑步时间";
    }else if (g == 4){
        _airQualityLevel = @"四级";
        _airQualityString = @"中度污染";
        _airQualityString = GetLocalResStr(@"airpurifier_push_zhong_ios");
        _healthyAffectString = @"易感人群症加剧 健康人群呼吸或受影响";
        _runingSuggestString = @"减少户外跑步时间";
    }else if (g == 5){
        
        _airQualityLevel = @"四级";
        _airQualityString = @"重度污染";
        _airQualityString = GetLocalResStr(@"airpurifier_push_zhongdu_ios");
        _healthyAffectString = @"心肺症状显著加剧运动耐受力降低";
        _runingSuggestString = @"停止户外运动";
    }
}

- (void)refreshWithPM25 {
    if (self.pm25 <= 50 && self.pm25 >= 0) {
        self.grade1 = 1;
    } else if(self.pm25 <= 100) {
        self.grade1 = 2;
    } else if (self.pm25 <= 150) {
        self.grade1 = 3;
    } else if (self.pm25 <= 200) {
        self.grade1 = 4;
    } else if(self.pm25 > 200) {
        self.grade1 = 5;
    }
    [self resetLbls:self.grade1];
}

- (void)refreshWithTVOC {
    switch (self.tvoc) {
        case 1:
        {
            self.grade2 = 1;

        }
            break;
        case 2:
        {
            self.grade2 = 2;

        }
            break;
        case 3:
        {
            self.grade2 = 3;

        }
            break;
        case 4:
        {
            self.grade2 = 4;

        }
            break;
        case 5:
        {
            self.grade2 = 5;

        }
            break;
        default:
        {
            self.grade2 = 1;
        }
            break;
    }
    [self resetLbls:self.grade2];
}

@end
