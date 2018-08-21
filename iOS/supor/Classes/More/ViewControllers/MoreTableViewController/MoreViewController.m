//
//  MoreViewController.m
//  supor
//
//  Created by 刘杰 on 2018/5/3.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreHeaderView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#import "AppDelegate.h"
#import "MoreItem.h"
#import "RHAccountTool.h"
#import "Reachability.h"

#import "PersonalInfoViewController.h"
#import "AppointmentViewController.h"
#import "MyMessageListViewController.h"
#import "MyDeviceTableViewController.h"
#import "FilterStateViewController.h"
#import "ACUserInfoController.h"
#import "ACContactUsController.h"
#import "PreferenceDetailViewController.h"
#import "AfterSaleViewController.h"

@interface MoreViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *moreTableView;

@property (nonatomic, strong) MoreHeaderView *headerView;

@property (nonatomic, strong) NSArray *cellTitleArray;

@property (nonatomic, strong) NSMutableArray *deviceIDArray;

@property (nonatomic, strong) MoreItem *userMoreItem;

@property (nonatomic, strong) NSString *deviceNumber;

@end

static NSString * const cellIdentifier = @"normalCell";

@implementation MoreViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
    [self initData];
}

#pragma mark - Common Methods
- (void)configUI {
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)initViews {
    [self.view addSubview:self.moreTableView];
}

- (void)initData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configAccountAvatar) name:@"changeAvatarSuccess" object:nil];
    [self configAccountInfo];
    [self configAccountAvatar];
    [self requestMoreInfo];
}

#pragma mark - Private Methods
- (void)configAccountInfo {
    RHAccount *currentAccount = [RHAccountTool account];
    self.headerView.accountLabel.text = currentAccount.user_nickName.length == 0 ? currentAccount.user_nickName : currentAccount.user_phoneNumber;
    
    // query "my devices cell" detaiTextLabel text
    WEAKSELF(weakself);
    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus != 0) {
        [ACBindManager listDevicesWithCallback:^(NSArray<ACUserDevice *> *devices, NSError *error) {
            if (!error) {
                weakself.deviceNumber = [NSString stringWithFormat:@"%ld %@",(unsigned long)devices.count, GetLocalResStr(@"airpurifier_more_show_gongdevice_text")];
                if (devices.count > 1) {
                    weakself.deviceNumber = [NSString stringWithFormat:@"%@s", weakself.deviceNumber];
                }
                [AppDelegate sharedInstance].deviceList = devices;
                [weakself.moreTableView reloadData];
            }
        }];
    }
}

- (void)configAccountAvatar {
    // set account avatar
    WEAKSELF(weakself);
    RHAccount *account = [RHAccountTool account];
    if (account.userImageurl.length) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:account.userImageurl] options:(SDWebImageProgressiveDownload ) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (error) {
                [weakself.headerView.avatarButton setBackgroundImage:[UIImage imageNamed:@"img_big_avator"] forState:UIControlStateNormal];
            } else {
                [weakself.headerView.avatarButton setBackgroundImage:[image imageWithRoundedCornersSize:image.size cornerRadius:image.size.width * 0.5] forState:UIControlStateNormal];
            }
        }];
    } else {
        [ACAccountManager getUserProfile:^(ACObject *profile, NSError *error) {
            if (error) {
                [weakself.headerView.avatarButton setBackgroundImage:[UIImage imageNamed:@"img_big_avator"] forState:UIControlStateNormal];
                return;
            } else {
                NSDictionary *dataDic = [profile getObjectData];
                NSString *avatar = dataDic[@"_avatar"];
                RHAccount *account = [RHAccountTool account];
                account.userImageurl = avatar;
                [RHAccountTool saveAccount:account];
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:account.userImageurl]
                                                                options:(SDWebImageProgressiveDownload )
                                                               progress:nil
                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                                  if (error) {
                                                                      [weakself.headerView.avatarButton setBackgroundImage:[UIImage imageNamed:@"img_big_avator"] forState:UIControlStateNormal];
                                                                  } else {
                                                                      [weakself.headerView.avatarButton setBackgroundImage:[image imageWithRoundedCornersSize:image.size cornerRadius:image.size.width * 0.5] forState:UIControlStateNormal];
                                                                  }
                                                              }];
            }
        }];
    }
}

- (void)requestMoreInfo {
    WEAKSELF(weakself);
    [self.deviceIDArray removeAllObjects];
    [[AppDelegate sharedInstance].deviceList enumerateObjectsUsingBlock:^(ACUserDevice *device, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *tempDict = @{@"deviceId" : @(device.deviceId)};
        [self.deviceIDArray addObject:tempDict];
    }];
    // check scheduling and message number
    [http_ requestWithMessageName:@"queryMoreInfo"
                         callback:^(ACMsg *responseObject, NSError *error) {
                             if (!error) {
                                 ACObject * obj = [responseObject getACObject:@"actionData"];
                                 NSDictionary *dict = [obj getObjectData];
                                 MoreItem * item = [MoreItem initWithDict:dict];
                                 weakself.userMoreItem = item;
                                 if (item.sumAppointment>0) {
                                     weakself.headerView.schedulingButton.bageOn = YES;
                                 } else {
                                     weakself.headerView.schedulingButton.bageOn = NO;
                                 }
                                 if (item.readFlag0>0) {
                                     weakself.headerView.messageButton.bageOn = YES;
                                 } else {
                                     weakself.headerView.messageButton.bageOn = NO;
                                 }
                             }
                         } andKeyValues:@"deviceList", self.deviceIDArray, nil];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = LJHexColor(@"#36424a");
    cell.textLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
    cell.textLabel.text = self.cellTitleArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = self.deviceNumber;
        cell.detailTextLabel.textColor = LJHexColor(@"#848484");
        cell.detailTextLabel.font = [UIFont fontWithName:Regular size:16];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            if ([AppDelegate sharedInstance].deviceList.count == 0) {
                [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_public_nodata")];
            } else {
                MyDeviceTableViewController *myshebeiView = [[UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MyshebeiTableViewController"];
                [self.navigationController pushViewController:myshebeiView animated:YES];
            }
        }
            break;
        case 1: {
            if ([AppDelegate sharedInstance].deviceList.count > 0) {
                FilterStateViewController * filterVC = [[FilterStateViewController alloc] init];
                [self.navigationController pushViewController:filterVC animated:YES];
            } else {
                [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_nodevice_hint_ios")];
            }
        }
            break;
        case 2: {
            ACUserInfoController *userInfoController = [[ACUserInfoController alloc] init];
            [self.navigationController pushViewController:userInfoController animated:YES];
        }
            break;
        case 3: {
            ACContactUsController *contactUsController = [[ACContactUsController alloc] init];
            [self.navigationController pushViewController:contactUsController animated:YES];
        }
            break;
        case 4: {
            PreferenceDetailViewController * pvc = [sys loadFromStoryboard:@"LoginAndRegister" andId:@"PreferenceDetailViewController"];
            [self.navigationController  pushViewController:pvc animated:YES];
        }
            break;
        case 5: {
            AfterSaleViewController * afterSaleVC = [[AfterSaleViewController alloc]init];
            [self.navigationController pushViewController:afterSaleVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Target Action Methods
- (void)backButtonAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)avatarButtonAction {
    PersonalInfoViewController *personalInfoVC = [[PersonalInfoViewController alloc] init];
    [self.navigationController pushViewController:personalInfoVC animated:YES];
}

- (void)schedulingButtonAction {
    if ([AppDelegate sharedInstance].deviceList.count == 0 || ![AppDelegate sharedInstance].deviceList) {
        [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_nodevice_hint_ios")];
        return;
    }
    
    AppointmentViewController * appointVC = [[AppointmentViewController alloc] init];
    appointVC.lastControllerType = SchedulingFromMore;
    [self.navigationController pushViewController:appointVC animated:YES];
}

- (void)messageButtonAction {
    if (!self.userMoreItem || self.userMoreItem.sumMessage == 0) {
        [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_nomsg_hint_ios")];
    } else {
        MyMessageListViewController * myMessage = [sys loadFromStoryboard:@"LoginAndRegister" andId:@"MyMessageListViewController"];
        [self.navigationController pushViewController:myMessage animated:YES];
    }
}

#pragma mark - Lazyload Methods
- (UITableView *)moreTableView {
    if (!_moreTableView) {
        _moreTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _moreTableView.backgroundColor = LJHexColor(@"#EEEEEE");
        _moreTableView.delegate = self;
        _moreTableView.dataSource = self;
        _moreTableView.showsVerticalScrollIndicator = NO;
        _moreTableView.separatorColor = [UIColor classics_gray];
        _moreTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 15);
        _moreTableView.tableHeaderView = self.headerView;
        _moreTableView.tableFooterView = [UIView new];
        [_moreTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
        if (@available(iOS 11.0, *)) {
            _moreTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _moreTableView;
}

- (MoreHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MoreHeaderView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, (kMainScreenWidth / 2  + 47) * kRatio)];
        [_headerView.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.avatarButton addTarget:self action:@selector(avatarButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.schedulingButton addTarget:self action:@selector(schedulingButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.messageButton addTarget:self action:@selector(messageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (NSArray *)cellTitleArray {
    if (!_cellTitleArray) {
        _cellTitleArray = @[GetLocalResStr(@"airpurifier_moredevice_show_deviceList_title"),
                            GetLocalResStr(@"airpurifier_more_show_filtercondition_tex"),
                            GetLocalResStr(@"airpurifier_more_userinfomation"),
                            GetLocalResStr(@"airpurifier_more_contact_us"),
                            GetLocalResStr(@"airpurifier_more_show_preferences_text"),
                            GetLocalResStr(@"airpurifier_more_show_aftersalesservicenetwork_text")
                            ];
    }
    return _cellTitleArray;
}

- (NSMutableArray *)deviceIDArray {
    if (!_deviceIDArray) {
        _deviceIDArray = @[].mutableCopy;
    }
    return _deviceIDArray;
}

#pragma mark - System Method
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.moreTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
