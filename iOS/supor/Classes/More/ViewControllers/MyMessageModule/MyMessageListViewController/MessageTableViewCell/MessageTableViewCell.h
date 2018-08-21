//
//  MessageTableViewCell.h
//  supor
//
//  Created by 白云杰 on 2017/5/11.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelState;

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;

@property (nonatomic, weak) IBOutlet UILabel *lableTime;

@property (nonatomic, weak) IBOutlet UILabel *labelContent;

@end
