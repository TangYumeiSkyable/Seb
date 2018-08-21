//
//  RHHomeView.m
//  supor
//
//  Created by 赵冰冰 on 16/6/17.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHHomeView.h"
#import "HomeCell.h"
#import "RHHomeItem.h"
#import "RHAirQualityItem.h"
#import "RHBrezzeView.h"
#import "ACServiceClient.h"
#import "NSString+LKExtension.h"
#import "UIView+WhenTappedBlocks.h"
#import "UIImage+GIF.h"
#import "JNavigationView.h"
#import "CircleIndicatorView.h"
#import "HepaView.h"
#import "SDCycleScrollView.h"
#import "ACIndicatorView.h"

@interface RHHomeView ()<SDCycleScrollViewDelegate, JNavigationDelegate>
{
    UIImageView * _coverageImageView;
}
@property (nonatomic, strong) UIButton * onoffBtn;
@property (nonatomic, strong) UILabel * deviceLabel;
@property (nonatomic, strong) UIButton * lightBtn;
@property (nonatomic, strong) UIButton * dayButton;
@property (nonatomic, strong) UIButton * nightButton;
@property (nonatomic, strong) UIButton * speedButton;
@property (nonatomic, strong) UIButton * sleepButton;
@property (nonatomic, strong) UIButton *anionButton;
@property (nonatomic, strong) UIView * appointContainerView;
@property (nonatomic, strong) CircleIndicatorView * indView;
@property (nonatomic, strong) RHHomeItem * homeItem;
@property (nonatomic, strong) UIButton * gotoAppointBtn;
@property (nonatomic, strong) UIView * bage;
@property (nonatomic, strong) JNavigationView *nav;

@property (strong, nonatomic) ACIndicatorView *indInfoView;

@end

@implementation RHHomeView

//除了gif图片都刷新
- (void)refreshWithoutGif:(RHHomeItem *)homeItem {
    [self refreshWithHomeItem:homeItem];
}
//全部刷新
- (void)refreshWithHomeItem:(RHHomeItem *)homeItem {
    self.deviceLabel.text = homeItem.deviceName;
    self.bage.hidden = !homeItem.flag;
    if (homeItem.on_off == 0) {
        homeItem.hcho = 0;
    }
    
    self.homeItem = homeItem;
    //    //显示预约
    if (isExist(self.homeItem.mDescription) && self.homeItem.timePoint != 0 && self.homeItem.mDescription.length > 0) {
        self.appointContainerView.hidden = NO;
        UILabel * lbl = [self.appointContainerView viewWithTag:1001];
        NSString * str = [self.homeItem.mDescription substringToIndex:1];
        
        NSString * timePoint = [NSString stringWithFormat:@"%ld",(long) homeItem.timePoint];
        NSString * newTimePoint = [timePoint TimeStamp:timePoint timeOffset:0];
        
        if ([str isEqualToString:@"1"]) {
            newTimePoint = [newTimePoint stringByAppendingString:GetLocalResStr(@"airpurifier_more_show_close_text")];
            
        }else{
            newTimePoint = [newTimePoint stringByAppendingString:GetLocalResStr(@"airpurifier_more_show_open_text")];
        }
        
        lbl.text = newTimePoint;
        
        [self.deviceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nav.mas_bottom).offset(RATIO(20));
            make.left.mas_equalTo(RATIO(60));
            make.height.mas_equalTo(RATIO(100));
            make.right.mas_equalTo(self.mas_right).multipliedBy(0.5);
        }];
        
    } else {
        
        self.appointContainerView.hidden = YES;
        [self.deviceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nav.mas_bottom).offset(RATIO(20));
            make.left.mas_equalTo(RATIO(60));
            make.height.mas_equalTo(RATIO(100));
            make.right.mas_equalTo(self.mas_right).offset(-RATIO(66 + 60) - 6);
        }];
    }
    
    /*
     [self.indView setPrecent:self.homeItem.pm25];
     self.indView.hcho = self.homeItem.hcho;
     self.indView.pm25_level = self.homeItem.pm25_level;
     [self.indView refreshWithTVOC:self.homeItem.hcho];
     */
    self.indInfoView.item = self.homeItem;
    [self refreshButtons:homeItem];
}

- (void)refreshPM:(RHHomeItem *)homeItem {
    self.indInfoView.item = self.homeItem;
}

//仅仅刷新gif
- (void)playGifWithHomeItem:(RHHomeItem *)homeItem {
    [self refreshWithHomeItem:homeItem];
}

//仅仅刷新buttons
- (void)refreshButtons:(RHHomeItem *)homeItem {
    // 负离子按钮
    // 仅tefal两款设备有负离子功能
    if (homeItem.subDomainId == 6497 || homeItem.subDomainId == 6498) {
        self.anionButton.hidden = NO;
    } else {
        self.anionButton.hidden = YES;
    }
    
    if (homeItem.on_off) {
        [self.onoffBtn setBackgroundImage:[UIImage imageNamed:@"btn_open"] forState:UIControlStateNormal];
    } else {
        [self.onoffBtn setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    }
    
    if (homeItem.on_off == 0) {
        [self.lightBtn setBackgroundImage:[UIImage imageNamed:@"ico_light_off"] forState:UIControlStateNormal];
        [self.anionButton setBackgroundImage:[UIImage imageNamed:@"ico_anion_off"] forState:UIControlStateNormal];
        
        self.dayButton = [self viewWithTag:200];
        self.nightButton = [self viewWithTag:201];
        self.speedButton = [self viewWithTag:202];
        self.sleepButton = [self viewWithTag:203];
        
        NSArray * arr = @[self.dayButton, self.nightButton, self.speedButton, self.sleepButton];
        NSArray * images = @[@"ico_daily_nor", @"ico_sleep_nor", @"ico_boost_nor", @"ico_mute_nor"];
        //        NSArray * selImages = @[@"ico_daily_sel", @"ico_sleep_sel", @"ico_boost_sel", @"ico_mute_sel"];
        int i = 0;
        for (UIButton * b in arr) {
            b.backgroundColor = RGB(130, 136, 142);
            [b setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            i++;
        }
    } else {
        
        //    0：模式1（最亮）
        //    1：模式2（弱）
        //    2：模式3（灭）
        
        if (homeItem.light == 0) {
            [self.lightBtn setBackgroundImage:[UIImage imageNamed:@"ico_light_high"] forState:UIControlStateNormal];
        } else if (homeItem.light == 1){
            [self.lightBtn setBackgroundImage:[UIImage imageNamed:@"ico_light_low"] forState:UIControlStateNormal];
        } else if (homeItem.light == 2){
            [self.lightBtn setBackgroundImage:[UIImage imageNamed:@"ico_light_off"] forState:UIControlStateNormal];
        }
        // 负离子按钮状态
        if (homeItem.anion == 0) {
            [self.anionButton setBackgroundImage:[UIImage imageNamed:@"ico_anion_off"] forState:UIControlStateNormal];
        } else {
            [self.anionButton setBackgroundImage:[UIImage imageNamed:@"ico_anion_on"] forState:UIControlStateNormal];
        }

        /*
         1：睡眠(V1)
         2：晚上自动(V1 V2)
         3：白天自动(V2 V3 V4)
         4：极速（V5）
         */
        
        
        self.dayButton = [self viewWithTag:200];
        self.nightButton = [self viewWithTag:201];
        self.speedButton = [self viewWithTag:202];
        self.sleepButton = [self viewWithTag:203];
        
        NSArray * arr = @[self.dayButton, self.nightButton, self.speedButton, self.sleepButton];
        NSArray * images = @[@"ico_daily_nor", @"ico_sleep_nor", @"ico_boost_nor", @"ico_mute_nor"];
        NSArray * selImages = @[@"ico_daily_sel", @"ico_sleep_sel", @"ico_boost_sel", @"ico_mute_sel"];
        int i = 0;
        for (UIButton * b in arr) {
            b.backgroundColor = RGB(130, 136, 142);
            [b setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            i++;
        }
        
        if (homeItem.model == 1) {
            [self.sleepButton setBackgroundImage:[UIImage imageNamed:selImages[3]] forState:UIControlStateNormal];
            self.sleepButton.backgroundColor = [UIColor whiteColor];
        } else if (homeItem.model == 2){
            [self.nightButton setBackgroundImage:[UIImage imageNamed:selImages[1]] forState:UIControlStateNormal];
            self.nightButton.backgroundColor = [UIColor whiteColor];
            [self.lightBtn setBackgroundImage:[UIImage imageNamed:@"ico_light_off"] forState:UIControlStateNormal];
        } else if (homeItem.model == 3){
            [self.dayButton setBackgroundImage:[UIImage imageNamed:selImages[0]] forState:UIControlStateNormal];
            self.dayButton.backgroundColor = [UIColor whiteColor];
        } else if (homeItem.model == 4){
            [self.speedButton setBackgroundImage:[UIImage imageNamed:selImages[2]] forState:UIControlStateNormal];
            self.speedButton.backgroundColor = [UIColor whiteColor];
        }
    }
}
//刷新gif和buttons
- (void)refreshButtonsAndGifImage:(RHHomeItem *)homeItem {
    [self refreshWithHomeItem:homeItem];
}

- (void)createUI {
    UIImageView * bgImageView = [UIImageView new];
    bgImageView.image =  DeviceUtils.isIPhoneX ? [UIImage imageNamed:@"home_cell_bg"] : [UIImage imageNamed:@"img_body_bg"];
    [self addSubview:bgImageView];
    
    _coverageImageView = [UIImageView new];
    _coverageImageView.image = DeviceUtils.isIPhoneX ? [UIImage imageNamed:@"home_cell_bgShade"] : [UIImage imageNamed:@"img_body_bg1.png"];
    [self addSubview:_coverageImageView];
    
    self.nav = [JNavigationView new];
//    self.nav.alpha = 0.8;
    self.nav.backgroundColor = [UIColor clearColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, kMainScreenWidth, DeviceUtils.navigationStatusBarHeight);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:12/255.0 green:21/255.0 blue:30/255.0 alpha:0.6].CGColor,
                       (id)[UIColor colorWithRed:12/255.0 green:21/255.0 blue:30/255.0 alpha:0.1].CGColor, nil];
    [_nav.layer addSublayer:gradient];
    
    _nav.delegate = self;
    
    [self addSubview:_nav];
    
    UILabel * deviceLbl = [UILabel new];
    deviceLbl.numberOfLines = 0;
    deviceLbl.font = [UIFont fontWithName:Regular size:15];
    //[UIColor blackColor]
    deviceLbl.textColor = RGB(45, 68, 92);
    [self addSubview:deviceLbl];
    self.deviceLabel = deviceLbl;
    
    UIButton * toAppointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toAppointBtn setBackgroundImage:[UIImage imageNamed:@"ico_setting"] forState:UIControlStateNormal];
    BTN_ADDTARGET(toAppointBtn, @selector(gotoMore));
    [self addSubview:toAppointBtn];
    
    UIView * bage = [UIView new];
    [toAppointBtn addSubview:bage];
    bage.backgroundColor = [UIColor redColor];
    RHBorderRadius(bage, 3.5, 1, [UIColor redColor]);
    self.bage = bage;
    
    self.appointContainerView = [UIView new];
    [self addSubview:self.appointContainerView];
    
    UIImageView * appointIv = [UIImageView new];
    appointIv.image = [UIImage imageNamed:@"ico_clock_s"];
    [self.appointContainerView addSubview:appointIv];
    
    UILabel * timeLbl = [UILabel new];
    timeLbl.font = [UIFont fontWithName:Regular size:15];
    timeLbl.textColor = [UIColor whiteColor];
    timeLbl.tag = 1001;
    [self.appointContainerView addSubview:timeLbl];
    
    UIView * circleView = [UIView new];
    circleView.backgroundColor = [UIColor clearColor];
    [self addSubview:circleView];
    
    
    // 自定义view部分
    /*
     CircleIndicatorView * circleBGIV = [CircleIndicatorView new];
     circleBGIV.backgroundColor = [UIColor clearColor];
     [circleView addSubview:circleBGIV];
     self.indView = circleBGIV;
     */
    
    self.indInfoView = [[ACIndicatorView alloc] init];
    [circleView addSubview:self.indInfoView];
    
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 20, kMainScreenWidth / 2, RATIO(30 + 36 + 24)) shouldInfiniteLoop:YES imageNamesGroup:@[@"PM", @"NO₃", @"O₃", @"aa"]];
    cycleScrollView.autoScrollTimeInterval = 2;
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle =  SDCycleScrollViewPageContolStyleNone;
    [self addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    /*
     [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.centerX.mas_equalTo(self);
     make.top.mas_equalTo(circleBGIV.tvoc.mas_bottom).offset(RATIO(108));
     make.size.mas_equalTo(CGSizeMake(kMainScreenWidth / 2 + 80 , RATIO(150)));
     }];
     */
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.indInfoView.mas_bottom).offset(RATIO(70));
        make.size.mas_equalTo(CGSizeMake(kMainScreenWidth / 2 + 80 , RATIO(150)));
    }];
    
    NSMutableArray * arr = @[].mutableCopy;
    NSArray * images = @[@"ico_daily_nor", @"ico_sleep_nor", @"ico_boost_nor", @"ico_mute_nor"];
    for (int i = 0; i < images.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 200 + i;
        RHBorderRadius(btn, RATIO(90), 1, [UIColor clearColor]);
        BTN_ADDTARGET(btn, @selector(modeBtnClick:));
        btn.backgroundColor = RGB(130, 136, 142);
        [btn setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [self addSubview:btn];
        [arr addObject:btn];
    }
    
    UIButton * onoffBtn = [UIButton new];
    [onoffBtn setBackgroundImage:[UIImage imageNamed:@"btn_open"] forState:UIControlStateNormal];
    BTN_ADDTARGET(onoffBtn, @selector(onoffClick:));
    UILongPressGestureRecognizer * lpgr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lgpr:)];
    [onoffBtn addGestureRecognizer:lpgr];
    [self addSubview:onoffBtn];
    self.onoffBtn = onoffBtn;
    
    UIButton * gotoAppointBtn = [UIButton new];
    gotoAppointBtn.titleLabel.font = [UIFont fontWithName:Regular size:14];
    [gotoAppointBtn setTitle:GetLocalResStr(@"airpurifier_dialog_show_openopintment_text") forState:UIControlStateNormal];
    [gotoAppointBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage * gotoIMg = [UIImage imageWithColor:[UIColor blackColor] cornerRadius:12];
    [gotoAppointBtn setBackgroundImage:gotoIMg forState:UIControlStateNormal];
    gotoAppointBtn.hidden = YES;
    BTN_ADDTARGET(gotoAppointBtn, @selector(gotoAppointmetnt));
    [self addSubview:gotoAppointBtn];
    _gotoAppointBtn = gotoAppointBtn;
    
    UIButton *lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lightButton setBackgroundImage:[UIImage imageNamed:@"ico_light_high"] forState:UIControlStateNormal];
    BTN_ADDTARGET(lightButton, @selector(lightButtonClick:));
    [self addSubview:lightButton];
    self.lightBtn = lightButton;
    
    UIButton *  anionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [anionButton setBackgroundImage:[UIImage imageNamed:@"ico_anion_on"] forState:UIControlStateNormal];
    BTN_ADDTARGET(anionButton, @selector(nanoClick:));
    [self addSubview:anionButton];
    self.anionButton = anionButton;
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [_coverageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [_nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(DeviceUtils.navigationStatusBarHeight);
    }];
    
    [deviceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nav.mas_bottom).offset(RATIO(54 + 180));
        make.left.mas_equalTo(RATIO(60));
        make.height.mas_equalTo(RATIO(60));
        make.right.mas_equalTo(self.mas_right).multipliedBy(0.5);
        
    }];
    
    [toAppointBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-RATIO(60));
        make.size.mas_equalTo(CGSizeMake(RATIO(88), RATIO(88)));
        make.centerY.mas_equalTo(self.appointContainerView);
    }];
    
    [self.appointContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_right).multipliedBy(0.5);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self).with.offset(-40);
        make.centerY.mas_equalTo(deviceLbl);
    }];
    
    [appointIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.appointContainerView);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.appointContainerView);
        make.left.mas_equalTo(appointIv.mas_right).with.offset(5);
    }];
    
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(deviceLbl.mas_bottom).offset(RATIO(30));
        make.centerY.equalTo(self.mas_centerY).offset(-120);
        make.width.mas_equalTo(self).multipliedBy(0.50);
        make.height.mas_equalTo(circleView.mas_width);
        make.centerX.mas_equalTo(self);
    }];
    
    /*
     [circleBGIV mas_makeConstraints:^(MASConstraintMaker *make) {
     make.edges.mas_equalTo(circleView);
     }];
     */
    [self.indInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(circleView);
    }];
    
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:RATIO(204) leadSpacing:RATIO(60) tailSpacing:RATIO(60)];
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cycleScrollView.mas_bottom).offset(RATIO(162));
        make.height.mas_equalTo(RATIO(204));
    }];
    
    UIView * last = [arr lastObject];
    [onoffBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(last.mas_bottom).with.offset(RATIO(108));
        make.size.mas_equalTo(CGSizeMake(RATIO(282), RATIO(282)));
    }];
    
    [gotoAppointBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(onoffBtn.mas_top).with.offset(3);
        make.width.mas_equalTo(self).multipliedBy(0.55);
        make.height.mas_equalTo(30);
    }];
    
    [lightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(onoffBtn.mas_right).with.offset(RATIO(126));
        make.centerY.mas_equalTo(onoffBtn);
        make.size.mas_equalTo(CGSizeMake(RATIO(108), RATIO(108)));
    }];
    
    [anionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_right).multipliedBy(0.15);
        make.centerY.mas_equalTo(onoffBtn);
        make.size.mas_equalTo(CGSizeMake(RATIO(108), RATIO(108)));
    }];
    
    [bage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(toAppointBtn.mas_right).with.offset(-2);
        make.top.mas_equalTo(toAppointBtn);
        make.size.mas_equalTo(CGSizeMake(RATIO(18), RATIO(18)));
    }];
    
}

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
        
        [self whenTapped:^{
            _gotoAppointBtn.hidden = YES;
            
        }];
    }
    return self;
}

#pragma mark - RHHomeViewDelegate

- (void)gotoMore {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoMore)]) {
        [self.delegate performSelector:@selector(gotoMore)];
    }
}

- (void)modeBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(modeChanged:)]) {
        [self.delegate modeChanged:btn.tag - 200];
    }
}

- (void)nanoClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(anionClick)]) {
        [_delegate anionClick];
    }
}

- (void)lgpr:(UILongPressGestureRecognizer *)p {
    switch (p.state) {
        case UIGestureRecognizerStateBegan:
            _gotoAppointBtn.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)gotoAppointmetnt {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoAppointmentVC)]) {
        [self.delegate gotoAppointmentVC];
    }
}

//灯光
- (void)lightButtonClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(lightClick)]) {
        [self.delegate lightClick];
    }
}

/*
 点击开关
 */
- (void)onoffClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchClick)]) {
        [self.delegate switchClick];
    }
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
}

- (void)collectionViewWillDisplay:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    HepaView * container = [cell.contentView viewWithTag:1111];
    if ([cell.contentView viewWithTag:1111] == nil) {
        container  = [HepaView new];
        container.backgroundColor = [UIColor clearColor];
        container.tag = 1111;
        [cell.contentView addSubview:container];
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cell.contentView);
        }];
    }
    
    NSInteger idx = indexPath.item % 4;
    if (idx == 0){
        [container setProgress:round(self.homeItem.filter_initial / 10.0)];
        [container setFilterText:GetLocalResStr(@"airpurifier_more_show_prefilter_tex")];
    }else if (idx == 1){
        [container setProgress:round(self.homeItem.filter_activecarbon / 10.0)];
        [container setFilterText:GetLocalResStr(@"airpurifier_more_show_activefilter_tex")];
    }else if (idx == 2){
        [container setProgress:round(self.homeItem.filter_HEPA / 10.0)];
        [container setFilterText:GetLocalResStr(@"airpurifier_more_show_hepafilter_tex")];
    }else if (idx == 3){
        [container setProgress:round(self.homeItem.filter_nano / 10.0)];
        [container setFilterText:GetLocalResStr(@"airpurifier_more_show_nanofilter_tex")];
    }
    
//    RHLog(@"idx === %zd", idx);
}

- (void)homeViewHidden {
    self.gotoAppointBtn.hidden = YES;
}

#pragma mark - JNavigationDelegate
- (void)didSelectAtIndex:(NSInteger)index {
    
    if (index == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(gotoCountry)]) {
            [_delegate gotoCountry];
        }
    } else {
        
        if (_delegate && [_delegate respondsToSelector:@selector(gotoAirQualityVC)]) {
            [_delegate gotoAirQualityVC];
        }
    }
}


@end

