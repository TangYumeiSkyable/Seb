//
//  RHSysUtil.m
//  millHeater
//
//  Created by 赵冰冰 on 16/4/20.
//  Copyright © 2016年 colin. All rights reserved.
//

#import "RHSysUtil.h"
#import "NSString+LKExtension.h"
@implementation RHSysUtil

+(instancetype)shareInstance
{
    static RHSysUtil * instance = nil;
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[RHSysUtil alloc]init];
        });
    }
    return instance;
}

-(void)showAlertInViewControlelr:(UIViewController *)vc title:(NSString *)title message:(NSString *)msg titles:(NSArray *)titles cancelTitle:(NSString *)canceltitle
{
    NSMutableArray * arrayM = [[NSMutableArray alloc]init];
    [arrayM addObjectsFromArray:titles];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertActionStyle style = UIAlertActionStyleDefault;
    for (int i = 0; i < arrayM.count; i++) {
        UIAlertAction * ac = [UIAlertAction actionWithTitle:arrayM[i] style:style handler:^(UIAlertAction * _Nonnull action) {
            if (self.alertBlock) {
                self.alertBlock(i);
                self.alertBlock = nil;
            }
        }];
        [alert addAction:ac];
    }
    if (canceltitle) {
        UIAlertAction * ac = [UIAlertAction actionWithTitle:canceltitle style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (self.alertBlock) {
//                self.block(arrayM.count);
                self.alertBlock(arrayM.count);
                self.alertBlock = nil;
            }
        }];
        [alert addAction:ac];
    }
    
    [vc presentViewController:alert animated:YES completion:^{
    }];

}

-(void)showActionSheetInViewControlelr:(UIViewController *)vc titles:(NSArray *)titles cancelTitle:(NSString *)canceltitle destructiveIndex:(NSInteger)index
{
    self.block = nil;
    NSMutableArray * arrayM = [[NSMutableArray alloc]init];
    [arrayM addObjectsFromArray:titles];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertActionStyle style = UIAlertActionStyleDefault;
    for (int i = 0; i < arrayM.count; i++) {
        if (i == index) {
            style = UIAlertActionStyleDestructive;
        }
        UIAlertAction * ac = [UIAlertAction actionWithTitle:arrayM[i] style:style handler:^(UIAlertAction * _Nonnull action) {
            if (self.block) {
                self.block(i);
            }
        }];
        [alert addAction:ac];
    }
    
    if (canceltitle) {
        UIAlertAction * ac = [UIAlertAction actionWithTitle:canceltitle style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (self.block) {
                self.block(arrayM.count);
            }
        }];
        [alert addAction:ac];
    }

    [vc presentViewController:alert animated:YES completion:^{
      
    }];
}

-(id)loadFromStoryboard:(NSString *)storyName andId:(NSString *)storyId
{
    UIStoryboard * story = [UIStoryboard storyboardWithName:storyName bundle:nil];
    UIViewController * vc = [story instantiateViewControllerWithIdentifier:storyId];
    return (id)vc;
}

-(NSString *)tranfromHourToTimeStringWithHour:(CGFloat)hour
{
    NSTimeInterval t = [@"2000-01-01 00:00:00" longlongFromDate];
    t = t + hour * 3600;
    NSDate * startDate = [NSDate dateWithTimeIntervalSince1970:t];

    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    //int week=0;
    comps = [calendar components:unitFlags fromDate:startDate];
    
    //小时
    NSInteger hour1 = [comps hour];
    //分钟
    NSInteger min1 = [comps minute];
    NSString * str = [NSString stringWithFormat:@"%ld:%.2ld", (long)hour1, (long)min1];
    return str;
}

@end
