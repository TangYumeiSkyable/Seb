//
//  RHBrezzeTable.m
//  supor
//
//  Created by 赵冰冰 on 16/6/23.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHBrezzeTable.h"

@interface RHBrezzeTable ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@end


static RHBrezzeTable * _table;

@implementation RHBrezzeTable



-(UITableView *)tableView
{
    WEAKSELF(ws);
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(ws);
        }];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    if ([self.delegate respondsToSelector:@selector(RHBrezzeTable:numberOfRowInSection:)]) {
       num = [self.delegate RHBrezzeTable:self numberOfRowInSection:section];
    }
    return num;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    if ([self.delegate respondsToSelector:@selector(RHBrezzeTable:cellforRowAtIndexPath:)]) {
        cell = [self.delegate RHBrezzeTable:_table.tableView cellforRowAtIndexPath:indexPath];
    }
    return cell;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor greenColor];
        [self addSubview:self.tableView];
    }
    return self;
}

+(void)showAbove:(CGRect)frame inView:(UIView *)aView delegate:(id<RHBrezzeTableDelegate>)delegate
{
    RHBrezzeTable * table = nil;
    for (NSInteger i = aView.subviews.count - 1; i >= 0; i--) {
        
        UIView * s = aView.subviews[i];
        if ([s isKindOfClass:[self class]]) {
            table = (RHBrezzeTable *)s;
       
            [aView bringSubviewToFront:table];
            
            break;
        }
      
    }
    if (table == nil) {
        table = [[RHBrezzeTable alloc]initWithFrame:CGRectMake(frame.origin.x, CGRectGetMinY(frame), frame.size.width, 1)];
        [aView addSubview:table];
        table.delegate = delegate;
    }
    NSInteger row = 0;
    if ([table.delegate respondsToSelector:@selector(RHBrezzeTable:numberOfRowInSection:)]) {
        row = [table.delegate RHBrezzeTable:table numberOfRowInSection:0];
    }
    CGFloat h = row * 44;
    
    _table = table;
    
    [_table mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(frame.origin.x);
        make.width.mas_equalTo(frame.size.width);
        make.height.mas_equalTo(0);
        make.bottom.mas_equalTo(frame.origin.y);
    }];
    [_table layoutIfNeeded];
    
    _table -> _isShowing = YES;
    [UIView animateWithDuration:0.22 animations:^{
        
        [_table mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(frame.origin.x);
            make.width.mas_equalTo(frame.size.width);
            make.height.mas_equalTo(h);
            make.bottom.mas_equalTo(frame.origin.y);
    
        }];
        [_table layoutIfNeeded];
    }];
}

+(void)dismiss
{
    if (_table) {
        
        _table -> _isShowing = NO;
        [UIView animateWithDuration:0.22 animations:^{
            [_table mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            [_table layoutIfNeeded];
        }];
    }
  
}

+(instancetype)currentMenu
{
    return _table;
}
@end
