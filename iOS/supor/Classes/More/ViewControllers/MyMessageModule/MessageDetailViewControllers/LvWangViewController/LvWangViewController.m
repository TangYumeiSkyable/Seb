//
//  LvWangViewController.m
//  supor
//
//  Created by 白云杰 on 2017/5/19.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "LvWangViewController.h"
#import "LvWangTableViewCell.h"

@interface LvWangViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation LvWangViewController


#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self initViews];
    [self initData];
    
}

#pragma mark - Common Methods
- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_replacementremind_text");
}

- (void)initViews {
    [self.view addSubview:self.tableView];
}

- (void)initData {
    
    NSArray *arr = [_dic[@"text"] componentsSeparatedByString:@","];
    
    for (NSString *str in arr) {
        
        if ([str isEqualToString:@"Pre-filter"]) {
            
            if ([_dic[@"initial_filter"] integerValue] <= 0) {
                
                NSDictionary *dic = @{@"name":GetLocalResStr(@"airpurifier_more_show_prefilter_tex"),  @"bedroom":_dic[@"deviceName"], @"hours":_dic[@"initial_filter"]};
                [self.dataArray addObject:dic];
            }
            
        } else if ([str isEqualToString:@"Active carbon filter"]) {
            
            if ([_dic[@"act_filter"] integerValue] < 200) {
                
                NSDictionary *dic = @{@"name":GetLocalResStr(@"airpurifier_more_show_activefilter_tex"),  @"bedroom":_dic[@"deviceName"], @"hours":_dic[@"act_filter"]};
                [self.dataArray addObject:dic];
            }
            
        } else if ([str isEqualToString:@"HEPA filter"]) {
            
            if ([_dic[@"HEPA_filter"] integerValue] < 200) {
                
                NSDictionary *dic = @{@"name":GetLocalResStr(@"airpurifier_more_show_hepafilter_tex"),  @"bedroom":_dic[@"deviceName"], @"hours":_dic[@"HEPA_filter"]};
                [self.dataArray addObject:dic];
                
            }
        } else if ([str isEqualToString:@"Nano capture filter"]) {
            
            if ([_dic[@"nano_filter"] integerValue] < 200) {
                
                NSDictionary *dic = @{@"name":GetLocalResStr(@"airpurifier_more_show_nanofilter_tex"),  @"bedroom":_dic[@"deviceName"], @"hours":_dic[@"nano_filter"]};
                [self.dataArray addObject:dic];
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 15)];
    view.backgroundColor = LJHexColor(@"#EEEEEE");
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return RATIO(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LvWangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LvWangTableViewCell"];
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%.0f%%", ((1000 - [dic[@"hours"] integerValue]) / 1000.0) * 100];
    cell.label.text = [NSString stringWithFormat:GetLocalResStr(@"airpurifier_more_show_lv_content_ios"), dic[@"name"], dic[@"bedroom"], dic[@"hours"], str];
    [self messageAction:cell.label changeString:dic[@"bedroom"] allColor:LJHexColor(@"#848484") markColor:LJHexColor(@"#36424a")];
    return cell;
}

#pragma mark - Lazyload Methods
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = LJHexColor(@"#EEEEEE");
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"LvWangTableViewCell" bundle:nil] forCellReuseIdentifier:@"LvWangTableViewCell"];
    }
    return _tableView;
}

#pragma mark - System Methods
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

- (void)messageAction:(UILabel *)theLab changeString:(NSString *)change allColor:(UIColor *)allColor markColor:(UIColor *)markColor {
    NSString *tempStr = theLab.text;
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    [strAtt addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(0, [strAtt length])];
    NSRange markRange = [tempStr rangeOfString:change];
    [strAtt addAttribute:NSForegroundColorAttributeName value:markColor range:markRange];
    theLab.attributedText = strAtt;
}

@end
