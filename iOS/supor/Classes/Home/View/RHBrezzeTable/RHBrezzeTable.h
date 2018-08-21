//
//  RHBrezzeTable.h
//  supor
//
//  Created by 赵冰冰 on 16/6/23.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RHBrezzeTable;
@protocol  RHBrezzeTableDelegate <NSObject>

-(NSInteger)RHBrezzeTable:(RHBrezzeTable *)table numberOfRowInSection:(NSInteger)section;

-(UITableViewCell *)RHBrezzeTable:(UITableView *)table cellforRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface RHBrezzeTable : UIView

@property (nonatomic, assign) id <RHBrezzeTableDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isShowing;
+(void)showAbove:(CGRect)frame inView:(UIView *)aView delegate:(id<RHBrezzeTableDelegate>)delegate;
+(void)dismiss;
+(instancetype)currentMenu;
@end
