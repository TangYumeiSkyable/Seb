//
//  PreferenceDetailViewController.m
//  supor
//
//  Created by 赵冰冰 on 2017/4/28.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "PreferenceDetailViewController.h"
#import "LicenseViewController.h"
#import "ShezhiTableViewController.h"
#import "PersonalDataViewController.h"

#import "UINavigationBar+FlatUI.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface PreferenceDetailViewController ()

@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation PreferenceDetailViewController


#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self initViews];
    
}

#pragma mark - Common Methods
- (void)configUI {
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor classics_blue]];
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_preferences_text");
    self.fd_prefersNavigationBarHidden = NO;
}

- (void)initViews {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = RGB(242, 242, 242);
    self.tableView.contentInset = UIEdgeInsetsMake(RATIO(60), 0, 0, 0);
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RATIO(156);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.textColor = LJHexColor(@"#848484");
    cell.textLabel.font = [UIFont fontWithName:Regular size:18];
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        case 1:
        case 3: {
            PersonalDataViewController *personalVC = [[PersonalDataViewController alloc] init];
            personalVC.requestType = indexPath.row;
            [self.navigationController pushViewController:personalVC animated:YES];
        }
            break;
        case 2: {
            LicenseViewController * lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"LicenseViewController"];
            lvc.number = 1;
            [self.navigationController pushViewController:lvc animated:YES];
        }
            break;
            
        case 4: {
            ShezhiTableViewController *shezhiView = [sys loadFromStoryboard:@"LoginAndRegister" andId:@"ShezhiTableViewController"];
            [self.navigationController pushViewController:shezhiView animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Lazyload Methods
- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects: GetLocalResStr(@"airpurifier_more_show_personaldata_text"), GetLocalResStr(@"airpurifier_more_show_legalnotice_text"), GetLocalResStr(@"airpurifier_more_show_cookies_text"), GetLocalResStr(@"airpurifier_more_show_termsofuse_text"), GetLocalResStr(@"airpurifier_more_show_notifications_text"), nil];
    }
    return _titleArray;
}

@end
