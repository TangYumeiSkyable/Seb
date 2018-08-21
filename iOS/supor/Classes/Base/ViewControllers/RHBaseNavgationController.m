//
//  RHBaseNavgationController.m
//  supor
//
//  Created by 赵冰冰 on 16/7/4.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHBaseNavgationController.h"
#import "UIBarButtonItem+Extension.h"
#import "UAlertView.h"
#import "RHAgreementViewController.h"
#import "LicenseViewController.h"
#import "AppDelegate.h"
#import "ACOTAManager.h"
#import "AppDelegate+Add.h"

@interface RHBaseNavgationController ()<UAlertViewDelegate>

@end

@implementation RHBaseNavgationController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        AppDelegate * app = [AppDelegate sharedInstance];
        [app registrationNotice];
        [app initializeLocationService];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *ret = [ud objectForKey:UD_COOKIES];
        if (ret.integerValue != 1) {
            UAlertView * alert = [[UAlertView alloc] initWithTitle:GetLocalResStr(@"airpurifier_login_cookies_title")
                                                               msg:GetLocalResStr(@"airpurifier_login_cookies_msg_ios")
                                                       cancelTitle:GetLocalResStr(@"airpurifier_login_cookies_more")
                                                           okTitle:GetLocalResStr(@"airpurifier_public_ok")];
            alert.delegate = self;
            [alert show];
        }
    });
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0);
    [btn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    BTN_ADDTARGET(btn, @selector(backAction));
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.delegate = self;
    viewController.navigationItem.leftBarButtonItem = left;
    [super pushViewController:viewController animated:YES];
}

- (void)backAction {
    [self popViewControllerAnimated:YES];
}

#pragma UIAlertViewDelegate

- (void)alertView:(UAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:UD_COOKIES];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:UD_COOKIES];
        LicenseViewController * lvc = [sys loadFromStoryboard:@"LoginAndRegister" andId:@"LicenseViewController"];
        [self pushViewController:lvc animated:YES];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
