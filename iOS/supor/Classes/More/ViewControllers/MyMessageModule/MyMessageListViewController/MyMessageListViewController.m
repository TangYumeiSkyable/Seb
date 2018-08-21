//
//  MyMessageListViewController.m
//  supor
//
//  Created by 白云杰 on 2017/5/11.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "MyMessageListViewController.h"
#import "AppDelegate.h"
#import "RHAccountTool.h"
#import "MessageTableViewCell.h"
#import "PMViewController.h"
#import "LvWangViewController.h"
#import "NSString+LKExtension.h"
#import "UIBarButtonItem+Extension.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

static NSString *CellIdentifier = @"MessageTableViewCell";
static NSString * const updateFlagURL = @"updateMessageInfo";

@interface MyMessageListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * datas;

@end

@implementation MyMessageListViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
    [self requestMyNews];
}

- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_mynews_text");
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.fd_prefersNavigationBarHidden = NO;
}

- (void)initViews {
    self.tableView.backgroundColor = LJHexColor(@"#f2f2f2");
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 20:10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        }
    NSDictionary *dic = _datas[indexPath.section];
    
    if ([dic[@"readFlag"] integerValue] == 0) {
        cell.labelState.backgroundColor = LJHexColor(@"#ff3300");
    } else {
        cell.labelState.backgroundColor = LJHexColor(@"#c8c8c8");
    }
    
    cell.lableTime.text = [self calculateDateWithTimeStamp:[[dic[@"createTime"] substringToIndex:10] doubleValue]];
    
    if ([dic[@"msgType"] integerValue] != 2) {
        
        NSArray *arr = [dic[@"text"] componentsSeparatedByString:@","];
        
        cell.labelTitle.text = GetLocalResStr(@"airpurifier_more_show_replacementremind_text");
        
        NSString *lvName = @"";
        NSString *hours = @"";
        
        
        for (NSString *str in arr) {
            RHLog(@"%@", str);
            
            if ([str isEqualToString:@"Pre-filter"]) {
                
                if ([dic[@"initial_filter"] integerValue] <= 0) { // 1
                    
                    lvName = GetLocalResStr(@"airpurifier_more_show_prefilter_tex");
                    hours = dic[@"initial_filter"];
                    break;
                    
                }
                
            } else if ([str isEqualToString:@"Active carbon filter"]) {
                
                if ([dic[@"act_filter"] integerValue] < 200) { // 2
                    
                    lvName = GetLocalResStr(@"airpurifier_more_show_activefilter_tex");
                    hours = dic[@"act_filter"];
                    break;
                    
                }
                
            } else if ([str isEqualToString:@"HEPA filter"]) {
                
                if ([dic[@"HEPA_filter"] integerValue] < 200) { // 3
                    
                    lvName = GetLocalResStr(@"airpurifier_more_show_hepafilter_tex");
                    hours = dic[@"HEPA_filter"];
                    break;
                }
                
            } else if ([str isEqualToString:@"Nano capture filter"]) {
                
                if ([dic[@"nano_filter"] integerValue] < 200) { // 4
                    
                    lvName = GetLocalResStr(@"airpurifier_more_show_nanofilter_tex");
                    hours = dic[@"nano_filter"];
                    break;
                }
            }
        }
        
        
        NSString *str = [NSString stringWithFormat:@"%.0f%%", ((1000 - [hours integerValue]) / 1000.0) * 100];
        
        cell.labelContent.text = [NSString stringWithFormat:GetLocalResStr(@"airpurifier_more_show_lv_content_ios"), lvName, dic[@"deviceName"], hours, str];
        
        [self messageAction:cell.labelContent changeString:dic[@"deviceName"] andAllColor:[UIColor colorFromHexCode:@"#848484"] andMarkColor:[UIColor colorFromHexCode:@"#36424a"]];
        
    } else {
        cell.labelTitle.text = GetLocalResStr(@"airpurifier_more_show_openairpurifier_text");
        cell.labelContent.text = [NSString stringWithFormat:GetLocalResStr(@"airpurifier_more_show_pmitem_text_ios"), dic[@"deviceName"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.datas[indexPath.section];
    [self updateReadFlagWithIndex:indexPath.section];
    
    if ([dic[@"msgType"] integerValue] != 2) {
        LvWangViewController *lvVc = [[LvWangViewController alloc] init];
        lvVc.dic = dic;
        [self.navigationController pushViewController:lvVc animated:YES];
        
    } else {
        
        PMViewController *pmVC = [[PMViewController alloc] init];
        pmVC.dic = dic;
        [self.navigationController pushViewController:pmVC animated:YES];
    }
}

#pragma mark - Private Methods
- (void)requestMyNews {
    WEAKSELF(ws);
    [http_ requestWithMessageName:@"queryMessageInfoList" callback:^(ACMsg *responseObject, NSError *error) {
        NSDictionary *data = [responseObject getObjectData];
        NSArray *array = data[@"actionData"];
        NSArray *deviceList = [AppDelegate sharedInstance].deviceList;
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            [mDict addEntriesFromDictionary:dict];
            
            for (ACUserDevice *device in deviceList) {
                
                if (device.deviceId == [dict[@"deviceId"] longLongValue]) {
                    
                    [arrayM addObject:mDict];
                    NSDictionary * dic = @{@"deviceName" : device.deviceName};
                    [mDict addEntriesFromDictionary:dic];
                }
            }
        }
        
        [ws.datas removeAllObjects];
        [ws.datas addObjectsFromArray:arrayM];
        [self.tableView reloadData];
        
    } andKeyValues:nil];
}

- (void)updateReadFlagWithIndex:(NSInteger)index {
    NSMutableDictionary *messageDic = self.datas[index];
    NSString *messageID = messageDic[@"messageId"];
    
    if ([messageDic[@"readFlag"] integerValue] == 1) {
        return;
    }
    
    [http_ requestWithMessageName:updateFlagURL callback:^(ACMsg *responseObject, NSError *error) {
        if (error) {
            for (NSMutableDictionary *messageDictionary in self.datas) {
                
                long long time1 = [messageDictionary[@"messageId"] longLongValue];
                long long time2 = [messageID longLongValue];
                if (time1 == time2) {
                    [messageDictionary setObject:@0 forKey:@"readFlag"];
                }
            }
        } else {
            [messageDic setObject:@1 forKey:@"readFlag"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } andKeyValues:@"messageId",@([messageID longLongValue]), nil];
}

- (void)messageAction:(UILabel *)theLab changeString:(NSString *)change andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor {
    NSString *tempStr = theLab.text;
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    [strAtt addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(0, [strAtt length])];
    NSRange markRange = [tempStr rangeOfString:change];
    [strAtt addAttribute:NSForegroundColorAttributeName value:markColor range:markRange];
    theLab.attributedText = strAtt;
}

- (NSString *)calculateDateWithTimeStamp:(double)timeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM"];
    return [dateFormatter stringFromDate:date];
}

#pragma mark - Lazyload Methods
- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

@end
