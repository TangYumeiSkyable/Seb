//
//  RHHomeLayout.m
//  supor
//
//  Created by 赵冰冰 on 16/6/20.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHHomeLayout.h"

static CGFloat kItemOffset = 0;

@interface RHHomeLayout ()

@property (nonatomic, strong) NSMutableArray * attributes;

@end

@implementation RHHomeLayout

- (id)init {
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (NSMutableArray *)attributes {
    if (_attributes == nil) {
        _attributes = [[NSMutableArray alloc]init];
    }
    return _attributes;
}

/**
 *  为了解决白片儿问题
 */
- (void)prepareLayout {
    [super prepareLayout];
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    self.itemSize = CGSizeMake(self.collectionView.frame.size.width - kItemOffset, self.collectionView.frame.size.height);
}

@end
