//
//  ACIndicatorView.m
//  supor
//
//  Created by Jun Zhou on 2017/10/30.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "ACIndicatorView.h"

#import "SDCycleScrollView.h"
#import "TVOCDescView.h"
#import "PMDescView.h"
#import "IndicatorTitleView.h"

/** PM25 */
typedef NS_ENUM(NSInteger, PM25State) {
    PM25StateGood   = 1,
    PM25StateAverage,
    PM25StateBad,
};

/** TVOC */
typedef NS_ENUM(NSInteger, TVOCState) {
    TVOCStateNone   = 0,
    TVOCStateGood,
    TVOCStateAverage,
    TVOCStateBad,
};

@interface ACIndicatorView () <SDCycleScrollViewDelegate>

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic) NSArray *imgStrArr;
@property (strong, nonatomic) TVOCDescView *tvocDescView;
@property (strong, nonatomic) PMDescView *pmDescView;
@property (strong, nonatomic) PMDescView *singlePmView;
@property (strong, nonatomic) IndicatorTitleView *titleView;
@end

@implementation ACIndicatorView

// MARK: - getter

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
    }
    return _backgroundImageView;
}

- (TVOCDescView *)tvocDescView {
    if (_tvocDescView == nil) {
        _tvocDescView = [[TVOCDescView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _tvocDescView.tag = 1002;
    }
    return _tvocDescView;
}

- (PMDescView *)pmDescView {
    if (_pmDescView == nil) {
        _pmDescView = [[PMDescView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _pmDescView.tag = 1001;
    }
    return _pmDescView;
}

- (SDCycleScrollView *)cycleScrollView {
    if (_cycleScrollView == nil) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, 0, 0)
                                                    shouldInfiniteLoop:YES
                                                       imageNamesGroup:@[@"PM25",@"TVOC"]];
        _cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScroll = YES;
        _cycleScrollView.pageControlStyle =  SDCycleScrollViewPageContolStyleNone;
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _cycleScrollView.userInteractionEnabled = NO;
    }
    return _cycleScrollView;
}

- (PMDescView *)singlePmView {
    if (_singlePmView == nil) {
        _singlePmView = [[PMDescView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    return _singlePmView;
}

- (IndicatorTitleView *)titleView {
    if (_titleView == nil) {
        _titleView = [[IndicatorTitleView alloc] init];
    }
    return _titleView;
}

// MARK: - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

// MARK: - setupSubViews

- (void)setupSubViews {
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.cycleScrollView];
    [self addSubview:self.singlePmView];
    [self addSubview:self.titleView];
    
}

// MARK: - layout

-(void)layoutSubviews {
    [super layoutSubviews];
    
    WEAKSELF(ws);
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws);
    }];
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(ws);
        make.height.mas_equalTo(ws.frame.size.height * 0.5);
    }];
    
    [self.singlePmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(ws);
        make.height.mas_equalTo(ws.frame.size.height * 0.5);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(ws);
        make.height.equalTo(ws).multipliedBy(0.5);
    }];
}

// MARK: - setter data fill

- (void)setItem:(RHHomeItem *)item {
    _item = item;
    
    //  设置背景图片
    [self setupBackgroundStateWithItem:item];
    
    // 设置pm25 tvoc轮询
    [self setupPm25AndTvocStateWithItem:item];
}



- (void)setupBackgroundStateWithItem:(RHHomeItem *)item {
    
    UIImage *backgroundImage = nil;
    AirPureState airPureState = AirPureStateGood;
    switch (item.pm25_level) {
            
        case PM25StateGood: {  // PM good
            
            switch (item.hcho) {
                case TVOCStateGood: {  // blue
                    backgroundImage = GETIMG(@"img_circle_bg_01");
                    airPureState = AirPureStateGood;
                    break;
                }
                case TVOCStateAverage: {  // purple
                    backgroundImage = GETIMG(@"img_circle_bg_02");
                    airPureState = AirPureStateAverage;
                    break;
                }
                case TVOCStateBad: {  // red
                    backgroundImage = GETIMG(@"img_circle_bg_03");
                    airPureState = AirPureStateBad;
                    break;
                }
                default:  // blue
                    backgroundImage = GETIMG(@"img_circle_bg_01");
                    airPureState = AirPureStateGood;
                    break;
            }
            break;
        }
        case PM25StateAverage: {  // PM average // purple
            
            switch (item.hcho) {
                case TVOCStateGood: {  // blue
                    backgroundImage = GETIMG(@"img_circle_bg_02");
                    airPureState = AirPureStateAverage;
                    break;
                }
                case TVOCStateAverage: {  // purple
                    backgroundImage = GETIMG(@"img_circle_bg_02");
                    airPureState = AirPureStateAverage;
                    break;
                }
                case TVOCStateBad: {  // red
                    backgroundImage = GETIMG(@"img_circle_bg_03");
                    airPureState = AirPureStateBad;
                    break;
                }
                default:  // purple
                    backgroundImage = GETIMG(@"img_circle_bg_02");
                    airPureState = AirPureStateAverage;
                    break;
            }
            break;
        }
        case PM25StateBad: {  // PM bad // red
            
            switch (item.hcho) {
                case TVOCStateGood: {  // blue
                    backgroundImage = GETIMG(@"img_circle_bg_03");
                    airPureState = AirPureStateBad;
                    break;
                }
                case TVOCStateAverage: {  // purple
                    backgroundImage = GETIMG(@"img_circle_bg_03");
                    airPureState = AirPureStateBad;
                    break;
                }
                case TVOCStateBad: {  // red
                    backgroundImage = GETIMG(@"img_circle_bg_03");
                    airPureState = AirPureStateBad;
                    break;
                }
                default:  // red
                    backgroundImage = GETIMG(@"img_circle_bg_03");
                    airPureState = AirPureStateBad;
                    break;
            }
            break;
        }
        default:
            backgroundImage = GETIMG(@"img_circle_bg_01");
            airPureState = AirPureStateGood;
            break;
    }
    
    self.titleView.airPureState = airPureState;
    self.backgroundImageView.image = backgroundImage;
}

- (void)setupPm25AndTvocStateWithItem:(RHHomeItem *)item {
    
    // 设置PM
    if (item.pm25 == 0) {
        self.pmDescView.pm25Value = [NSString stringWithFormat:@"--"];
        self.singlePmView.pm25Value = [NSString stringWithFormat:@"--"];
    } else {
        self.pmDescView.pm25Value = [NSString stringWithFormat:@"%zd", item.pm25];
        self.singlePmView.pm25Value = [NSString stringWithFormat:@"%zd", item.pm25];
    }
    
    // 设置显示 XL型号设备显示
    if (item.subDomainId == 5376 || item.subDomainId == 6495 || item.subDomainId == 6497) {
        if (item.hcho == TVOCStateNone) {
            self.cycleScrollView.hidden = YES;
            self.singlePmView.hidden = NO;
        } else {
            self.cycleScrollView.hidden = NO;
            self.singlePmView.hidden = YES;
        }
    } else {
        self.cycleScrollView.hidden = YES;
        self.singlePmView.hidden = NO;
    }
    
    // 设置TVOC显示
    switch (item.hcho) {
        case TVOCStateGood: {
            self.tvocDescView.image = GETIMG(@"ico_face_happy");
            break;
        }
        case TVOCStateAverage: {
            self.tvocDescView.image = GETIMG(@"ico_face_general");
            break;
        }
        case TVOCStateBad: {
            self.tvocDescView.image = GETIMG(@"ico_face_sad");
            break;
        }
        default:
            //self.tvocDescView.image = GETIMG(@"ico_face_sad");
            break;
    }
    
}



// MARK: - SDCycleScrollViewDelegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {

}

- (void)collectionViewWillDisplay:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if (self.item.subDomainId == 5376 || self.item.subDomainId == 6495 || self.item.subDomainId == 6497) {  // XL型号设备显示
        
        if (indexPath.row % 2 == 0) {
            if (![cell.contentView viewWithTag:1001]) {
                [cell.contentView addSubview:self.pmDescView];
                [self.pmDescView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(cell.contentView);
                }];
            }
            
        } else {
            if (![cell.contentView viewWithTag:1002]) {
                [cell.contentView addSubview:self.tvocDescView];
                [self.tvocDescView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(cell.contentView);
                }];
            }
            
        }
    }
}


@end
