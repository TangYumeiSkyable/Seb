//
//  OutdoorAirViewController.m
//  supor
//
//  Created by 白云杰 on 2017/5/18.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "OutdoorAirViewController.h"
#import "HeaderCollectionViewCell.h"
#import "ContentCollectionViewCell.h"

@interface OutdoorAirViewController ()<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *selectedImageNameArray;

@property (nonatomic, strong) NSArray *normalImageNameArray;

@property (nonatomic, strong) NSMutableArray *stateImageNameArray;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *subTitleArray;

@property (nonatomic, strong) NSArray *contentTextArray;

@property (nonatomic, strong) CALayer *selectedItemLayer;

@property (nonatomic, strong) UICollectionView *headerCollectionView;

@property (nonatomic, strong) UICollectionView *contentCollectionView;
//Add paging control
@property (nonatomic, strong) UIPageControl* pageCtrl;

@property (nonatomic, assign) CGFloat headScrollPage;

@end

@implementation OutdoorAirViewController
static CGFloat separateHeight = 20;
static CGFloat screenSeparateNumber = 3.0;
static NSString * const headerCellIdentifier = @"headerCell";
static NSString * const contentCellIdentifier = @"contentCell";

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    _headScrollPage = 0;
    [self configUI];
    [self initViews];
}

#pragma mark - Common Methods
- (void)configUI {
    self.view.backgroundColor = RGB(242, 242, 242);
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_airquality_text");
    self.navigationController.navigationBar.translucent = NO;
}

- (void)initViews {
    [self.view addSubview:self.headerCollectionView];
    [self.view addSubview:self.contentCollectionView];
//    [self.view addSubview:self.pageCtrl];
    [self.headerCollectionView.layer addSublayer:self.selectedItemLayer];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.normalImageNameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.headerCollectionView) {
        HeaderCollectionViewCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:headerCellIdentifier forIndexPath:indexPath];
        headerCell.levelImageView.image = [UIImage imageNamed:self.stateImageNameArray[indexPath.item]];
        return headerCell;
    }
    
    ContentCollectionViewCell *contentCell = [collectionView dequeueReusableCellWithReuseIdentifier:contentCellIdentifier forIndexPath:indexPath];
    contentCell.titleLabel.text = self.titleArray[indexPath.item];
    contentCell.subTitleLabel.text = self.subTitleArray[indexPath.item];
    contentCell.contentTextLabel.text = self.contentTextArray[indexPath.item];
    return contentCell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger number =  self.contentCollectionView.contentOffset.x / kMainScreenWidth;
//    self.pageCtrl.currentPage = number;
    if (number < 1) {
        _headScrollPage = 0;
    } else if (number > 5) {
        _headScrollPage = 4;
    } else {
        _headScrollPage = number - 1;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.headerCollectionView.contentOffset = CGPointMake(_headScrollPage * (kMainScreenWidth / screenSeparateNumber + 10), self.headerCollectionView.contentOffset.y);
    }];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.selectedItemLayer.frame = CGRectMake(number * (kMainScreenWidth / screenSeparateNumber) + (number - 1) * 10, kMainScreenHeight / 11.0 - 2, kMainScreenWidth / screenSeparateNumber + 10, 2);
    }];
    
    [self.stateImageNameArray removeAllObjects];
    [self.stateImageNameArray addObjectsFromArray:self.normalImageNameArray];
    [self.stateImageNameArray replaceObjectAtIndex:number withObject:self.selectedImageNameArray[number]];
    [self.headerCollectionView reloadData];
}



#pragma mark - Lazyload Methods
- (UICollectionView *)headerCollectionView {
    if (!_headerCollectionView) {
        UICollectionViewFlowLayout *headerLayout = [[UICollectionViewFlowLayout alloc] init];
        headerLayout.itemSize = CGSizeMake(kMainScreenWidth / screenSeparateNumber + 10, kMainScreenHeight / 11.0);
        headerLayout.minimumLineSpacing = 0;
        headerLayout.minimumInteritemSpacing = 0;
        headerLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _headerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:headerLayout];
        _headerCollectionView.backgroundColor = LJHexColor(@"#EEEEEE");
        _headerCollectionView.delegate = self;
        _headerCollectionView.dataSource = self;
        _headerCollectionView.scrollEnabled = NO;
        _headerCollectionView.showsVerticalScrollIndicator = NO;
        _headerCollectionView.showsVerticalScrollIndicator = NO;
        [_headerCollectionView registerClass:[HeaderCollectionViewCell class] forCellWithReuseIdentifier:headerCellIdentifier];
    }
    return _headerCollectionView;
}

- (UICollectionView *)contentCollectionView {
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *contentLayout = [[UICollectionViewFlowLayout alloc] init];
        contentLayout.itemSize = CGSizeMake(kMainScreenWidth, kMainScreenHeight - kMainScreenHeight / 11 - DeviceUtils.navigationStatusBarHeight - separateHeight);
        contentLayout.minimumLineSpacing = 0;
        contentLayout.minimumInteritemSpacing = 0;
        contentLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:contentLayout];
        _contentCollectionView.backgroundColor = LJHexColor(@"#EEEEEE");
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.showsVerticalScrollIndicator = 0;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.pagingEnabled = YES;
        _contentCollectionView.bounces = NO;
        [_contentCollectionView registerClass:[ContentCollectionViewCell class] forCellWithReuseIdentifier:contentCellIdentifier];
    }
    return _contentCollectionView;
}

//- (UIPageControl *)pageCtrl {
//    if (!_pageCtrl) {
//        _pageCtrl = [[UIPageControl alloc] init];
//        _pageCtrl.numberOfPages = self.normalImageNameArray.count;//总的图片页数
//        _pageCtrl.currentPage = 0;
//        _pageCtrl.enabled = NO;
//        _pageCtrl.pageIndicatorTintColor = [UIColor whiteColor];
//        _pageCtrl.currentPageIndicatorTintColor = [UIColor blackColor];
//    }
//    return _pageCtrl;
//}

- (CALayer *)selectedItemLayer {
    if (!_selectedItemLayer) {
        _selectedItemLayer = [[CALayer alloc] init];
        _selectedItemLayer.frame = CGRectMake(0, kMainScreenHeight / 11.0 - 2, kMainScreenWidth / screenSeparateNumber, 2);
        _selectedItemLayer.backgroundColor = LJHexColor(@"#009dc2").CGColor;
    }
    return _selectedItemLayer;
}

- (NSArray *)normalImageNameArray {
    if (!_normalImageNameArray) {
        _normalImageNameArray = @[@"ico_air_01m_nor", @"ico_air_02m_nor", @"ico_air_03m_nor",
                                  @"ico_air_04m_nor", @"ico_air_05m_nor", @"ico_air_06m_nor",
                                  @"ico_air_07m_nor"];
    }
    return _normalImageNameArray;
}

- (NSArray *)selectedImageNameArray {
    if (!_selectedImageNameArray) {
        _selectedImageNameArray = @[@"ico_air_01m_sel", @"ico_air_02m_sel", @"ico_air_03m_sel",
                                    @"ico_air_04m_sel", @"ico_air_05m_sel", @"ico_air_06m_sel",
                                    @"ico_air_07m_sel"];
    }
    return _selectedImageNameArray;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[GetLocalResStr(@"airpurifier_more_airquality_fresh"), GetLocalResStr(@"airpurifier_more_airquality_moderate"), GetLocalResStr(@"airpurifier_more_airquality_high"), GetLocalResStr(@"airpurifier_more_airquality_very"), GetLocalResStr(@"airpurifier_more_airquality_excessive"), GetLocalResStr(@"airpurifier_more_airquality_extreme"), GetLocalResStr(@"airpurifier_more_airquality_airpocalypse")];
    }
    return _titleArray;
}

- (NSArray *)subTitleArray {
    if (!_subTitleArray) {
        _subTitleArray = @[GetLocalResStr(@"airpurifier_more_air_fresh_headline"), GetLocalResStr(@"airpurifier_more_air_moderate_headline"), GetLocalResStr(@"airpurifier_more_air_high_headline"), GetLocalResStr(@"airpurifier_more_air_very_headline"), GetLocalResStr(@"airpurifier_more_air_excessive_headline"), GetLocalResStr(@"airpurifier_more_air_extreme_headline"), GetLocalResStr(@"airpurifier_more_air_airpocalypse_headline")];
    }
    return _subTitleArray;
}

- (NSArray *)contentTextArray {
    if (!_contentTextArray) {
        _contentTextArray = @[GetLocalResStr(@"airpurifier_more_air_fresh_description"), GetLocalResStr(@"airpurifier_more_air_moderate_description"), GetLocalResStr(@"airpurifier_more_air_high_description"), GetLocalResStr(@"airpurifier_more_air_very_description"), GetLocalResStr(@"airpurifier_more_air_excessive_description"), GetLocalResStr(@"airpurifier_more_air_extreme_description"), GetLocalResStr(@"airpurifier_more_air_airpocalypse_description")];
    }
    return _contentTextArray;
}

- (NSMutableArray *)stateImageNameArray {
    if (!_stateImageNameArray) {
        _stateImageNameArray = [NSMutableArray arrayWithArray:self.normalImageNameArray];
        [_stateImageNameArray replaceObjectAtIndex:0 withObject:self.selectedImageNameArray[0]];
    }
    return _stateImageNameArray;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.headerCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kMainScreenHeight / 11);
    }];
    
    [self.contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerCollectionView.mas_bottom).offset(15);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
//    [self.pageCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentCollectionView.mas_bottom).offset(-40);
//        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(30);
//    }];
}

@end
