//
//  SelectCityViewController.m
//  supor
//
//  Created by 白云杰 on 2017/5/31.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "SelectCityViewController.h"

@interface SelectCityViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation SelectCityViewController

#pragma mark - View Lifecycle Method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
    [self httpRequest];
}

#pragma mark - Common Methods
- (void)configUI {
    self.view.backgroundColor = RGB(242, 242, 242);
    self.navigationItem.title = GetLocalResStr(@"airpurifier_adjust_show_modifycity_text");
    self.navigationController.navigationBar.translucent = NO;
}

- (void)initViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = LJHexColor(@"#EEEEEE");
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:_tableView];
    
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return RATIO(60);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, RATIO(60))];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RATIO(156);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return FLT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = LJHexColor(@"#36424a");
    cell.textLabel.font = [UIFont fontWithName:Regular size:18];
    
    
    NSDictionary *selectedCityDic = [[NSUserDefaults standardUserDefaults] objectForKey:CityInfo];
    NSDictionary *currentCityDic = self.dataArr[indexPath.row];
    cell.textLabel.text = currentCityDic[@"name"];
    
    if ([selectedCityDic isEqualToDictionary:currentCityDic]) {
        UIImageView *selectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_right_sel"]];
        cell.accessoryView = selectImageView;
    } else {
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *currentCityDic = self.dataArr[indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:currentCityDic forKey:CityInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cityChange" object:nil userInfo:currentCityDic];
    
    switch (self.popStyle) {
        case SelectCityVCPopToLast:
            [self.navigationController popToViewController:self.navigationController.viewControllers[1]  animated:YES];
            break;
        case SelectCityVCPopToRoot:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;

        default:
            break;
    }
}

#pragma mark - Lazy Load Methods
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark - Private Methods
- (void)httpRequest {
    
    [http_ requestWithMessageName:@"queryCityList" callback:^(ACMsg *responseObject, NSError *error) {
        
        NSDictionary * data = [responseObject getObjectData];
        NSArray * array = data[@"actionData"];
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:array];
        [self.tableView reloadData];
        
    } andKeyValues:@"country",self.country ,nil];
}

@end
