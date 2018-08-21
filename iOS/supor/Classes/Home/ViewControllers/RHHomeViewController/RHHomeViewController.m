//
//  RHHomeViewController.m
//  supor
//
//  Created by 赵冰冰 on 16/6/17.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHHomeViewController.h"
#import "FilterStateViewController.h"
#import "NoDeviceViewController.h"
#import "AppointmentViewController.h"
#import "RHBaseNavgationController.h"
#import "SelectCountryViewController.h"
#import "OutDoorViewController.h"
#import "MoreViewController.h"
#import "LoginViewController.h"

#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "RHHomeView.h"
#import "RHLeftButton.h"
#import "HomeTitleView.h"
#import "AirAlertView.h"
#import "BrezzeSpeenButton.h"
#import "RHBrezzeView.h"
#import "Cell_HomeCollection.h"
#import "RHAccountTool.h"
#import "RHHomeItem.h"
#import "RHAirQualityItem.h"
#import "RHHomeLayout.h"
#import "ACPushManager.h"
#import "HomeAlert.h"
#import "Reachability.h"
#import "OrderInfoLibrary.h"
#import "UAlertView.h"
#import "ACProductManager.h"
#import "ACProduct.h"
#import "ACOTAManager.h"
#import "ACOTACheckInfo.h"
#import "ACOTAUpgradeInfo.h"
#import "NSString+LKExtension.h"
#import "NSTimer+Add.h"
#import "UINavigationBar+FlatUI.h"
#import "INTULocationManager.h"

#import <StoreKit/StoreKit.h>
#import <Availability.h>

@interface RHHomeViewController ()<
UIScrollViewDelegate,
RHHomeViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
RHBrezzeViewDelegate,
CLLocationManagerDelegate,
UINavigationControllerDelegate,
UAlertViewDelegate
>
{
    NSTimer *_timer;
    NSInteger count;
}

@property (nonatomic, strong) HomeTitleView *titleView;
@property (nonatomic, strong) UIView *firstOpenView;
@property (nonatomic, strong) RHBrezzeView *brezzeView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger reqeustCount;
@property (nonatomic, assign) NSInteger currentPage; //当前页
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSMutableArray *tempDatas;
@property (nonatomic, strong) RHHomeLayout *layout;
@property (nonatomic, strong) NSString *pm25;
@property (nonatomic, strong) ACPushManager * pushMgr;
@property (nonatomic, strong) ACPushTable *table;
@property (nonatomic, assign) NSInteger lastSpeed;
@property (nonatomic, strong) NSMutableArray *deviceArr;
@property (nonatomic, strong) ACOTAUpgradeInfo *checkInfo;
@property (nonatomic, assign) NSInteger aircount;
@property (nonatomic,strong) NSTimer *timer;

@end

static NSInteger sn = 0;
static int mCount = 0;
static const double kOrderRequestTime = 3.0;

@implementation RHHomeViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
    [self initDatas];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fd_prefersNavigationBarHidden = YES;
    // per 3 seconds request devices info
    self.timer = [NSTimer m_scheduledTimerWithTimeInterval:kOrderRequestTime
                                                     block:^(NSTimer *mTimer) {
                                                         [self requestDeviceRealtimeInfo];
                                                     }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkDevicesList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [HomeAlert dismiss];
    [ZSVProgressHUD dismiss];
    [self.pushMgr disconnect];
    
    NSArray *cells = [self.collectionView visibleCells];
    for (Cell_HomeCollection * cell in cells) {
        [cell.homeView homeViewHidden];
    }
    
    _timer.fireDate = [NSDate distantFuture];
    _timer = nil;
    [_timer invalidate];
}

#pragma mark - common Methods
- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fd_prefersNavigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)initViews {
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    RHHomeLayout * layout = [[RHHomeLayout alloc] init];
    self.layout = layout;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) collectionViewLayout:layout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerClass:[Cell_HomeCollection class] forCellWithReuseIdentifier:@"Cell_HomeCollection"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (void)initDatas {
    [self addNotificationObserver];
    // 获取所有产品主/子域等信息并缓存
    [self getAllDevicesInfo];
    
    // 默认显示一个空设备数据的界面
    RHHomeItem *item = [[RHHomeItem alloc] init];
    [self.datas addObject:item];
    [self.collectionView reloadData];
    
    // query location
    AppDelegate *appD = [AppDelegate sharedInstance];
    [appD initializeLocationService];
    
    
    self.pm25 = @"";
    self.aircount = 0;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:CityInfo];
    if (dic) {
        [self requestLocalOutdoorAirQuality];
    }
    
    [self checkWifiConnect];
    
    [self uploadUserLanguageInfo];
}

-(void)watchTable:(NSInteger)page {
    WEAKSELF(ws);
    
    [self.pushMgr connectWithCallback:^(NSError *error) {
        
        if (error == nil) {
            [ws watchTableForUpdate:page];
        } else {
            RHLog(@"push 失败");
            [ws.pushMgr disconnect];
            mCount++;
            if (mCount < 3) {
                [ws watchTable:page];
            }
        }
    }];
}

- (void)watchTableForUpdate:(NSInteger)page {
    WEAKSELF(ws);
    if (ws.datas.count > 0) {
            //NSInteger page = page_;
        RHHomeItem *item = ws.datas[page];
        ACObject *primaryKey = [[ACObject alloc] init];
        [primaryKey put:@"deviceId" value:@(item.deviceId)];
        
        ACPushTable *mtable = [[ACPushTable alloc] init];
        mtable.className = @"DeviceInfoManager";
        [mtable setOpType:OPTYPE_UPDATE];
        [mtable setPrimaryKey:primaryKey];
        ws.table = mtable;
        
        @try {
            [ws.pushMgr unWatchAll];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ws.pushMgr watchWithTable:mtable Callback:^(NSError *error) {
                    if (error == nil) {
                        RHLog(@"watch table 成功,page is %ld", self.currentPage);
                        [ws.pushMgr onReceiveWithCallback:^(ACPushReceive *pushReceive, NSError *error) {
                            
                            if (count > 0) {
                                return;
                            }
                            BOOL refreshGif = NO;
                            ACObject *obj = pushReceive.payload;
                            
                            NSArray *changeArr = [obj getKeys];
                            
                            RHHomeItem * curItem = self.datas[self.currentPage];
                            
//                            RHLog(@"current page is %ld, data is %@", page_, [obj getObjectData]);
                            NSDictionary *data = [obj getObjectData];
                            
                            NSInteger deviceId = [data[@"deviceId"] integerValue];
                            
                            if (curItem.deviceId != deviceId) {
                                return;
                            }
                            
                            for (NSString *key in changeArr) {
                                if ([key isEqualToString:@"speed"]) {
                                    NSInteger speed = [obj getInteger:@"speed"];
                                    if (speed != curItem.speed) {
                                        refreshGif = YES;
                                    }
                                    curItem.speed = speed;
                                } else if ([key isEqualToString:@"model"]) {
                                    curItem.model = [obj getInteger:@"model"];
                                } else if ([key isEqualToString:@"sleep"]) {
                                    curItem.sleep = [obj getInteger:@"sleep"];
                                } else if ([key isEqualToString:@"on_off"]) {
                                    curItem.on_off = [obj getInteger:@"on_off"];
                                } else if ([key isEqualToString:@"anion"]) {
                                    curItem.anion = [obj getInteger:@"anion"];
                                } else if ([key isEqualToString:@"light"]) {
                                    curItem.light = [obj getInteger:@"light"];
                                } else if ([key isEqualToString:@"pm25"]) {
                                    curItem.pm25 = [obj getInteger:@"pm25"];
                                } else if ([key isEqualToString:@"hcho"]) {
                                    curItem.hcho = [obj getInteger:@"hcho"];
                                } else if ([key isEqualToString:@"filter_HEPA"]) {
                                    curItem.filter_HEPA = [obj getInteger:@"filter_HEPA"];
                                } else if ([key isEqualToString:@"filter_nano"]) {
                                    curItem.filter_nano = [obj getInteger:@"filter_nano"];
                                } else if ([key isEqualToString:@"timePoint"]) {
                                    curItem.timePoint = [obj getInteger:@"timePoint"];
                                } else if ([key isEqualToString:@"description"]) {
                                    curItem.mDescription = [obj getString:@"description"];
                                } else if ([key isEqualToString:@"work_mode"]) {
                                    
                                } else if ([key isEqualToString:@"error"]) {
                                    curItem.error = [obj getLong:@"error"];
                                } else if ([key isEqualToString:@"filter_change4"]) {
                                    curItem.filter_change4 =  [obj getLong:key];
                                } else if ([key isEqualToString:@"filter_initial"]) {
                                    curItem.filter_change4 =  [obj getLong:key];
                                } else if ([key isEqualToString:@"filter_change1"]) {
                                    curItem.filter_change4 =  [obj getLong:key];
                                } else if ([key isEqualToString:@"filter_activecarbon"]) {
                                    curItem.filter_change4 =  [obj getLong:key];
                                } else if ([key isEqualToString:@"pm25_level"]) {
                                    curItem.pm25_level = [obj getLong:key];
                                }
                            }
                            
                            Cell_HomeCollection *cell = (Cell_HomeCollection *)[ws.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:0]];
                            
                                //如果设备后盖没关好
                            if (item.error == 1) {
                                [self showAlert];
                            }
                            
                            if (refreshGif) {
                                [cell.homeView refreshWithHomeItem:curItem];
                            } else {
                                [cell.homeView refreshWithoutGif:curItem];
                            }
                        }];
                    } else {
                        RHLog(@"watch table 失败");
                    }
                }];
            });
        } @catch (NSException *exception) {
            
        }
    }
}

- (void)setReqeustCount:(NSInteger)reqeustCount {
    if (_reqeustCount != reqeustCount) {
        _reqeustCount = reqeustCount;
        if (reqeustCount == 0) {
            [self group_notify];
        }
    }
}


#pragma mark - userEvaluation Methods
- (void)userEvaluation {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    int appOpenNumber = (int)[userDefault integerForKey:@"numberCount"];
    
    if (appOpenNumber==5 &&self.datas.count>0) {
        
        NSString *version = [UIDevice currentDevice].systemVersion;
        if ([version floatValue]>=10.3) {
            
            [SKStoreReviewController requestReview];
        }
    }
}


- (void)group_notify {
    RHLog(@"所有请求都完成了");
    [self userEvaluation];
    [self.datas removeAllObjects];
    [self.datas addObjectsFromArray:self.tempDatas];
    [self.tempDatas removeAllObjects];
    if (self.currentPage >= self.datas.count) {
        self.currentPage = 0;
    }
    
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"deviceId" ascending:YES];
    [self.datas sortUsingDescriptors:@[sort]];
    
    //    WEAKSELF(ws);
    for (NSInteger i = 0; i < self.datas.count; i++) {
        RHHomeItem *item = self.datas[i];
        item.index = i;
        if (self.currentPage == i) {
            item.isCurrent = YES;
        }
        
        //如果设备不在线
        if (self.currentPage == i) {
                //如果设备离线
            if (!(item.status == 1 || item.status == 3)) {
                item.on_off = 0;
                item.pm25 = 0;
                [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_moredevice_show_devicenotonline_text")];
            } else {
                if (item.error == 1) {
                    [self showAlert];
                }
            }
        }
    }
    
    if (self.datas.count > 0) {
        [self.collectionView reloadData];
        CGFloat contentOffset = self.currentPage * kMainScreenWidth;
        self.collectionView.contentOffset = CGPointMake(contentOffset, 0);
        if (self.datas.count > 1) {
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *str = [ud objectForKey:UD_FIRST_OPEN];
            if (![str isEqualToString:@"1"] ) {
                [self firstOpenView];
            }
        } else if (self.datas.count == 1){
            
            NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
            NSString * str = [ud objectForKey:UD_FIRST_SHOW_NOTIFI_ALERT];
            if (![str isEqualToString:@"1"]) {
                
                UAlertView * alert = [[UAlertView alloc] initWithTitle:GetLocalResStr(@"airpurifier_more_show_notifications_text")
                                                                   msg:GetLocalResStr(@"airpurifier_more_show_cookiestitleitem_text")
                                                           cancelTitle:GetLocalResStr(@"airpurifier_more_show_nothank_text")
                                                               okTitle:GetLocalResStr(@"airpurifier_more_show_settings_text")];
                [alert setOKButtonFont:[UIFont fontWithName:Regular size:15] andCancelButtonFont:[UIFont fontWithName:Regular size:15]];
                alert.delegate = self;
                alert.tag = 12345;
                [alert show];
                NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:@"1" forKey:UD_FIRST_SHOW_NOTIFI_ALERT];
            }
        }
        
        [self watchTable:self.currentPage];
        self.deviceArr = [NSMutableArray arrayWithArray:self.datas];
        [self validateUpdete];
        
    } else {
        AppDelegate * app = [AppDelegate sharedInstance];
        NoDeviceViewController *vc = [[NoDeviceViewController alloc]init];
        RHBaseNavgationController *nc = [[RHBaseNavgationController alloc]initWithRootViewController:vc];
        app.window.rootViewController = nc;
    }
}

#pragma mark - UICollectionViewLayoutDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell_HomeCollection *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_HomeCollection" forIndexPath:indexPath];
    cell.homeView.delegate = self;
    cell.homeView.tag = indexPath.row + 1000;
    [cell.homeView refreshWithHomeItem:self.datas[indexPath.item]];
    return cell;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / self.collectionView.frame.size.width;
    self.layout.currIndexPath = [NSIndexPath indexPathForItem:(NSInteger)page inSection:0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    count = 0;
    NSInteger page = scrollView.contentOffset.x / self.collectionView.frame.size.width;
    self.layout.currIndexPath = [NSIndexPath indexPathForItem:(NSInteger)page inSection:0];

    NSArray * cells = [self.collectionView visibleCells];
    for (Cell_HomeCollection * cell in cells) {
        [cell.homeView homeViewHidden];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger lastPage = self.currentPage;
    self.currentPage = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    RHHomeItem * item = self.datas[self.currentPage];
    item.isCurrent = YES;
    if (lastPage != self.currentPage) {
        RHHomeItem * item2 = self.datas[lastPage];
        item2.isCurrent = NO;
    }
    
    NSIndexPath * idx = [NSIndexPath indexPathForItem:self.currentPage inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:@[idx]];
    [self requestDeviceRealtimeInfo];
    [self watchTableForUpdate:self.currentPage];
}

#pragma mark - RHHomeViewDelegate
- (void)currentHomeView:(RHHomeView *)homeView andAirItem:(RHAirQualityItem *)airItem andHomeItem:(RHHomeItem *)homeItem color:(UIColor *)color_ {
    self.collectionView.backgroundColor = color_;
    Cell_HomeCollection *cell = nil;
    UIView *superView = homeView.superview;
    while (![superView isKindOfClass:[UICollectionViewCell class]]) {
        superView = superView.superview;
    }
    cell = (Cell_HomeCollection *)superView;
    
    RHAccount *acc = [RHAccountTool account];
    
    NSString *cityName = acc.outdoorCity;
    if ([cityName containsString:@"市"]) {
        NSRange range = [cityName rangeOfString:@"市"];
        cityName = [cityName substringToIndex:range.location];
    }
    
    RHAirQualityItem *aItem = nil;
    NSString * pm25 = @"";
    if (self.pm25.length != 0) {
        pm25 = self.pm25;
        
        aItem = [[RHAirQualityItem alloc] init];
        aItem.pm25 = pm25.integerValue;
        [aItem refreshWithPM25];
    }
    
    if ([cityName isEqualToString:@"--"]) {
        cityName = @"北京";
    }
    
}

- (void)gotoAirQualityVC {
    OutDoorViewController *outVC = [OutDoorViewController new];
    [self.navigationController pushViewController:outVC animated:YES];
}

- (void)gotoCountry {
    SelectCountryViewController *country = [[SelectCountryViewController alloc] init];
    country.popStyle = SelectCityVCPopToRoot;
    [self.navigationController pushViewController:country animated:YES];
}

- (void)gotoAppointmentVC {
    AppointmentViewController *appointVC = [[AppointmentViewController alloc]init];
    appointVC.lastControllerType = SchedulingFromHome;
    RHHomeItem * item = self.datas[self.currentPage];
    appointVC.deviceId = item.deviceId;
    [self.navigationController pushViewController:appointVC animated:YES];
}

- (void)gotoMore {
    MoreViewController *moreVC =[[MoreViewController alloc] init];
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void)gotoFilterVC {
    FilterStateViewController * filterVC = [[FilterStateViewController alloc]init];
    [self.navigationController pushViewController:filterVC animated:YES];
}

#pragma mark - Control Action
- (void)switchClick {
    if (self.datas.count <= self.currentPage ) {
        return;
    }
    RHHomeItem * item = self.datas[self.currentPage];
    [self controlDevice:0 value:!item.on_off itemIndex:self.currentPage andItem:item];
}

/**
 *  点击了风速按钮
 *
 *  @param brezzeBtn
 */

- (void)_brezzeBtnClicked:(BrezzeSpeenButton *)brezzeBtn
{
    if (self.datas.count <= self.currentPage ) {
        return;
    }
    RHHomeItem * item = self.datas[self.currentPage];
    [self controlDevice:1 value:brezzeBtn.brezze itemIndex:self.currentPage andItem:item];
}

    //1：睡眠(V1)
    //2：晚上自动(V1 V2)
    //3：白天自动(V2 V3 V4)              4：极速（V5）

- (void)modeChanged:(NSInteger)idx {
    if (self.datas.count <= self.currentPage ) {
        return;
    }
    RHHomeItem * item = self.datas[self.currentPage];
    NSInteger value = 0;
    if (idx == 0) {
        value = 3;
    }else if (idx == 1){
        value = 2;
    }else if (idx == 2){
        value = 4;
    }else if (idx == 3){
        value = 1;
    }
    
    [self controlDevice:2 value:value itemIndex:self.currentPage andItem:item];
}

////改变模式
- (void)autoBtnClicked:(RHHomeView *)homeView {
    if (self.datas.count <= self.currentPage ) {
        return;
    }
    RHHomeItem * item = self.datas[self.currentPage];
    NSInteger value = 0;
    
    if (item.model == 0) {
        value = 2;
    }else{
        value = 0;
    }
    [self controlDevice:2 value:value itemIndex:self.currentPage andItem:item];
}

- (void)sleepBtnClicked:(RHHomeView *)homeView {
    if (self.datas.count <= self.currentPage ) {
        return;
    }
    RHHomeItem * item = self.datas[self.currentPage];
    [self controlDevice:3 value:!item.sleep itemIndex:self.currentPage andItem:item];
}

    //负离子
- (void)anionClick {
    if (self.datas.count <= self.currentPage ) {
        return;
    }
    RHHomeItem * item = self.datas[self.currentPage];
    [self controlDevice:4 value:!item.anion itemIndex:self.currentPage andItem:item];
}

    //0：模式1（最亮）
    //1：模式2（弱）
    //2：模式3（灭）
    //强光
- (void)lightClick {
    if (self.datas.count <= self.currentPage ) {
        return;
    }
    RHHomeItem * item = self.datas[self.currentPage];
    long lignt = item.light;
    
        //    if (lignt == 0) {
        //        lignt = 1;
        //    }else if (lignt == 1){
        //        lignt = 2;
        //    }else if (lignt == 2){
        //        lignt = 0;
        //    }
    
    if (item.model == 2) {
        return;
        if (lignt == 0) {
            lignt = 2;
        }else if (lignt == 1){
            lignt = 2;
        }else if (lignt == 2){
            lignt = 1;
        }
        
    } else {
        
        if (lignt == 0) {
            lignt = 1;
        }else if (lignt == 1){
            lignt = 2;
        }else if (lignt == 2){
            lignt = 0;
        }
    }
    
    [self controlDevice:5 value:lignt itemIndex:self.currentPage andItem:item];
}

- (void)controlDevice:(NSInteger)idx value:(NSInteger)value itemIndex:(NSInteger)itemIndex andItem:(RHHomeItem *)homeItem {
    
    if (homeItem.on_off == 0 && idx != 0) {
        return;
    }
    
    NSArray * array = @[@"on_off", @"speed", @"model", @"model", @"anion", @"light"];
    RHHomeItem * item = self.datas[itemIndex];
    long long deviceId = item.deviceId;
    Order order = -1;
    
    RHHomeItem * copyItem = [homeItem mutableCopy];
        //开关
    if (idx == 0) {
        if (value == 0) {
            order = OrderOff;
            copyItem.on_off = 0;
        }
        if (value == 1) {
            order = OrderOn;
            copyItem.on_off = 1;
        }
    }
    if (idx == 1) {
        
            //如果选择风速， 关闭自动和睡眠
        copyItem.model = 2;
        if (value == 1) {
            order = OrderWindSpeed_1;
            copyItem.speed = 1;
        }
        if (value == 2) {
            order = OrderWindSpeed_2;
            copyItem.speed = 2;
        }
        if (value == 3) {
            order = OrderWindSpeed_3;
            copyItem.speed = 3;
        }
        if (value == 4) {
            order = OrderWindSpeed_4;
            copyItem.speed = 4;
        }
    }
    
        //自动或者手动
    if (idx == 2) {
        
        if (value == 1) {
            order = OrderAuto;
            copyItem.model = 1;
        }
        if (value == 2) {
            order = OrderManual;
            copyItem.model = 2;
        }else if (value == 3){
            copyItem.model = 3;
        }else if (value == 4){
            copyItem.model = 4;
        }
    }
    
#warning 睡眠非睡眠
    if (idx == 3) {
        
        if (value == 0) {
            order = OrderManual;
            copyItem.model = 2;
        }
        
        if (value == 1) {
            order = OrderSleep;
            copyItem.model = 1;
        }
    }
    
    if (idx == 4) {
        
        if (value == 0) {
            order = OrderAnion_off;
            copyItem.anion = 0;
        }
        if (value == 1) {
            order = OrderAnio_on;
            copyItem.anion = 1;
        }
    }
    
    if (idx == 5) {
        
        if (value == 0) {
            order = OrderLampOff;
            copyItem.light = 0;
        }
        if (value == 1) {
            order = OrderLamp_1;
            copyItem.light = 1;
        }
        if (value == 2) {
            order = OrderLamp_2;
            copyItem.light = 2;
        }
    }
    
    
    RHHomeItem * aItem = copyItem;
    RHHomeItem * originalItem = self.datas[itemIndex];
    [self.datas replaceObjectAtIndex:itemIndex withObject:aItem];
    
        //代表刷新风速
    if (idx == 1) {
        
        Cell_HomeCollection * cell = (Cell_HomeCollection *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0]];
        [cell.homeView refreshButtonsAndGifImage:copyItem];
        
    }else{
        
            //直接刷cell
        Cell_HomeCollection * cell = (Cell_HomeCollection *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0]];
        [cell.homeView refreshButtons:copyItem];
        RHLog(@"%@",@(copyItem.model));
    }
    
    if (idx == 1) {
        
        WEAKSELF(ws);
        RHHomeItem * aItem = copyItem;
        
        [self.datas replaceObjectAtIndex:itemIndex withObject:aItem];
        
        Cell_HomeCollection * cell = (Cell_HomeCollection *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0]];
        [cell.homeView refreshButtonsAndGifImage:copyItem];
        count++;
        [http_ requestWithMessageName:@"controlDeviceInfo" callback:^(ACMsg *responseObject, NSError *error) {
            
            if (error) {
                
                if (error.code==3807) {
                    [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_moredevice_show_devicenotonline_text")];
                    originalItem.on_off = 0;
                    originalItem.pm25 = 0;
                    [ws.datas replaceObjectAtIndex:itemIndex withObject:originalItem];
                    [cell.homeView refreshButtonsAndGifImage:originalItem];
                    
                }else{
                    [ZSVProgressHUD showSimpleText:TIPS_FAILED_CONTROL];
                    [ws.datas replaceObjectAtIndex:itemIndex withObject:originalItem];
                    [cell.homeView refreshButtonsAndGifImage:originalItem];
                    
                    
                }//                [cell.homeView refreshButtonsAndGifImage:homeItem];
                count--;
                
            }else{
                
                RHLog(@"控制success");
                [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(countstimer) userInfo:nil repeats:NO];
            }
            
            
            
        } andKeyValues:@"deviceId", @(deviceId), @"value" , @(value), @"commend", array[idx], @"subDomainName", item.subDomainName ,nil];
        
    }else{
        WEAKSELF(ws);
//        RHHomeItem * aItem = copyItem;
//        [self.datas replaceObjectAtIndex:itemIndex withObject:aItem];
//            //直接刷cell
        Cell_HomeCollection * cell = (Cell_HomeCollection *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0]];
//        [cell.homeView refreshButtons:copyItem];
        count++;
        [http_ requestWithMessageName:@"controlDeviceInfo" callback:^(ACMsg *responseObject, NSError *error) {
            
            if (error) {
                count--;
                if (error.code==3807) {
                    
                    [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_moredevice_show_devicenotonline_text")];
                    originalItem.on_off = 0;
                    originalItem.pm25 = 0;
                    [ws.datas replaceObjectAtIndex:itemIndex withObject:originalItem];
                    [cell.homeView refreshButtonsAndGifImage:originalItem];
                    
                }else{
                    [ZSVProgressHUD showSimpleText:TIPS_FAILED_CONTROL];
                    [ws.datas replaceObjectAtIndex:itemIndex withObject:originalItem];
                    [cell.homeView refreshButtonsAndGifImage:originalItem];
                }//
                
                    //                [cell.homeView refreshButtons:homeItem];
                
            }else{
                
                RHLog(@"控制success");
                if (idx==2||idx==0) {
                    count--;
                } else {
                    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(countstimer) userInfo:nil repeats:NO];
                }
            }
        } andKeyValues:@"deviceId", @(deviceId), @"value" , @(value), @"commend", array[idx] , @"sn" , @(sn % 256), @"subDomainName", item.subDomainName, nil];
    }
    sn++;
}

- (void)homeView:(RHHomeView *)homeView messageLblClicked:(UILabel *)msgLbl {
    if ([msgLbl.text containsString:GetLocalResStr(@"airpurifier_dialog_show_openopintment_text")]) {
        RHHomeItem * item = self.datas[self.currentPage];
        AppointmentViewController * appointVC = [[AppointmentViewController alloc]init];
        appointVC.deviceId = item.deviceId;
        appointVC.deviceName = item.deviceName;
        appointVC.lastControllerType = SchedulingFromHome;
        [self.navigationController pushViewController:appointVC animated:YES];
    }
}

- (void)countstimer {
    count--;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)old {
        //将经度显示到label上
    NSString *longtitude = [NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude];
        //将纬度现实到label上
    NSString *latitude = [NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude];
    
    RHAccount *acc = [RHAccountTool account];
    acc.longtidude = longtitude;
    acc.latitude = latitude;
    
    [RHAccountTool saveAccount:acc];
    
    WEAKSELF(ws);
        // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
//            NSString *text = placemark.name;
            //获取城市
            
            NSString *province  = placemark.administrativeArea;
            NSString *city = placemark.locality;
            NSString *subcity = placemark.subLocality;
            
            if ([acc.outdoorCity isEqualToString:@"--"]) {
                acc.outdoorCity = city;
            }
            
            acc.province = province;
            acc.city = city;
            acc.district = subcity;
            
            city =[NSString stringWithFormat:@"%@ %@ %@", province, city, subcity];
            acc.cityName = city;
            [RHAccountTool saveAccount:acc];
            
            
            NSString * cityName = acc.outdoorCity;
            if ([cityName containsString:@"市"]) {
                NSRange range = [cityName rangeOfString:@"市"];
                cityName = [cityName substringToIndex:range.location];
            }
            
            [RHAccountTool saveAccount:acc];
            
            NSNotification *notification =[NSNotification notificationWithName:@"cityChange" object:nil userInfo:nil];
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            if (self.aircount == 0) {
                [self requestLocalOutdoorAirQuality];
            } else {
                RHLog(@"已经请求过了");
            }
            
            //  应该仅仅刷当前的nav
            if (self.currentPage < self.datas.count) {
//                NSIndexPath *idxpath = [NSIndexPath indexPathForItem:self.currentPage inSection:0];
//                Cell_HomeCollection *cell = (Cell_HomeCollection *)[self.collectionView cellForItemAtIndexPath:idxpath];
                
                [ws updateOutdoorPM25];
            }
            
        } else if (error == nil && [array count] == 0) {
            RHLog(@"No results were returned.");
        } else if (error != nil) {
            RHLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

#pragma mark - UAlertView Delegate
- (void)alertView:(UAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 12345) {
        if (buttonIndex == 1) {
            // 跳转到推送设置页面
            UIViewController * vc = [sys loadFromStoryboard:@"LoginAndRegister" andId:@"ShezhiTableViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    if (alertView.tag == 666666) {
        if (buttonIndex == 0) {
            
            RHHomeItem * item = self.deviceArr.firstObject;
            [ACOTAManager confirmUpdateWithSubDomain:RHSUBDOMAIN
                                            deviceId:item.deviceId
                                          newVersion:self.checkInfo.targetVersion
                                             otaType:ACOTACheckInfoTypeCustom
                                            callback:^(NSError *error) {
                                                if (!error) {
    //                    [self.deviceArr removeObjectAtIndex:0];
    //                    if (self.deviceArr.count) {
    //                        [self validateUpdete];
    //                    }
    //                } else {
    //                        [self showUpdeteAlert];
    //                }
                                                }
                                            }];
        }
    }
    
    if (alertView.tag == 666668888) {
        
    }
}

#pragma mark - Notification Actions
- (void)applicationWillResignActive:(NSNotification *)notification {
    [self.pushMgr disconnect];
}

- (void)applicationDidBecomeActive:(NSNotification *)notificaiton {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    if (0 != reach.currentReachabilityStatus){
        [self watchTableForUpdate:self.currentPage];
    }
    if ([[self getCurrentVC] isEqual:self]) {
        [self checkDevicesList];
    }
}

- (void)locationNotify:(NSNotification *)notify {
    RHLog(@"homevc 收到定位");
    NSDictionary * userInfo = notify.userInfo;
    CLLocationManager * manager = userInfo[@"manager"];
    CLLocation * newLocation = userInfo[@"newLocation"];
//    [self locationManager:manager didUpdateLocations:@[newLocation]];
    [self locationManager:manager didUpdateToLocation:newLocation fromLocation:nil];
}

#pragma mark - System Methods
- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Target Actions
- (void)firstOpenViewCloseButtonAction {
    [self.firstOpenView removeFromSuperview];
}

#pragma mark - Private Methods
// get all devices and set new device models
- (void)getAllDevicesInfo {
    // AC get all devices
    [ACProductManager fetchAllProducts:^(NSArray<ACProduct *> *products, NSError *error) {
        if (!error && products.count > 0) {
            NSArray *productsArray = [NSArray arrayWithArray:products];
            NSMutableArray *productsTempArray = [NSMutableArray array];
            for (ACProduct *product in productsArray) {
                NSDictionary *productDic = product.mj_keyValues;
                [productsTempArray addObject:productDic];
            }
            [[NSUserDefaults standardUserDefaults] setObject:productsTempArray forKey:DeviceArr];
            //DCP synchronize Appliances Content
            [DCPServiceUtils syncContent:DCPServiceContentAppliances callback:^(ACMsg *responseMsg, NSError *error) {
                
                NSArray *appliancesContentArray  = [[[responseMsg get:@"content"] getObjectData] objectForKey:@"objects"];
                NSArray *deviceArr = [[NSUserDefaults standardUserDefaults] objectForKey:DeviceArr];
                NSMutableArray *newDevicesArray = [NSMutableArray array];
                // 比对sdk和dcp获取的数据，相同的设备构建新的字典并缓存到app本地
                for (NSDictionary *contentDic in appliancesContentArray) {
                    for (NSDictionary *deviceDic in deviceArr) {
                        if ([deviceDic[@"model"] isEqualToString:contentDic[@"id"]]) {
                            NSDictionary *newDic = @{@"model":contentDic[@"id"],
                                                     @"name":contentDic[@"name"],
                                                     @"thumbs":contentDic[@"medias"][0][@"thumbs"],
                                                     @"subDomainId":deviceDic[@"subDomainId"],
                                                     @"subDomain":deviceDic[@"subDomain"]};
                            [newDevicesArray addObject:newDic];
                        }
                    }
                }
                [[NSUserDefaults standardUserDefaults] setObject:newDevicesArray forKey:Device];
            }];
        }
    }];
}

- (void)showUpdeteAlert {
    UAlertView * alert = [[UAlertView alloc]initWithTitle:GetLocalResStr(@"airpurifier_more_show_updatedevice_title")
                                                      msg:[NSString stringWithFormat:GetLocalResStr(@"airpurifier_more_show_updatedevice_content"),self.checkInfo.oldVersion, self.checkInfo.targetVersion]
                                              cancelTitle:GetLocalResStr(@"airpurifier_public_ok")
                                                  okTitle:nil];
    alert.delegate = self;
    alert.tag = 666666;
    [alert show];
}

- (void)validateUpdete {
    // OTA Update
    for (RHHomeItem *item in self.deviceArr) {
        ACOTACheckInfo *check = [ACOTACheckInfo checkInfoWithDeviceId:item.deviceId otaType:ACOTACheckInfoTypeCustom];
        [ACOTAManager checkUpdateWithSubDomain:item.subDomainName
                                  OTACheckInfo:check
                                      callback:^(ACOTAUpgradeInfo *checkInfo, NSError *error) {
            
                                          if (!error) {
                                              self.checkInfo = checkInfo;
                                              if (checkInfo.update && self.checkInfo.targetVersion) {
                                                  [ACAccountManager getUserProfile:^(ACObject *profile, NSError *error) {
                                                      BOOL isOTANotify = [profile getBool:@"notifyFlg4"];
                                                      if (isOTANotify) {
                                                          [self showUpdeteAlert];
                                                      }
                                                  }];
                                              }
                                          }
                                      }];
    }
}

// 根据选择定位请求当地室外空气质量
- (void)requestLocalOutdoorAirQuality {
    self.aircount = 1;
    
    // during 7:00 ~ 21:00 time range, no pop up dialog
    if (![NSString isInTheRange]) {
        return;
    }
    
    RHAccount *currentAccount = [RHAccountTool account];
    // if notification has been push twice, no more dialog
    NSInteger notificationPushNumber = [currentAccount.airDic[[NSString strKey]] integerValue];
    if (notificationPushNumber >= 2) {
        return;
    }
    
    NSDictionary *cityInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:CityInfo];
    
    NSString *cityName = @"";
    NSString *latitude = @"";
    NSString *longitude = @"";
    
    if (cityInfoDic) {
        cityName = [NSString stringWithFormat:@"%@", cityInfoDic[@"name"]];
        latitude = [NSString stringWithFormat:@"%@", cityInfoDic[@"latitude"]];
        longitude = [NSString stringWithFormat:@"%@", cityInfoDic[@"longitude"]];
    } else {
        cityName = currentAccount.city;
        latitude = currentAccount.latitude;
        longitude = currentAccount.longtidude;
    }
    
    [http_ requestWithMessageName:@"queryWeather" callback:^(ACMsg *responseObject, NSError *error) {
        
        ACObject *weatherObject = [responseObject getACObject:@"actionData"];
        NSDictionary *weatherDic = [weatherObject getObjectData];
        
        NSInteger overall = [[NSString stringWithFormat:@"%@", weatherDic[@"overall"]] integerValue];
        NSInteger airLevel = 0;
        
        if (overall < 20) {
            airLevel = 1;
        } else if (20 <= overall && overall < 50) {
            airLevel = 2;
        } else if (50 <= overall && overall < 100) {
            airLevel = 3;
        } else if (100 <= overall && overall < 150) {
            airLevel = 4;
        } else if (150 <= overall && overall < 200) {
            airLevel = 5;
        }else if (200 <= overall && overall < 300) {
            airLevel = 6;
        } else if (overall >= 300) {
            airLevel = 7;
        }
        
        // If the air quality now is same as the last air quality, no more dialog
        NSInteger airQuality = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString strKey]];
        if (airQuality == airLevel) {
            return;
        }
        
        [self popUpQualityDialogWithAirLevel:airLevel];
    } andKeyValues:@"city", cityName, @"latitude", @(latitude.doubleValue), @"longitude", @(longitude.doubleValue), nil];
}

- (void)popUpQualityDialogWithAirLevel:(NSInteger)airLevel {
    
    [[NSUserDefaults standardUserDefaults] setInteger:airLevel forKey:[NSString strKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *dialogText = @"";
    
    // check airLevel and select random text template
    NSInteger randomNumber = arc4random() % 2;
    if (airLevel == 1) {
        dialogText = randomNumber == 0 ? GetLocalResStr(@"airpurifier_outdoor_airquality_notification_1_a") : GetLocalResStr(@"airpurifier_outdoor_airquality_notification_1_b");
    } else if (airLevel == 2) {
        return;
    } else if (airLevel == 3) {
        dialogText = GetLocalResStr(@"airpurifier_outdoor_airquality_notification_3_a");
    } else if (airLevel == 4) {
        dialogText = randomNumber == 0 ? GetLocalResStr(@"airpurifier_outdoor_airquality_notification_4_a") : GetLocalResStr(@"airpurifier_outdoor_airquality_notification_4_b");
    } else if (airLevel == 5 || airLevel == 6 || airLevel == 7) {
        dialogText = randomNumber == 0 ? GetLocalResStr(@"airpurifier_outdoor_airquality_notification_5_a") : GetLocalResStr(@"airpurifier_outdoor_airquality_notification_5_b");
    }
    
    UAlertView * alert = [[UAlertView alloc] initWithTitle:GetLocalResStr(@"airpurifier_push_pm_alert_title_ios") msg:dialogText cancelTitle:GetLocalResStr(@"airpurifier_public_ok") okTitle:nil];
    alert.delegate = self;
    alert.tag = 66668888;
    [alert show];
    
    // RHAccount saves current pop up dialog times
    RHAccount * acc = [RHAccountTool account];
    NSInteger integer = [acc.airDic[[NSString strKey]] integerValue];
    integer += 1;
    acc.airDic = @{[NSString strKey]:@(integer)};
    [RHAccountTool saveAccount:acc];
}

- (void)requestDeviceRealtimeInfo {
    [ACBindManager listDevicesWithStatusCallback:^(NSArray *devices, NSError *error) {
        if (error == nil) {
            if (devices.count > 0) {
                
                AppDelegate *app = [AppDelegate sharedInstance];
                app.deviceList = devices;
                
                ACUserDevice *userDevice = nil;
                for (ACUserDevice *device in [AppDelegate sharedInstance].deviceList) {
                    
                    RHHomeItem *item = self.datas[self.currentPage];
                    if (device.deviceId == item.deviceId) {
                        userDevice = device;
                        break;
                    }
                }
                [self updateDeviceInfoWithDevice:userDevice page:self.currentPage state:1];
            }
        }
    }];
}

- (void)updateDeviceInfoWithDevice:(ACUserDevice *)device page:(NSInteger)page state:(NSInteger )state {
    WEAKSELF(ws);
    [http_ requestWithMessageName:@"queryDeviceInfo" callback:^(ACMsg *responseObject, NSError *error) {
        
        ACObject *obj = [responseObject getACObject:@"actionData"];
        NSDictionary *dataDic = [obj getObjectData];
        RHHomeItem *item = [RHHomeItem initWithDict:dataDic];
        if (item == nil) {
            item = [[RHHomeItem alloc]init];
            item.filter_HEPA = -1;
            item.filter_nano = -1;
        }
        item.deviceId = device.deviceId;
        item.deviceName = device.deviceName;
        
        item.userId = [RHAccountTool account].user_ID;
        item.ownerId = device.ownerId;
        item.subDomainId = device.subDomainId;
        item.index = ws.currentPage;
        item.status = device.status;
        item.subDomainName = device.subDomain;
        
        RHHomeItem *lastItem = ws.datas[page];
        item.model = lastItem.model;
        [ws.datas replaceObjectAtIndex:page withObject:item];
        
        //如果设备离线
        if (!(item.status == 1 || item.status == 3)) {
            item.on_off = 0;
            item.pm25 = 0;
        } else {
            if (item.error == 1) {
                [self showAlert];
            }
        }
        
        if (device.status == ACDeviceStatusOffline) {
            item.on_off = 0;
        }
        
        if (state == 1) {
            Cell_HomeCollection *cell = (Cell_HomeCollection *)[ws.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:0]];
            [cell.homeView refreshPM:item];
        } else {
            //如果设备后盖没关好
            [ws.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:page inSection:0]]];
        }
    } andKeyValues:@"deviceId", @(device.deviceId), nil];
}

- (void)showAlert {
    UAlertView *alert = [[UAlertView alloc] initWithTitle:GetLocalResStr(@"airpurifier_more_show_deviceFailure_text")
                                                      msg:GetLocalResStr(@"airpurifier_more_show_rightcovers_text")
                                              cancelTitle:GetLocalResStr(@"airpurifier_public_ok")
                                                  okTitle:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert show];
    });
}

#pragma mark checkDevicesList Methos Group
- (void)checkDevicesList {
    // network status
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if (0 == reach.currentReachabilityStatus) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"airpurifier_login_show_tosneterror_text") duration:1];
        });
    }
    
    mCount = 0;
    count = 0;
    
    [ACBindManager listDevicesWithStatusCallback:^(NSArray *devices, NSError *error) {
        if (error == nil) {
            if (devices.count == 0) {
                AppDelegate *app = [AppDelegate sharedInstance];
                NoDeviceViewController *noDeviceVC = [[NoDeviceViewController alloc] init];
                RHBaseNavgationController *noDeviceNC = [[RHBaseNavgationController alloc] initWithRootViewController:noDeviceVC];
                app.window.rootViewController = noDeviceNC;
                app.deviceList = @[];
            } else {
                AppDelegate * app = [AppDelegate sharedInstance];
                app.deviceList = devices;
                [self httpReqeust];
            }
        } else {
            // 根据错误信息，选择跳转到登录界面还是没有设备界面
            // According to the error message, choose to skip to the login screen or no device interface.
            AppDelegate * app = [AppDelegate sharedInstance];
            app.deviceList = @[];
            if (error.code == 3014 || error.code == 3015 || error.code == 3514 || error.code == 3515 || error.code == 3516) {
                RHAccount *acc = [RHAccountTool account];
                [[AppDelegate sharedInstance] removeAlias:[NSString stringWithFormat:@"%ld", (long)acc.user_ID]];
                [RHAccountTool cleanAccount];
                
                AppDelegate *app = [AppDelegate sharedInstance];
                RHBaseNavgationController *loginNC = [[RHBaseNavgationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
                app.window.rootViewController = loginNC;
#warning "NO Toast Message"
            } else {
                AppDelegate *app = [AppDelegate sharedInstance];
                NoDeviceViewController *noDeviceVC = [[NoDeviceViewController alloc]init];
                RHBaseNavgationController *noDeviceNC = [[RHBaseNavgationController alloc] initWithRootViewController:noDeviceVC];
                app.window.rootViewController = noDeviceNC;
            }
        }
    }];
    [self updateOutdoorPM25];
}

- (void)httpReqeust {
    // 如果上一次循环请求还没有完成
    if (self.reqeustCount > 0) {
        return;
    }
    AppDelegate *app = [AppDelegate sharedInstance];
    [self.devices removeAllObjects];
    [self.devices addObjectsFromArray:app.deviceList];
    self.reqeustCount = self.devices.count;
    for (ACUserDevice *device in self.devices) {
        [self queryDeviceInfo:device];
    }
}

- (void)queryDeviceInfo:(ACUserDevice *)device {
    WEAKSELF(ws);
    [http_ requestWithMessageName:@"queryDeviceInfo" callback:^(ACMsg *responseObject, NSError *error) {
        
        ACObject *obj = [responseObject getACObject:@"actionData"];
        NSDictionary *data = [obj getObjectData];
        // 构建homeItem
        RHHomeItem *item = [RHHomeItem initWithDict:data];
        item.deviceId = device.deviceId;
        item.deviceName = device.deviceName;
        item.ownerId = device.ownerId;
        item.subDomainId = device.subDomainId;
        item.status = device.status;
        item.subDomainName = device.subDomain;
        RHAccount *acc = [RHAccountTool account];
        item.userId = acc.user_ID;
        if (item) {
            [ws.tempDatas addObject:item];
        } else {
            // 如果有坏链就舍
            RHHomeItem *aItem = [[RHHomeItem alloc] init];
            aItem.filter_HEPA = -1;
            aItem.filter_nano = -1;
            aItem.deviceId = device.deviceId;
            aItem.deviceName = device.deviceName;
            aItem.status = device.status;
            aItem.ownerId = device.ownerId;
            aItem.subDomainId = device.subDomainId;
            aItem.subDomainName = device.subDomain;
            [ws.tempDatas addObject:aItem];
            RHAccount * acc = [RHAccountTool account];
            aItem.userId = acc.user_ID;
        }
        ws.reqeustCount--;
    } andKeyValues:@"deviceId", @(device.deviceId), nil];
}

- (void)updateOutdoorPM25 {
    RHAccount *acc = [RHAccountTool account];
    
    NSString *cityName = acc.outdoorCity;
    if ([cityName containsString:@"市"]) {
        NSRange range = [cityName rangeOfString:@"市"];
        cityName = [cityName substringToIndex:range.location];
    }
    
    [self queryOutdoorPM25WithCityName:cityName];
}

- (void)queryOutdoorPM25WithCityName:(NSString *)cityName {
    ACMsg *req = [ACMsg msgWithName:RHSUBDOMAIN];
    [req setName:@"getLatestData"];
    [req put:@"area" value:cityName];
    
    WEAKSELF(ws);
//    [ACServiceClient sendToAnonymousService:@"zc-pm25"
//                                    version:1
//                                        msg:req
//                                   callback:^(ACMsg *responseMsg, NSError *error) {
//                                       if (error == nil) {
//                                           NSDictionary *dict = [responseMsg getObjectData];
//                                           ws.pm25 = [NSString stringWithFormat:@"%@", dict[@"value"]];
//
//                                           if (self.datas.count > 0) {
//                                               NSString *pm25 = @"";
//                                               if (self.pm25) {
//                                                   pm25 = self.pm25;
//                                               }
//
//                                               RHAirQualityItem *airItem = [[RHAirQualityItem alloc] init];
//                                               airItem.pm25 = pm25.integerValue;
//                                               [airItem refreshWithPM25];
//                                           }
//                                       }
//    }];
    
    [ACServiceClient sendToServiceWithoutSignWithSubDomain:RHSUBDOMAIN
                                               ServiceName:@"zc-pm25"
                                            ServiceVersion:1
                                                       Req:req
                                                  Callback:^(ACMsg *responseMsg, NSError *error) {
                                                      if (error == nil) {
                                                          NSDictionary *dict = [responseMsg getObjectData];
                                                          ws.pm25 = [NSString stringWithFormat:@"%@", dict[@"value"]];

                                                          if (self.datas.count > 0) {
                                                              NSString *pm25 = @"";
                                                              if (self.pm25) {
                                                                  pm25 = self.pm25;
                                                              }

                                                              RHAirQualityItem *airItem = [[RHAirQualityItem alloc] init];
                                                              airItem.pm25 = pm25.integerValue;
                                                              [airItem refreshWithPM25];
                                                          }
                                                      }
                                                  }];
}

#pragma mark -----

// 检查网络环境，当为移动蜂窝网络/wifi时，请求数据
- (void)checkWifiConnect {
    WEAKSELF(ws);
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr startMonitoring];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                RHLog(@"AFNetworkReachabilityStatusUnknown");
                [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"airpurifier_login_show_tosneterror_text")];
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                RHLog(@"AFNetworkReachabilityStatusNotReachable");
                [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"airpurifier_login_show_tosneterror_text")];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                RHLog(@"AFNetworkReachabilityStatusReachableViaWWAN");
                [ws watchTableForUpdate:ws.currentPage];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                RHLog(@"AFNetworkReachabilityStatusReachableViaWiFi");
                [ws watchTableForUpdate:ws.currentPage];
                break;
        }
    }];
}

- (void)addNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationNotify:) name:NOTIFY_LOCATION object:nil];
}
// 获取用户当前语言，用于推送消息的多语言化
- (void)uploadUserLanguageInfo {
    ACObject *languageObject = [[ACObject alloc] init];
    [languageObject put:@"systemLanguage" value:[LanguageManager appLanguage]];
    [ACAccountManager setUserProfile:languageObject callback:^(NSError *error) {
        if (error) {
            RHLog(@"upload language failure");
        } else {
            RHLog(@"upload language success");
        }
    }];
}

#pragma mark - Lazyload Methods
- (ACPushManager *)pushMgr {
    if (_pushMgr == nil) {
        _pushMgr = [ACPushManager sharedManager];
    }
    return _pushMgr;
}

-(NSMutableArray *)devices {
    if (_devices == nil) {
        _devices = @[].mutableCopy;
    }
    return _devices;
}

-(NSMutableArray *)tempDatas {
    if (_tempDatas == nil) {
        _tempDatas = @[].mutableCopy;
    }
    return _tempDatas;
}

- (NSArray *)colors {
    if (_colors == nil) {
        _colors = @[RGB(95, 190, 239), RGB(61, 214, 115), RGB(243, 186, 92), RGB(176, 106, 245), RGB(246, 119, 100)];
    }
    return _colors;
}

-(NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

-(UIView *)firstOpenView {
    @try {
        if (_firstOpenView == nil) {
            _firstOpenView = [UIView new];
            _firstOpenView.backgroundColor = RGBA(0, 0, 0, 0.6);
            [self.view addSubview:_firstOpenView];
            [_firstOpenView  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            
            UIImageView * imageView = [UIImageView new];
            imageView.image = [UIImage imageNamed:@"img_remind"];
            imageView.userInteractionEnabled = YES;
            [_firstOpenView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_firstOpenView);
                make.centerY.mas_equalTo(_firstOpenView).with.offset(-30);
                make.width.mas_equalTo(552 / 3.0);
                make.height.mas_equalTo(198 / 3.0);
            }];
            
            UILabel * msgLbl = [UILabel new];
            msgLbl.numberOfLines = 0;
            msgLbl.textColor = [UIColor whiteColor];
            [msgLbl setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            [msgLbl setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            msgLbl.textAlignment = NSTextAlignmentCenter;
            msgLbl.text = GetLocalResStr(@"airpurifier_dialog_show_slidingremind_text");
            [_firstOpenView addSubview:msgLbl];
            [msgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-15);
                make.top.mas_equalTo(imageView.mas_bottom).with.offset(20);
            }];
            
            UIButton *iKnowBtn = [UIButton new];
            [iKnowBtn addTarget:self action:@selector(firstOpenViewCloseButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [iKnowBtn setTitle:GetLocalResStr(@"airpurifier_public_ok") forState:UIControlStateNormal];
            RHBorderRadius(iKnowBtn, 12, 1, [UIColor whiteColor]);
            [iKnowBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:12] forState:UIControlStateNormal];
            [_firstOpenView addSubview:iKnowBtn];
            [iKnowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_firstOpenView);
                make.top.mas_equalTo(msgLbl.mas_bottom).with.offset(10);
                make.size.mas_equalTo(CGSizeMake(100, 30));
            }];
            NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:@"1" forKey:UD_FIRST_OPEN];
        }
        return _firstOpenView;
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

-  (UIViewController *)getCurrentVC {
    for (UIWindow *window in [UIApplication sharedApplication].windows.reverseObjectEnumerator) {
        
        UIView *tempView = window.subviews.lastObject;
        
        for (UIView *subview in window.subviews.reverseObjectEnumerator) {
            if ([subview isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
                tempView = subview;
                break;
            }
        }
        
        BOOL(^canNext)(UIResponder *) = ^(UIResponder *responder){
            if (![responder isKindOfClass:[UIViewController class]]) {
                return YES;
            } else if ([responder isKindOfClass:[UINavigationController class]]) {
                return YES;
            } else if ([responder isKindOfClass:[UITabBarController class]]) {
                return YES;
            } else if ([responder isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
                return YES;
            }
            return NO;
        };
        
        UIResponder *nextResponder = tempView.nextResponder;
        
        while (canNext(nextResponder)) {
            tempView = tempView.subviews.firstObject;
            if (!tempView) {
                return nil;
            }
            nextResponder = tempView.nextResponder;
        }
        
        UIViewController *currentVC = (UIViewController *)nextResponder;
        if (currentVC) {
            return currentVC;
        }
    }
    return nil;
}


@end
