//
//  PersonalInfoViewController.m
//  supor
//
//  Created by 刘杰 on 2018/4/25.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "RenameViewController.h"
#import "ChangePWDViewController.h"
#import "UAlertView.h"
#import "AvatarTableViewCell.h"
#import "UIImage+FlatUI.h"
#import "RHAccountTool.h"
#import "AppDelegate.h"
#import "SelectPicturePopView.h"
#import "LoginViewController.h"
#import "RHBaseNavgationController.h"

static NSString * const cellIdentifier = @"allCell";
@interface PersonalInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *personalInfoTableView;

@property (nonatomic, strong) SelectPicturePopView *chooseAvatarPopView;

@property (nonatomic, strong) UIButton *logoutButton;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation PersonalInfoViewController

#pragma mark - View LifeCycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
    [self queryAvatarInfo];
}

#pragma mark - Common Methods
- (void)configUI {
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_personaltitle_text");
    self.navigationController.navigationBar.translucent = NO;
}

- (void)initViews {
    [self.view addSubview:self.personalInfoTableView];
    [self.view addSubview:self.logoutButton];
}

- (void)queryAvatarInfo {
    WEAKSELF(weakself);
    RHAccount *account = [RHAccountTool account];
    if (!account.userImageurl.length) {
        [ACAccountManager getUserProfile:^(ACObject *profile, NSError *error) {
            if (!error) {
                NSDictionary *dataDic = [profile getObjectData];
                NSString *avatarLink = dataDic[@"_avatar"];
                account.userImageurl = avatarLink;
                [RHAccountTool saveAccount:account];
                [weakself.personalInfoTableView reloadData];
            }
        }];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 66 * kRatio;
    }
    return 43 * kRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 20)];
    headerView.backgroundColor = LJHexColor(@"#EEEEEE");
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.avatarImageView.hidden = YES;
    cell.textLabel.text = self.titleArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.avatarImageView.hidden = NO;
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[RHAccountTool account].userImageurl]
                                                        options:SDWebImageProgressiveDownload
                                                       progress:nil
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                cell.avatarImageView.image = [image imageWithRoundedCornersSize:image.size cornerRadius:image.size.width * 0.5];
            } else {
                cell.avatarImageView.image = [UIImage imageNamed:@"img_big_avator"];
            }
        }];
    }
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = [RHAccountTool account].user_nickName.length == 0 ? [RHAccountTool account].user_phoneNumber : [RHAccountTool account].user_nickName;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.chooseAvatarPopView showPopView];
    } else if (indexPath.row == 1) {
        RenameViewController *renameVC = [[RenameViewController alloc] init];
        renameVC.renameType = RenameNicknameType;
        renameVC.renameBlock = ^(NSString *newNickname) {
            AvatarTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = newNickname;
        };
        [self.navigationController pushViewController:renameVC animated:YES];
    } else {
        ChangePWDViewController *changePWDVC = [[ChangePWDViewController alloc] init];
        [self.navigationController pushViewController:changePWDVC animated:YES];
    }
}

#pragma mark - UAlertViewDelegate
- (void)alertView:(UAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self userLogout];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *resultImage = [(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage] imageWithSize:CGSizeMake(150, 150)];
    WEAKSELF(weakself);
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakself uploadAvatarWithImage:resultImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Target Methods
- (void)confirmLogoutAction {
    UAlertView *logoutAlertView = [[UAlertView alloc] initWithTitle:GetLocalResStr(@"airpurifier_more_show_areyousureexit_text")
                                                                msg:nil
                                                        cancelTitle:GetLocalResStr(@"airpurifier_public_cancel")
                                                            okTitle:GetLocalResStr(@"airpurifier_public_ok")];
    logoutAlertView.delegate = self;
    [logoutAlertView show];
}

#pragma mark - Private Methods
- (void)userLogout {
    // remove notification alias and clean local account info
    RHAccount *currentAccount = [RHAccountTool account];
    [[AppDelegate sharedInstance] removeAlias:[NSString stringWithFormat:@"%@", @(currentAccount.user_ID)]];
//    [RHAccountTool cleanAccount];
    [ACAccountManager logout];
    // remove userDefaults object
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_FIRST_OPEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_FIRST_SHOW_NOTIFI_ALERT];
    // make loginVC as rootViewController
    RHBaseNavgationController *loginNC = [[RHBaseNavgationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    [AppDelegate sharedInstance].window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [AppDelegate sharedInstance].window.rootViewController = loginNC;
    [[AppDelegate sharedInstance].window makeKeyAndVisible];
}

- (void)uploadAvatarWithImage:(UIImage *)avatarImage {
    WEAKSELF(weakself);
    NSData *data = UIImageJPEGRepresentation(avatarImage, 0.3);
    avatarImage = [UIImage imageWithData:data];
    RHAccount *account = [RHAccountTool account];
    
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setForegroundColor:LJHexColor(@"#009dc2")];
    [SVProgressHUD showImage:[UIImage imageNamed:@"ico_wait.png"] status:GetLocalResStr(@"airpurifier_personal_loading")];
    
    [ACAccountManager setAvatar:avatarImage callback:^(NSString *avatarUrl, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [ZSVProgressHUD showErrorWithStatus:GetLocalResStr(@"airpurifier_upload_the_avatars") duration:0.5];
        } else {
            account.userImageurl = avatarUrl;
            [RHAccountTool saveAccount:account];
            // upload avatar succeed and refresh UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAvatarSuccess" object:nil];
                AvatarTableViewCell *avatarCell = [weakself.personalInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                avatarCell.avatarImageView.image = [avatarImage imageWithRoundedCornersSize:avatarImage.size cornerRadius:avatarImage.size.width * 0.5];
            });
        }
    }];
}

- (void)initImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *pickController = [[UIImagePickerController alloc] init];
    pickController.delegate = self;
    pickController.sourceType = type;
    pickController.navigationBar.tintColor = [UIColor whiteColor];
    [self presentViewController:pickController animated:YES completion:nil];
}

#pragma mark - Lazyload Methods
- (UITableView *)personalInfoTableView {
    if (!_personalInfoTableView) {
        _personalInfoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _personalInfoTableView.backgroundColor = LJHexColor(@"#EEEEEE");
        _personalInfoTableView.delegate = self;
        _personalInfoTableView.dataSource = self;
        _personalInfoTableView.showsVerticalScrollIndicator = NO;
        _personalInfoTableView.tableFooterView = [UIView new];
        [_personalInfoTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        [_personalInfoTableView registerClass:[AvatarTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return _personalInfoTableView;
}

- (UIButton *)logoutButton {
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutButton setTitle:GetLocalResStr(@"airpurifier_more_show_exitcurrentaccount_text") forState:UIControlStateNormal];
        [_logoutButton setTitleColor:LJHexColor(@"#f2f2f2") forState:UIControlStateNormal];
        _logoutButton.titleLabel.font = [UIFont fontWithName:Regular size:standardFontSize];
        [_logoutButton addTarget:self action:@selector(confirmLogoutAction) forControlEvents:UIControlEventTouchUpInside];
        [_logoutButton setBackgroundImage:[UIImage imageWithColor:[UIColor classics_blue] cornerRadius:30] forState:UIControlStateNormal];
    }
    return _logoutButton;
}

- (SelectPicturePopView *)chooseAvatarPopView {
    if (!_chooseAvatarPopView) {
        WEAKSELF(weakself);
        _chooseAvatarPopView = [[SelectPicturePopView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _chooseAvatarPopView.completion = ^(PopViewSelectType selectType) {
            switch (selectType) {
                case PopViewSelectCamera: {
                    [weakself initImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                }
                    break;
                case PopViewSelectAlbum: {
                    [weakself initImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                }
                    break;
                default:
                    break;
            }
            _chooseAvatarPopView = nil;
        };
    }
    return _chooseAvatarPopView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[GetLocalResStr(@"airpurifier_more_show_head_text"),
                        GetLocalResStr(@"airpurifier_more_show_nickname_text"),
                        GetLocalResStr(@"airpurifier_more_show_change_password_text")];
    }
    return _titleArray;
}

#pragma mark - System Methods
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.personalInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RATIO(90));
        make.right.mas_equalTo(RATIO(-90));
        make.height.mas_equalTo(RATIO(156));
        make.bottom.mas_equalTo(-DeviceUtils.bottomSafeHeight - 20);
    }];
}

@end
