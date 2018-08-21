//
//  HomeTitleView.m
//  supor
//
//  Created by 赵冰冰 on 16/6/20.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "HomeTitleView.h"

@implementation HomeTitleView

-(id)init
{
    return [self initWithFrame:CGRectMake(0, 0, kMainScreenWidth / 2, 44)];
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.gradeLbl = [UILabel new];
        self.gradeLbl.font = [UIFont fontWithName:Regular size:13];
        self.gradeLbl.textColor = [UIColor whiteColor];

        [self addSubview:self.gradeLbl];
        
        self.pmLbl = [UILabel new];
        self.pmLbl.font = [UIFont fontWithName:Regular size:13];
        self.pmLbl.textColor = [UIColor whiteColor];

        [self addSubview:self.pmLbl];
        
        self.scoreLbl = [UILabel new];
        self.scoreLbl.font = [UIFont fontWithName:Regular size:13];
        self.scoreLbl.textColor = [UIColor whiteColor];
        
        [self addSubview:self.scoreLbl];
        
        WEAKSELF(ws);
        [self.gradeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(ws);
            make.left.mas_equalTo(ws);
            make.height.mas_equalTo(20);
        }];
        
        [self.gradeLbl setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        [self.gradeLbl setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        NSArray * names = @[@"PM2.5", @"PM10", @"O₃", @"NO₃"];
        UILabel * last = nil;
        NSInteger i = 0;
        for (NSString * name in names) {
            UILabel * label = [UILabel new];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont fontWithName:Regular size:14];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = name;
            [self addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(ws).with.offset(-7);
                if (last == nil) {
                    make.left.mas_equalTo(ws.gradeLbl.mas_right).with.offset(5);
                }else{
                    make.left.mas_equalTo(last.mas_right).with.offset(0);
                }
                make.height.mas_equalTo(18);
                make.width.mas_equalTo(45);
            }];
            
            UILabel * label2 = [UILabel new];
            label2.textColor = [UIColor whiteColor];
            label2.font = [UIFont fontWithName:Regular size:14];
            label2.textAlignment = NSTextAlignmentCenter;
            if (i == 0) {
                label2.text = @"10";
            }else if (i == 1){
                label2.text = @"13";
            }else if (i == 2){
                label2.text = @"55";
            }else{
                label2.text = @"100";
            }
            [self addSubview:label2];
            [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(label);
                make.top.mas_equalTo(label.mas_bottom);
                make.height.mas_equalTo(label);
                make.width.mas_equalTo(label);
            }];
            last = label;
            i++;
        }
    }
    return self;
}

-(void)refreshGradeLbl:(NSString *)grade pmLbl:(NSString *)pm scroe:(NSString *)score
{
    self.gradeLbl.text = GetLocalResStr(@"airpurifier_push_home_you_ios");
    self.scoreLbl.text = score;
}

@end
