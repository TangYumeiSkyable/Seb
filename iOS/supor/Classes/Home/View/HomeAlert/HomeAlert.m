//
//  HomeAlert.m
//  supor
//
//  Created by 赵冰冰 on 16/9/18.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)
#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height
#define BUTTONHEIGHT 37
#define w kMainScreenWidth - 40
#import "HomeAlert.h"
#import "MBProgressHUD.h"

@interface HomeAlert ()

@end

@implementation HomeAlert

static HomeAlert * instance;
static MBProgressHUD * hud;
+(void)showWithTitle:(NSString *)title andMsg:(NSString *)msg andButtonTitles:(NSArray *)buttonTitles carriers:(UIView *)carriers block:(void (^)(NSInteger idx))aBlock
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HomeAlert alloc]init];
        instance.backgroundColor =   [UIColor whiteColor];
        instance.layer.masksToBounds = YES;
        instance.layer.cornerRadius = 9;
        instance.frame = CGRectMake(0, 0, w, 100);
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 16, w, 25)];
        titleLabel.font = [UIFont fontWithName:Medium size:18];
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [instance addSubview:titleLabel];
        titleLabel.tag = 101;
        
        UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, w, 20)];
        messageLabel.font = [UIFont fontWithName:Regular size:15];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [instance addSubview:messageLabel];
        messageLabel.tag = 102;
        
        UIView * line = [UIView new];
        line.backgroundColor = [UIColor grayColor];
        line.frame = CGRectMake(0, 0, w, 0.5);
        [instance addSubview:line];
        line.tag = 103;
    });
    
    if (instance.isOpen == YES) {
        return;
    }
    

    MBProgressHUD * progressHud = [MBProgressHUD showHUDAddedTo:carriers animated:NO];
    progressHud.minSize = CGSizeMake(kMainScreenWidth, kMainScreenWidth  / 5);
    progressHud.margin = 0;
    progressHud.mode = MBProgressHUDModeCustomView;
    progressHud.color = [UIColor clearColor];
    [hud setRemoveFromSuperViewOnHide:YES];
    hud = progressHud;
    
    instance.block = aBlock;
    UILabel * titleLbl = [instance viewWithTag:101];
    UILabel * messageLbl = [instance viewWithTag:102];
    UIView * line = [instance viewWithTag:103];
    titleLbl.text = title;
    messageLbl.text = msg;
    
    CGRect frame = titleLbl.frame;
    frame.size.height= [self mmLabelHeightWithFont:titleLbl.font andText:title maxW:titleLbl.frame.size.width];
    titleLbl.frame = frame;
    
    frame = messageLbl.frame;
    frame.size.height = [self mmLabelHeightWithFont:messageLbl.font andText:msg maxW:messageLbl.frame.size.width];
    frame.origin.y = CGRectGetMaxY(titleLbl.frame) + 17;
    messageLbl.frame = frame;
    
    frame = line.frame;
    frame.origin.y = CGRectGetMaxY(messageLbl.frame) + 30;
    line.frame = frame;
    
    for (NSInteger i = 0; i < buttonTitles.count; i++) {
        UIButton * btn = [instance viewWithTag:104 + i];
        if (btn == nil) {
            btn = [UIButton new];
        }
        btn.frame = CGRectMake(0, BUTTONHEIGHT * i + CGRectGetMaxY(line.frame), instance.frame.size.width, BUTTONHEIGHT);
        btn.titleLabel.font = [UIFont fontWithName:Regular size:18];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [instance addSubview:btn];
        [btn addTarget:instance action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:buttonTitles[i] forState:UIControlStateNormal];
        
        if (i != buttonTitles.count - 1) {

            UIView * mLine = [instance viewWithTag:1000 + i];
            if (mLine == nil) {
                mLine = [UIView new];
            }
            mLine.tag = 1000 + i;
            mLine.backgroundColor = [UIColor grayColor];
            mLine.frame = CGRectMake(0, CGRectGetMaxY(btn.frame) - 0.5, btn.frame.size.width, 0.5);
            [instance addSubview:mLine];
        }
     
    }
    
  
    frame = instance.frame;
    frame.size.height = CGRectGetMaxY(line.frame) + buttonTitles.count * BUTTONHEIGHT;
    instance.frame = frame;
    hud.customView = instance;
    [hud show:YES];
    instance.isOpen = YES;
}

-(void)btnClicked:(UIButton *)btn
{
    NSInteger idx = btn.tag - 104;
    if (instance.block) {
        instance.block(idx);
    }
    [[self class] dismiss];
}

+(CGFloat)mmLabelHeightWithFont:(UIFont *)font andText:(NSString *)text maxW:(CGFloat)width
{
    CGRect frame = [text boundingRectWithSize:CGSizeMake(w, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
    return frame.size.height;
}

+(void)dismiss
{
    instance.isOpen = NO;
    [hud setHidden:YES];
}
@end
