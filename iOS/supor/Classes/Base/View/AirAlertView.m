//
//  AlertView.m
//  supor
//
//  Created by 赵冰冰 on 16/6/28.
//  Copyright © 2016年 XYJ. All rights reserved.
//
#define AIRTAG 123456
#import "AirAlertView.h"
#import "UIView+WhenTappedBlocks.h"
@interface AirAlertView ()

@property (weak, nonatomic) IBOutlet UILabel *titleView02;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *pmLbl;
@property (weak, nonatomic) IBOutlet UILabel *oxideLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailMsg;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;

@property (nonatomic, strong) UIView * coverView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, assign) NSInteger type;
@property (weak, nonatomic) IBOutlet UILabel *setttingTImeLbl;

@property (nonatomic ,assign) NSArray * arr;
@end

@implementation AirAlertView


-(NSArray *)arr
{
    if (_arr == nil) {
        _arr = @[self.titleView, self.pmLbl, self.oxideLbl, self.detailMsg];
    }
    return _arr;
}


-(UIView *)coverView
{
    if (_coverView == nil) {
        _coverView = [UIView new];
        _coverView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        _coverView.backgroundColor = [UIColor blackColor];
        
//        [_coverView whenTapped:^{
//            
//        }];
        
        _coverView.alpha = 0.5;
    }
    return _coverView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    
    self.titleView.font = [UIFont fontWithName:Medium size:18];
    self.titleView.textColor = [UIColor colorFromHexCode:@"#36424a"];
    
    self.pmLbl.font = [UIFont fontWithName:Regular size:16];
    self.pmLbl.textColor = [UIColor colorFromHexCode:@"#36424a"];
    
    self.oxideLbl.font = [UIFont fontWithName:Regular size:16];
    self.oxideLbl.textColor = [UIColor colorFromHexCode:@"#36424a"];
    
    self.detailMsg.font = [UIFont fontWithName:Regular size:16];
    self.detailMsg.textColor = [UIColor colorFromHexCode:@"#36424a"];
    
    self.titleView02.font = [UIFont fontWithName:Regular size:16];
    self.titleView02.textColor = [UIColor colorFromHexCode:@"#36424a"];
    
    self.cancelBtn.titleLabel.font = [UIFont fontWithName:Regular size:16];
    [self.cancelBtn setTitleColor:[UIColor classics_blue] forState:UIControlStateNormal];
    
    self.confirmBtn.titleLabel.font = [UIFont fontWithName:Regular size:16];
    [self.confirmBtn setTitleColor:[UIColor classics_blue] forState:UIControlStateNormal];
}

-(void)show
{
    self.titleView02.preferredMaxLayoutWidth = self.frame.size.width - 40;
    
    if (self.type == 1) {
        
        self.titleView.hidden = YES;
        self.pmLbl.hidden = YES;
        self.oxideLbl.hidden = YES;
        self.detailMsg.hidden = YES;
        self.containerView.hidden = NO;
        self.setttingTImeLbl.hidden = NO;
        
    }else if (self.type == 0){
        //开关 开
        self.titleView.hidden = NO;
        self.pmLbl.hidden = NO;
        self.oxideLbl.hidden = NO;
        self.detailMsg.hidden = NO;
        self.containerView.hidden = YES;
    }else if(self.type == 2){
        //开关 关
        self.titleView.hidden = YES;
        self.pmLbl.hidden = YES;
        self.oxideLbl.hidden = YES;
        self.detailMsg.hidden = YES;
        self.containerView.hidden = NO;
        self.setttingTImeLbl.hidden = YES;
        self.setttingTImeLbl.textAlignment = NSTextAlignmentCenter;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.coverView];
    [[UIApplication sharedApplication].keyWindow  addSubview:self];
     [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.coverView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    if (self.type == 1) {
        
        CGRect frame = [self.titleView02.text boundingRectWithSize:CGSizeMake(self.containerView.frame.size.width - 40, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleView02.font} context:nil];
        
        CGFloat h = frame.size.height + 110;
        self.frame = CGRectMake(20, kMainScreenHeight / 2 - h / 2 , kMainScreenWidth - 40, h );
        
    }else if(self.type == 0){
        
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
        }];
        
        [self.pmLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(self.titleView.mas_bottom).offset(30);
            make.left.mas_equalTo(20);
        }];
        
        [self.oxideLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(self.pmLbl.mas_top);
            make.left.mas_equalTo(self.pmLbl.mas_right).offset(20);
            make.right.mas_equalTo(-20);
        }];
        
        [self.detailMsg mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(self.oxideLbl.mas_bottom).offset(20);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
        }];
        
        [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(self.detailMsg.mas_bottom).offset(30);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(1);
        }];
        
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(self.line1.mas_bottom);
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(50);
        }];
        
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line1.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.line2.mas_left).offset(0.5);
            make.height.mas_equalTo(50);
        }];
        
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line1.mas_bottom);
            make.left.mas_equalTo(self.line2.mas_right);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(50);
        }];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(0);
            make.bottom.mas_equalTo(self.line2.mas_bottom);
        }];
        
        
    }else if(self.type == 2){
        
        
        [self.titleView02 mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(self.mas_right).offset(-20);
        }];
        
        [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.titleView02.mas_bottom).offset(20);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(1);
        }];
        
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.line1.mas_bottom);
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(50);
        }];
        
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line1.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.line2.mas_left).offset(0.5);
            make.height.mas_equalTo(50);
        }];
        
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line1.mas_bottom);
            make.left.mas_equalTo(self.line2.mas_right);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(50);
        }];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(0);
            make.bottom.mas_equalTo(self.line2.mas_bottom);
        }];
        
    }
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

+(id)initWithTitle:(NSString *)title settingTime:(NSString *)settingTime okText:(NSString *)oktext cancelText:(NSString *)cancelText
{
    AirAlertView * alert = [[[NSBundle mainBundle] loadNibNamed:@"AirAlertView" owner:nil options:nil] lastObject];
    alert.containerView.backgroundColor = [UIColor whiteColor];
    alert.containerView.hidden = NO;
    alert.tag = AIRTAG;
    alert.type = 1;
    alert.titleView02.text = title;
    alert.titleView02.preferredMaxLayoutWidth = alert.containerView.frame.size.width - 40;

    alert.setttingTImeLbl.textAlignment = NSTextAlignmentLeft;
    alert.setttingTImeLbl.text = settingTime;
    
//    WEAKSELF(ws);
    __weak AirAlertView * weakAlert =  alert;
    [alert.setttingTImeLbl whenTapped:^{
        
        if (weakAlert.indexChanged) {
            weakAlert.indexChanged(-1);
        }
    }];
    
    [alert.confirmBtn setTitle:oktext forState:UIControlStateNormal];
    [alert.cancelBtn setTitle:cancelText forState:UIControlStateNormal];
    return alert;
}

+(id)initCloseWithTitle:(NSString *)title settingTime:(NSString *)settingTime okText:(NSString *)oktext cancelText:(NSString *)cancelText
{

    AirAlertView * alert = [[[NSBundle mainBundle] loadNibNamed:@"AirAlertView" owner:nil options:nil] lastObject];
    alert.containerView.backgroundColor = [UIColor whiteColor];
    alert.containerView.hidden = NO;
    alert.tag = AIRTAG;
    alert.type = 2;
    alert.titleView02.text = title;
    alert.titleView02.preferredMaxLayoutWidth = alert.containerView.frame.size.width - 40;
    
    
    [alert.confirmBtn setTitle:oktext forState:UIControlStateNormal];
    [alert.cancelBtn setTitle:cancelText forState:UIControlStateNormal];
    return alert;
}

+(id)initWithTitle:(NSString *)title pm:(NSString *)pm oxide:(NSString *)oxide detail:(NSString *)detail
{
    AirAlertView * alert = [[[NSBundle mainBundle] loadNibNamed:@"AirAlertView" owner:nil options:nil] lastObject];
    alert.containerView.hidden = YES;
    alert.tag = AIRTAG;
    alert.titleView.text = title;
    alert.pmLbl.text = [NSString stringWithFormat:@"PM2.5   %@", pm];
    alert.oxideLbl.text = [NSString stringWithFormat:@"%@   %@", GetLocalResStr(@"airpurifier_more_show_olfactory_text"),oxide];
    alert.detailMsg.text = detail;
    [alert.confirmBtn setTitle:GetLocalResStr(@"airpurifier_push_alert_pm_yes") forState:UIControlStateNormal];
    [alert.cancelBtn setTitle:GetLocalResStr(@"airpurifier_push_alert_pm_no") forState:UIControlStateNormal];
    return alert;
}

- (IBAction)comfirmClicked:(id)sender {
    
    if (self.indexChanged) {
        self.indexChanged(1);
    }
    [self dismiss];
}

- (IBAction)cancelClicked:(id)sender {
    if (self.indexChanged) {
        self.indexChanged(0);
    }
    [self dismiss];
}

@end
