//
//  DeviceManageViewController.m
//  supor
//
//  Created by 刘杰 on 2018/4/19.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "DeviceManageViewController.h"
#import "ACAddDeviceController.h"
#import "RenameViewController.h"
#import "ShareDeviceViewController.h"
#import "DeviceHeaderView.h"
#import "ACUserDevice.h"
#import "ACBindUser.h"
#import "ACFileInfo.h"
#import "ACFileManager.h"
#import "RHAccount.h"
#import "RHAccountTool.h"
#import "UAlertView.h"
#import "ACDeviceManager.h"
#import "ACDevice.h"
#import "UIBarButtonItem+Extension.h"

#import "DeviceNameTableViewCell.h"
#import "ShareDeviceTableViewCell.h"
#import "DeviceMemberTableViewCell.h"

static NSInteger firstSectionHeight = 35;
static NSInteger secondSectionHeight = 110;
static NSString * const deviceNameCellIdentifier = @"deviceCell";
static NSString * const shareCellIdentifier = @"shareCell";
static NSString * const memberCellIdentifier = @"userCell";

@interface DeviceManageViewController ()<UITableViewDelegate, UITableViewDataSource, UAlertViewDelegate>

@property (nonatomic, strong) UITableView *deviceTableView;

@property (nonatomic, strong) UIView *firstHeaderView;

@property (nonatomic, strong) DeviceHeaderView *secondHeaderView;

@property (nonatomic, strong) UIButton *unbindButton;

@property (nonatomic, strong) NSMutableArray *memberArray;

@property (nonatomic, assign) BOOL isAdministrator;

@property (nonatomic, strong) ACDevice *currentDevice;

@property (nonatomic, assign) NSInteger deleteMemberIndex;


@end

@implementation DeviceManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAdministrator = self.device.ownerId == [RHAccountTool account].user_ID ? YES : NO;
    [self configUI];
    [self initViews];
    [self initData];
}

#pragma mark - Common Methods
- (void)configUI {
    self.view.backgroundColor = LJHexColor(@"#EEEEEE");
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title =GetLocalResStr(@"airpurifier_moredevice_show_mydevice_title");
    UIBarButtonItem *rightItem = [UIBarButtonItem createRightItemWithFrame:CGRectMake(0, 0, 11*59/33, 11*59/33)
                                                                     title:nil
                                                                     image:[UIImage imageNamed:@"add_white"]
                                                            highLightImage:nil target:self selector:@selector(addDeviceAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)initViews {
    [self.view addSubview:self.deviceTableView];
    [self.view addSubview:self.unbindButton];
}

- (void)initData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDeviceMemeber) name:@"shareDeviceByEmailSuccess" object:nil];
    [self requestDevicefirmware];
    [self requestDeviceMemeber];
}

#pragma mark - UAlertViewDelegate
- (void)alertView:(UAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            [self confirmDeleteShareUser];
        }
    } else {
        if (buttonIndex == 1) {
            [self confirmCancelDeviceBindingRelationship];
        }
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return firstSectionHeight;
    }
    return secondSectionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = nil;
    if (section == 0) {
        headerView = self.firstHeaderView;
    } else {
        headerView = self.secondHeaderView;
        [self configSecondSectionHeaderData];
    }
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return self.memberArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            DeviceNameTableViewCell *deviceNameCell = [tableView dequeueReusableCellWithIdentifier:deviceNameCellIdentifier forIndexPath:indexPath];
            deviceNameCell.detailTextLabel.text = self.device.deviceName;
            return deviceNameCell;
        } else if (indexPath.row == 1){
            ShareDeviceTableViewCell *shareDeviceCell = [tableView dequeueReusableCellWithIdentifier:shareCellIdentifier forIndexPath:indexPath];
            return shareDeviceCell;
        }
    }
    DeviceMemberTableViewCell *memberCell = [tableView dequeueReusableCellWithIdentifier:memberCellIdentifier forIndexPath:indexPath];
    ACBindUser *user = self.memberArray[indexPath.row];
    memberCell.accountLabel.text = user.nickName;
    memberCell.unbindButton.tag = indexPath.row;
    if (self.isAdministrator == YES) {
        [memberCell.unbindButton setHidden:NO];
        [memberCell.unbindButton addTarget:self action:@selector(deleteShareUserAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [memberCell.unbindButton setHidden:YES];
    }
    
    NSString *imageName = [NSString stringWithFormat:@"header_%ld.jpg",(long)user.userId];
    ACFileInfo *fileInfo = [[ACFileInfo alloc] initWithName:imageName bucket:[NSString stringWithFormat:@"suporAirClear_img"] Checksum:0];
    ACFileManager *fileManager = [[ACFileManager alloc] init];
    
    [fileManager getDownloadUrlWithfile:fileInfo
                             ExpireTime:0
                        payloadCallback:^(NSString *urlString, NSError *error) {
        if (error) {
            NSLog(@"🍍%@",error);
        } else {
            [fileManager downFileWithsession:urlString
                                    checkSum:0
                                    callBack:^(float progress, NSError *error) {
                NSLog(@"🍊1%@",error);
            } CompleteCallback:^(NSString *filePath) {
                NSLog(@"🌲%@",filePath);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //Update UI in UI thread here
                    memberCell.avatorImageView.image = [[UIImage imageWithContentsOfFile:filePath] imageWithSize:CGSizeMake(44, 44)];
                });
                NSLog(@"🐌");
                //  [self.tableView reloadData];
            }];
        }
    }];
    return memberCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isAdministrator == NO) {
        [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_moredevice_show_permissions_hint_ios")];
        return;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            WEAKSELF(weakself);
            RenameViewController *renameVC = [[RenameViewController alloc] init];
            renameVC.renameType= RenameDeviceNameType;
            renameVC.device = self.device;
            renameVC.renameBlock = ^(NSString *renameString) {
                weakself.device.deviceName = renameString;
                [weakself.deviceTableView reloadData];
            };
            [self.navigationController pushViewController:renameVC animated:YES];
        } else {
            ShareDeviceViewController *shareDeviceVC = [[ShareDeviceViewController alloc] init];
            shareDeviceVC.device = self.device;
            shareDeviceVC.deviceInfoDic = self.deviceDic;
            [self.navigationController pushViewController:shareDeviceVC animated:YES];
            return;
        }
    }
}

#pragma mark - Target Action
- (void)deleteShareUserAction:(UIButton *)button {
    if (!self.isAdministrator) {
        return;
    }
    self.deleteMemberIndex = button.tag;
    ACBindUser *user = self.memberArray[self.deleteMemberIndex];
    
    NSString * msg = [NSString stringWithFormat:GetLocalResStr(@"airpurifier_moredevice_show_delete_user_ios"), user.nickName ? user.nickName : @""];
    UAlertView * alert = [[UAlertView alloc] initWithTitle:@""
                                                       msg:msg
                                               cancelTitle:GetLocalResStr(@"airpurifier_public_cancel")
                                                   okTitle:GetLocalResStr(@"airpurifier_public_ok")];
    alert.tag = 101;
    alert.delegate = self;
    [alert show];
}

- (void)confirmDeleteShareUser {
    ACBindUser *user = self.memberArray[self.deleteMemberIndex];
    WEAKSELF(ws);
    [ACBindManager unbindDeviceWithUserSubDomain:self.device.subDomain
                                          userId:user.userId
                                        deviceId:self.device.deviceId
                                        callback:^(NSError *error) {
        
        ACObject *userId = [[ACObject alloc] init];
        [userId putLong:@"userId" value:user.userId];
        NSArray *arr = [NSArray arrayWithObjects:userId, nil];
        
        if (error) {
            NSLog(@"%@",error);
        } else {
            
            [http_ requestWithMessageName:@"deleteMessageForUnbind"
                                 callback:^(ACMsg *responseObject, NSError *error) {
                if (error) {
                    RHLog(@"UDS unbindDevice ShareUser Error:%@", error);
                }
            } andKeyValues:@"deviceId", @(self.device.deviceId), @"userIdList", arr, nil];
            
            [ws.memberArray removeObjectAtIndex:ws.deleteMemberIndex];
            [ws.deviceTableView reloadData];
        }
    }];
}

- (void)cancelDeviceBindingRelationship {
    UAlertView *alert = [[UAlertView alloc] initWithTitle:GetLocalResStr(@"airpurifier_more_show_warning_text")
                                                      msg:[NSString stringWithFormat:GetLocalResStr(@"airpurifier_moredevice_show_delete_device_ios"),self.device.deviceName]
                                              cancelTitle:GetLocalResStr(@"airpurifier_public_refuse")
                                                  okTitle:GetLocalResStr(@"airpurifier_public_confirm")];
    alert.delegate = self;
    [alert show];
}

- (void)confirmCancelDeviceBindingRelationship {
    
    [ACBindManager unbindDeviceWithSubDomain:self.device.subDomain
                                    deviceId:self.device.deviceId
                                    callback:^(NSError *error) {
        
        if (error) {
            NSLog(@"unbindDeviceError:%@",error);
        } else {
            NSMutableArray *arr = [NSMutableArray array];
            RHAccount *account = [RHAccountTool account];
            if (self.isAdministrator) {
                [self.memberArray enumerateObjectsUsingBlock:^(ACBindUser *user, NSUInteger idx, BOOL * _Nonnull stop) {
                    ACObject *tempObject = [[ACObject alloc] init];
                    [tempObject putLong:@"userId" value:user.userId];
                    [arr addObject:tempObject];
                }];
            }
            
            ACObject *obj = [[ACObject alloc] init] ;
            [obj putLong:@"userId" value:account.user_ID];
            [arr addObject:obj];
            
            [http_ requestWithMessageName:@"deleteMessageForUnbind" callback:^(ACMsg *responseObject, NSError *error) {
                if (error) {
                    RHLog(@"UDS unbindDeviceError:%@", error);
                }
            } andKeyValues:@"deviceId", @(self.device.deviceId), @"userIdList", arr, nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addDeviceAction {
    ACAddDeviceController *addDeviceController = [[ACAddDeviceController alloc] init];
    [self.navigationController pushViewController:addDeviceController animated:YES];
}

#pragma mark - Private Methods
- (void)requestDevicefirmware {
    WEAKSELF(ws);
    [ACDeviceManager getDeviceInfoWithSubDomain:self.device.subDomain
                               physicalDeviceId:self.device.physicalDeviceId
                                       Callback:^(ACDevice *device, NSError *error) {
        if (error) {
            return;
        }
        self.currentDevice = device;
        [ws.deviceTableView reloadData];
    }];
}

- (void)requestDeviceMemeber {
    RHAccount *account = [RHAccountTool account];
    WEAKSELF(ws);
    [ACBindManager listUsersWithSubDomain:self.device.subDomain
                                 deviceId:self.device.deviceId
                                calllback:^(NSArray *users, NSError *error) {
        
        if (error) {
            RHLog(@"requestDeviceMemberError:%@",error);
        } else {
            [ws.memberArray removeAllObjects];
            for (ACBindUser *user in users) {
                if (user.userId != account.user_ID) {
                    [ws.memberArray addObject:user];
                }
            }
            [ws.deviceTableView reloadData];
        }
    }];
}

- (void)configSecondSectionHeaderData {
    NSString *str = [NSString stringWithFormat:@"%@", self.device.physicalDeviceId];
    NSInteger strLength = str.length % 2 == 0 ? str.length / 2 : str.length / 2 + 1;
    NSMutableString *tempString = [[NSMutableString alloc] initWithString:str];
    for (int i = 1; i < strLength; i++) {
        [tempString insertString:@":" atIndex:i * 2 + (i - 1)];
    }
    self.secondHeaderView.macTextLabel.text = tempString;
    self.secondHeaderView.versionTextLabel.text = self.currentDevice.moduleVersion;
    if (self.memberArray.count <= 0) {
        self.secondHeaderView.sectionTitleLabel.hidden = YES;
    } else {
        self.secondHeaderView.sectionTitleLabel.hidden = NO;
    }
}

#pragma mark - Lazyload Methods
- (UITableView *)deviceTableView {
    if (!_deviceTableView) {
        _deviceTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _deviceTableView.backgroundColor = LJHexColor(@"#EEEEEE");
        _deviceTableView.showsVerticalScrollIndicator = NO;
        _deviceTableView.delegate = self;
        _deviceTableView.dataSource = self;
        [_deviceTableView registerClass:[DeviceNameTableViewCell class] forCellReuseIdentifier:deviceNameCellIdentifier];
        [_deviceTableView registerClass:[ShareDeviceTableViewCell class] forCellReuseIdentifier:shareCellIdentifier];
        [_deviceTableView registerClass:[DeviceMemberTableViewCell class] forCellReuseIdentifier:memberCellIdentifier];
        _deviceTableView.tableFooterView = [UIView new];
    }
    return _deviceTableView;
}

- (UIView *)firstHeaderView {
    if (!_firstHeaderView) {
        _firstHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, firstSectionHeight)];
        _firstHeaderView.backgroundColor = LJHexColor(@"#EEEEEE");
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kMainScreenWidth - 20, firstSectionHeight - 10)];
        titleLabel.text = GetLocalResStr(@"airpurifier_moredevice_show_deviceinfo_text");
        titleLabel.textColor = LJHexColor(@"#c8c8c8");
        titleLabel.font = [UIFont fontWithName:Regular size:14];
        [_firstHeaderView addSubview:titleLabel];
    }
    return _firstHeaderView;
}

- (DeviceHeaderView *)secondHeaderView {
    if (!_secondHeaderView) {
        _secondHeaderView = [[DeviceHeaderView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, secondSectionHeight)];
    }
    return _secondHeaderView;
}

- (UIButton *)unbindButton {
    if (!_unbindButton) {
        _unbindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * image = [UIImage imageWithColor:[UIColor classics_blue] cornerRadius:18];
        [_unbindButton setBackgroundImage:image forState:UIControlStateNormal];
        [_unbindButton setTitle:GetLocalResStr(@"airpurifier_more_show_sureremovebinddevice_text") forState:UIControlStateNormal];
        [_unbindButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_unbindButton addTarget:self action:@selector(cancelDeviceBindingRelationship) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unbindButton;
}

- (NSMutableArray *)memberArray {
    if (!_memberArray) {
        _memberArray = [NSMutableArray array];
    }
    return _memberArray;
}

#pragma mark - System Methods
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.deviceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.unbindButton.mas_top).offset(-10);
    }];
    
    [self.unbindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(-(DeviceUtils.bottomSafeHeight + 20));
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
