//
//  AppointmentViewController.m
//  supor
//
//  Created by 赵冰冰 on 16/6/30.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "AppointmentViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "AppDelegate.h"
#import "RHTimerItem.h"
#import "JSTimerModel.h"
#import "ACTimerManager.h"
#import "ACDeviceTimerManager.h"
#import "NSString+LKExtension.h"
#import "ACDeviceTimerManager.h"
#import "AppointmentDetailViewController.h"
#import "NSDate+YYAdd.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface AppointmentViewController ()<AppointmentDetailViewControllerDelegate>

@property (nonatomic, strong) NSString *indexStr; //1.列表 2.新建 3.修改 4.星期
@property (nonatomic, strong) NSString *week; //周日 周一 周二 周三 周四
@property (nonatomic, strong) NSString *repeat; // week[0,1,2]
@property (nonatomic, strong) NSArray *arr;/*<__NSArrayI 0x14118e1b0>(
                                             3, //pagestr
                                             3, //deviceId
                                             测试设备,
                                             412_413
                                             )*/

@property (nonatomic, strong) NSMutableArray *schedulingModelArray;
@property (nonatomic, strong) NSMutableArray *schedulingInfoArray;
@property (nonatomic, strong) NSArray *modeArray;
@property (nonatomic, strong) NSArray *mode2Array;
@property (strong, nonatomic) NSString *jsString;

@property (assign, nonatomic) BOOL isAddAction;

@end

@implementation AppointmentViewController

#pragma mark - View Lifecycle Method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSchedulingListNavItem];
    [self queryAllDeviceSchedulingWithShowHUD:YES complete:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
     self.fd_prefersNavigationBarHidden = NO;
}

#pragma mark - Private Methods
- (void)setupNotify {
    [self registerMsgName:NOTIFY_DELETE_APPOINT selector:@selector(deleteSchedulingByNotification:)];
    [self registerMsgName:NOTIFY_ADD_APPOINT selector:@selector(checkActionTypeByNotification:)];
    [self registerMsgName:NOTIFY_ADDTASK selector:@selector(addSchedulingByNotification:)];
    [self registerMsgName:NOTIFY_MODIFY_APPOINT selector:@selector(checkModifyInfoByNotification:)];
    [self registerMsgName:NOTIFY_MODIFY_TASK selector:@selector(modifySchedulingByNotification:)];
    [self registerMsgName:NOTIFY_OPEN_TASK selector:@selector(openSchedulingByNotification:)];
    [self registerMsgName:NOTIFY_CLOSE_TASK selector:@selector(closeSchedulingByNotification:)];
}

// config scheduling ListView NavigationItem
- (void)setSchedulingListNavItem {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0);
    [btn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    BTN_ADDTARGET(btn, @selector(backAction));
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [UIBarButtonItem createRightItemWithFrame:CGRectMake(0, 0, 11*59/33, 11*59/33) title:nil image:[UIImage imageNamed:@"add_white"] highLightImage:nil target:self selector:@selector(addNewScheduling)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setAddSchedulingNavItem {
    UIBarButtonItem *leftItem = [UIBarButtonItem mCreateLeftItemWithFrame:CGRectMake(0, 0, 15, 15) title:nil image:[UIImage imageNamed:@"ico_cancel"] highLightImage:nil target:self selector:@selector(schedulingBackAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [UIBarButtonItem createRightItemWithFrame:CGRectMake(0, 0, 15, 15) title:nil image:[UIImage imageNamed:@"ico_confirm"] highLightImage:nil target:self selector:@selector(confirmSchedulingAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - NavigationItem Action
- (void)backAction {
    if ([[self.webView.request.URL absoluteString] containsString:@"appointment-list"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.webView goBack];
        
        NSString *strUrl = [self.webView.request.URL absoluteString];
        if ([strUrl containsString:@"appointment-list"]) {
            [self queryAllDeviceSchedulingWithShowHUD:YES complete:nil];
        }
    }
}

- (void)addNewScheduling {
    [self.webView stringByEvaluatingJavaScriptFromString:@"addappoint()"];
}

- (void)confirmSchedulingAction {
    
    if (self.isAddAction == YES) return;
        self.isAddAction = YES;
    
    if ([self.indexStr isEqualToString:@"2"]) {
        NSString *js = @"addTimer()";
        [self.webView stringByEvaluatingJavaScriptFromString:js];
    }
    if ([self.indexStr isEqualToString:@"3"]) {
        NSString * js = @"modifyTimer()";
        [self.webView stringByEvaluatingJavaScriptFromString:js];
    }
}

- (void)schedulingBackAction {
    self.repeat = nil;
    self.week = nil;
    self.arr = nil;
    self.indexStr = nil;
    self.isAddAction = NO;
    [self.webView goBack];
}

#pragma mark Notification Action Method
- (void)deleteSchedulingByNotification:(NSNotification *)notification {
    NSArray *arr = notification.object;
    NSString *deviceId = arr[0];
    NSString *taskId = arr[1];
    
    NSArray *tasks = [taskId componentsSeparatedByString:@"_"];
    
    WEAKSELF(ws);
    __block NSInteger count = tasks.count;
    for (NSString *strTaskId in tasks) {
        
//        ACTimerManager *timerManager = [[ACTimerManager alloc] init];
        ACDeviceTimerManager *timeManager = [[ACDeviceTimerManager alloc] initWithDeviceId:deviceId.longLongValue];
        [timeManager deleteTask:[NSString stringWithFormat:@"%lli",strTaskId.longLongValue]
                       callback:^(NSError *error) {
                           [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_show_deletedingtimesuccess_text")];
                           ws.isAddAction = NO;
                           count--;
                           // if delete all scheduling, refresh scheduling list
                           if (count == 0) {
                               [ws queryAllDeviceSchedulingWithShowHUD:YES complete:nil];
                           }
                       }];
//        [timerManager deleteTaskWithDeviceId:deviceId.longLongValue
//                                      taskId:strTaskId.longLongValue
//                                    callback:^(NSError *error) {
//                                        [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_show_deletedingtimesuccess_text")];
//                                        ws.isAddAction = NO;
//                                        count--;
//                                        // if delete all scheduling, refresh scheduling list
//                                        if (count == 0) {
//                                            [ws queryAllDeviceSchedulingWithShowHUD:YES complete:nil];
//                                        }
//                                    }];
    }
}

- (void)checkActionTypeByNotification:(NSNotification *)notification {
    NSString *str = notification.object;
    if (![str isEqualToString:@"4"]) {
        self.indexStr = str;
    }
    if ([str isEqualToString:@"2"]) {
        NSURL *url = [self nameWithUrl:@"appointment-item"];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    } else if([str isEqualToString:@"4"]){
        AppointmentDetailViewController *detailvc = [[AppointmentDetailViewController alloc]init];
        detailvc.week = self.week;
        detailvc.repeat = self.repeat;
        detailvc.delegate = self;
        [self.navigationController pushViewController:detailvc animated:NO];
    }
}

// confirm add scheduling
- (void)addSchedulingByNotification:(NSNotification *)notification {
    WEAKSELF(ws);
    [self queryAllDeviceSchedulingWithShowHUD:NO complete:^{
        [ws addTaskWithNotification:notification];
    }];
}

- (void)checkModifyInfoByNotification:(NSNotification *)notification {
    NSArray *arr = notification.object;
    self.indexStr = arr[0];
    self.arr = arr;
    NSString *taskID = [arr lastObject];
    NSDictionary *tempDic = nil;
    for (NSDictionary *dic in self.schedulingInfoArray) {
        NSString * tempTaskID = [NSString stringWithFormat:@"%@",dic[@"taskId"]];
        
        if ([taskID isEqualToString:tempTaskID]) {
            tempDic = dic;
            break;
        }
    }
    
    self.repeat = tempDic[@"timeCycle"];
    if ([self.repeat isEqualToString:@"once"]) {
        self.week = GetLocalResStr(@"airpurifier_more_show_onceword_tex");
    } else {
        
        NSString * tempRepeat = [self.repeat stringByReplacingOccurrencesOfString:@"week[" withString:@""];
        tempRepeat = [tempRepeat stringByReplacingOccurrencesOfString:@"]" withString:@""];
        NSArray *component = [tempRepeat componentsSeparatedByString:@","];
        
        NSString *week = @"";
        
        NSDictionary *weekDic = @{@"0" : GetLocalResStr(@"airpurifier_more_show_sunword_text"),
            @"1" : GetLocalResStr(@"airpurifier_more_show_monword_text"),
            @"2" : GetLocalResStr(@"airpurifier_more_show_tuesword_text"),
            @"3" : GetLocalResStr(@"airpurifier_more_show_wedword_text"),
            @"4" : GetLocalResStr(@"airpurifier_more_show_thurword_text"),
            @"5" : GetLocalResStr(@"airpurifier_more_show_friword_text"),
            @"6" : GetLocalResStr(@"airpurifier_more_show_satword_text")};
        
        for (NSString *str in component) {
            
            week = [week stringByAppendingFormat:@"%@ ", [weekDic objectForKey:str]];
        }
        self.week = week;
    }
    
    NSURL *url = [self nameWithUrl:@"appointment-item"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

// confirm modify scheduling
- (void)modifySchedulingByNotification:(NSNotification *)notification {
    WEAKSELF(ws);
    [self queryAllDeviceSchedulingWithShowHUD:NO complete:^{
        [ws modifyWithNotification:notification];
    }];
    
}

- (void)openSchedulingByNotification:(NSNotification *)notification {
    NSDictionary * dict = notification.object;
    
    NSString *deviceId = dict[@"deviceId"];
    NSString *task = dict[@"taskId"];
    NSArray *tasks = [task componentsSeparatedByString:@"_"];
    
    NSString *curTaskId = tasks[0];
//    ACTimerManager * mgr = [[ACTimerManager alloc] init];
    ACDeviceTimerManager *timeManager = [[ACDeviceTimerManager alloc] initWithDeviceId:deviceId.longLongValue];
    WEAKSELF(ws);
    
    [timeManager openTask:[NSString stringWithFormat:@"%lli",curTaskId.longLongValue]
                 callback:^(NSError *error) {
                     ws.isAddAction = NO;
                     if (error == nil) {
                         NSString * curTaskId2 = tasks[1];
//                         ACTimerManager *mgr2 = [[ACTimerManager alloc]init];
                         ACDeviceTimerManager *timeManager2 = [[ACDeviceTimerManager alloc] initWithDeviceId:deviceId.longLongValue];
                         [timeManager2 openTask:[NSString stringWithFormat:@"%lli",curTaskId2.longLongValue]
                                       callback:^(NSError *error) {
                                           if (error == nil) {
                                               [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_show_open_dingtime_success_text")];
                                           }
                                           [ws queryAllDeviceSchedulingWithShowHUD:NO complete:nil];
                                       }];
                         
//                         [mgr2 openTaskWithDeviceId:deviceId.longLongValue
//                                             taskId:curTaskId2.longLongValue
//                                           callback:^(NSError *error) {
//                                               if (error == nil) {
//                                                   [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_show_open_dingtime_success_text")];
//                                               }
//                                               [ws queryAllDeviceSchedulingWithShowHUD:NO complete:nil];
//                                           }];
                     } else {
                         [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_show_operatorfailed_text")];
                     }
                 }];
    
//    [mgr openTaskWithDeviceId:deviceId.longLongValue
//                       taskId:curTaskId.longLongValue
//                     callback:^(NSError *error) {
//                         ws.isAddAction = NO;
//                         if (error == nil) {
//                             NSString * curTaskId2 = tasks[1];
//                             ACTimerManager *mgr2 = [[ACTimerManager alloc]init];
//
//                             [mgr2 openTaskWithDeviceId:deviceId.longLongValue
//                                                 taskId:curTaskId2.longLongValue
//                                               callback:^(NSError *error) {
//                                                   if (error == nil) {
//                                                       [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_show_open_dingtime_success_text")];
//                                                   }
//                                                   [ws queryAllDeviceSchedulingWithShowHUD:NO complete:nil];
//                                               }];
//                         } else {
//                             [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_show_operatorfailed_text")];
//                         }
//                     }];
}

- (void)closeSchedulingByNotification:(NSNotification *)notification {
    NSDictionary * dict = notification.object;
    
    NSString * deviceId = dict[@"deviceId"];
    NSString * task = dict[@"taskId"];
    NSArray * tasks = [task componentsSeparatedByString:@"_"];
    
    NSString * curTaskId = tasks[0];
//    ACTimerManager * mgr = [[ACTimerManager alloc] init];
    ACDeviceTimerManager *timeManager = [[ACDeviceTimerManager alloc] initWithDeviceId:deviceId.longLongValue];
    
    WEAKSELF(ws);
    [timeManager closeTask:[NSString stringWithFormat:@"%lli",curTaskId.longLongValue]
                  callback:^(NSError *error) {
                      if (error == nil) {
                          
                          NSString * curTaskId2 = tasks[1];
                          
//                          ACTimerManager * mgr2 = [[ACTimerManager alloc]init];
                          ACDeviceTimerManager *timeManager2 = [[ACDeviceTimerManager alloc] initWithDeviceId:deviceId.longLongValue];
                          [timeManager2 closeTask:[NSString stringWithFormat:@"%lli",curTaskId2.longLongValue]
                                         callback:^(NSError *error) {
                                             if (error == nil) {
                                                 [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_show_closedingtimesuccess_text")];
                                             }
                                             [ws queryAllDeviceSchedulingWithShowHUD:NO complete:nil];
                                         }];
                          
//                          [mgr2 closeTaskWithDeviceId:deviceId.longLongValue
//                                               taskId:curTaskId2.longLongValue
//                                             callback:^(NSError *error) {
//
//                                                 if (error == nil) {
//                                                     [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_show_closedingtimesuccess_text")];
//                                                 }
//                                                 [ws queryAllDeviceSchedulingWithShowHUD:NO complete:nil];
//                                             }];
                      } else {
                          [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_show_operatorfailed_text")];
                      }
                  }];
//    [mgr closeTaskWithDeviceId:deviceId.longLongValue
//                        taskId:curTaskId.longLongValue
//                      callback:^(NSError *error) {
//
//                          if (error == nil) {
//
//                              NSString * curTaskId2 = tasks[1];
//
//                              ACTimerManager * mgr2 = [[ACTimerManager alloc]init];
//
//                              [mgr2 closeTaskWithDeviceId:deviceId.longLongValue
//                                                   taskId:curTaskId2.longLongValue
//                                                 callback:^(NSError *error) {
//
//                                                     if (error == nil) {
//                                                         [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_show_closedingtimesuccess_text")];
//                                                     }
//                                                     [ws queryAllDeviceSchedulingWithShowHUD:NO complete:nil];
//                                                 }];
//                          } else {
//                              [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_show_operatorfailed_text")];
//                          }
//                      }];
}

#pragma mark - Private Methods
- (void)queryAllDeviceSchedulingWithShowHUD:(BOOL)isShowHUD complete:(void(^)())complete {
    if (!complete) {
        self.indexStr = nil;
        self.arr = nil;
        self.repeat = nil;
    }
    
    NSArray *deviceList = [AppDelegate sharedInstance].deviceList;
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (ACUserDevice *device in deviceList) {
        ACObject *obj = [[ACObject alloc] init];
        [obj putLongLong:@"deviceId" value:device.deviceId];
        [arrayM addObject:obj];
    }
    
    if (isShowHUD) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
        [SVProgressHUD show];
    }
    WEAKSELF(ws);
   
    [http_ requestWithMessageName:@"queryAllDeviceTimer" callback:^(ACMsg *responseObject, NSError *error) {
        
        ws.isAddAction = NO;
        
        if (error == nil) {
            NSDictionary * dict = [responseObject getObjectData];
            RHLog(@"%@", dict);
            // put start time and end time in an array. eg.@[@[start,end],@[start,end]]
            [self configStartAndEndTimeArrayWithDictionary:dict];
            
            // config scheduling dictionary
            [self configSchedulingArray];
            
            // remove overdue task
            [ws removeOverdueScheduling];
            if (complete) {
                complete();
            } else {
                [ws loadWebView];
                if (isShowHUD) {
                    [SVProgressHUD dismiss];
                }
            }
        } else {
            [ZSVProgressHUD showSimpleText:TIPS_NODATA];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ws.navigationController popViewControllerAnimated:YES];
            });
        }
    } andKeyValues:@"deviceList", arrayM, nil];
}

- (void)configStartAndEndTimeArrayWithDictionary:(NSDictionary *)dictionary {
    NSArray *array = [dictionary objectForKey:@"actionData"];
    NSArray *items = [RHTimerItem initWithArray:array];
    array = items;
    
    [self.schedulingInfoArray removeAllObjects];
    for (NSInteger i = 0; i < array.count; i++) {
        RHTimerItem *aItem = array[i];
        for (NSInteger j = i + 1; j < array.count; j++) {
            RHTimerItem *bItem = array[j];
            
            if ([aItem.timeStamp isEqualToString:bItem.timeStamp] && aItem.timeStamp.length > 0) {
                NSMutableArray * small = [[NSMutableArray alloc] init];
                // description = "1:1525239534000:98:Auto day"
                NSArray * arr1 = [aItem.mDescription componentsSeparatedByString:@":"];
                NSArray * arr2 = [bItem.mDescription componentsSeparatedByString:@":"];
                
                //表示开始timer和结束timer
                NSString * ultimate1 = @"";
                NSString * ultimate2 = @"";
                if (arr1.count == 4) {
                    ultimate1 = arr1[0];
                }
                if (arr2.count == 4) {
                    ultimate2 = arr2[0];
                }
                if (([ultimate1 isEqualToString:@"1"] && [ultimate2 isEqualToString:@"0"])) {
                    [small addObject:bItem];
                    [small addObject:aItem];
                }
                if (([ultimate1 isEqualToString:@"0"] && [ultimate2 isEqualToString:@"1"])) {
                    [small addObject:aItem];
                    [small addObject:bItem];
                }
                [self.schedulingInfoArray addObject:small];
                break;
            }
        }
    }
}

- (void)configSchedulingArray {
    NSMutableArray *arrayM = [NSMutableArray array];
    NSArray *deviceList = [AppDelegate sharedInstance].deviceList;
    
    for (NSArray *arr in self.schedulingInfoArray) {
        
        if (arr.count < 2) {
            continue;
        }
        RHTimerItem * item01 = arr[0];
        
        RHTimerItem * item02 = arr[1];
        
        // ||运算
        if (item01.status + item02.status == 0) {
            item01.status = 0;
        } else {
            item01.status = 1;
        }
        
        NSMutableDictionary * dic = [item01 mj_keyValues];
        [dic removeObjectForKey:@"timeStamp"];
        [dic removeObjectForKey:@"isTop"];
        NSString * taskId = [item01.taskId stringByAppendingFormat:@"_%@", item02.taskId];
        [dic setObject:taskId forKey:@"taskId"];
        
        NSString *start = item01.timePoint;
        NSString *end = item02.timePoint;
        NSString *mStart = [start TimeStamp:item01.timePoint format:@"yyyy-MM-dd HH:mm:ss" timeOffset:0];
        NSString *mEnd = [end TimeStamp:item02.timePoint format:@"yyyy-MM-dd HH:mm:ss" timeOffset:0];
        
        [dic setObject:start forKey:@"intTimePoint"];
        [dic setObject:end forKey:@"intEndTime"];
        start = [start TimeStamp:item01.timePoint timeOffset:0];
        end = [end TimeStamp:item02.timePoint timeOffset:0];
        [dic setObject:start forKey:@"timePoint"];
        [dic setObject:end forKey:@"endTime"];
        [dic setObject:mStart forKey:@"mTimePoint"];
        [dic setObject:mEnd forKey:@"mEndTime"];
        
        [dic setObject:item01.timePoint forKey:@"paixvId"];
        for (ACUserDevice *device in deviceList){
            
            if (item01.deviceId == device.deviceId) {
                item01.name = device.deviceName;
            }
        }
        dic[@"deviceName"] = item01.name;
        dic[@"name"] = item01.name;
        [arrayM addObject:dic];
    }
    [self.schedulingInfoArray removeAllObjects];
    [self.schedulingInfoArray addObjectsFromArray:arrayM];
}

- (void)removeOverdueScheduling {
    WEAKSELF(weakself);
    NSMutableArray *removeArr = [[NSMutableArray alloc]init];
    for (NSDictionary *tempDictionary in self.schedulingInfoArray) {
        
        NSString *mEndTime = tempDictionary[@"mEndTime"];
        NSString *repeat = tempDictionary[@"timeCycle"];
        
        if ([repeat isEqualToString:@"once"]) {
            
            NSTimeInterval endTimeInt = [mEndTime longlongFromDate];
            NSTimeInterval currentTimeInt = [NSDate getCurrentTimeStamp].longLongValue / 1000.0;
            NSString *taskId = tempDictionary[@"taskId"];
            if (currentTimeInt > endTimeInt) {
                RHLog(@"不能设置更早时间");
                [removeArr addObject:tempDictionary];
                NSArray *tasks = [taskId componentsSeparatedByString:@"_"];
                
                for (NSString *tid in tasks) {
                    NSInteger mDeviceId = [tempDictionary[@"deviceId"] integerValue];
//                    ACTimerManager * mgr = [[ACTimerManager alloc] init];
                    ACDeviceTimerManager *timeManager = [[ACDeviceTimerManager alloc] initWithDeviceId:mDeviceId];
                    [timeManager deleteTask:[NSString stringWithFormat:@"%lli",tid.longLongValue]
                                   callback:^(NSError *error) {
                                       weakself.isAddAction = NO;
                                       if (error == nil) {
                                           RHLog(@"删除过期once定时成功");
                                           
                                       } else {
                                           RHLog(@"删除过期once定时失败");
                                       }
                                   }];
//                    [mgr deleteTaskWithDeviceId:mDeviceId
//                                         taskId:tid.longLongValue
//                                       callback:^(NSError *error) {
//                                           weakself.isAddAction = NO;
//                                           if (error == nil) {
//                                               RHLog(@"删除过期once定时成功");
//
//                                           } else {
//                                               RHLog(@"删除过期once定时失败");
//                                           }
//                                       }];
                }
            }
        }
    }
    [self.schedulingInfoArray removeObjectsInArray:removeArr];
}

- (void)loadWebView {
    NSURL *url = [self nameWithUrl:@"appointment-list"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)modifyWithNotification:(NSNotification *)notify {
    
    
    ACTimerManager *mgr = [[ACTimerManager alloc] init];
    
    NSDictionary *dict = notify.object;
    
    NSDictionary *temp = nil;
    for (NSDictionary *dic in self.schedulingInfoArray) {
        
        NSString * taskId = [self.arr lastObject];
        NSString * taskIdStr = [NSString stringWithFormat:@"%@", dic[@"taskId"]];
        if ([taskId isEqualToString:taskIdStr]) {
            temp = dic;
            break;
        }
    }
    
    if (temp == nil) {
        [ZSVProgressHUD showSimpleText:TIPS_FAILED];
        [self queryAllDeviceSchedulingWithShowHUD:YES complete:nil];
        return;
    }
    
    NSString *taskIdStr = temp[@"taskId"];
    NSArray *tasks = [taskIdStr componentsSeparatedByString:@"_"];
    
    long long deviceId = [temp[@"deviceId"] longLongValue];
    NSInteger modelState = [dict[@"model"] integerValue];
    NSInteger taskId1 = [tasks[0] integerValue];
    NSInteger taskId2 = [tasks[1] integerValue];
    NSString *deviceName = temp[@"deviceName"];
    NSString *timePoint = dict[@"timePoint"];
    NSString *endTime = dict[@"endTime"];
    
    NSMutableArray *mArray = [NSMutableArray array];
    [mArray addObject:@(deviceId)];
    [mArray addObject:deviceName];
    [mArray addObject:@(modelState)];
    [mArray addObject:timePoint];
    [mArray addObject:endTime];
    
    if (self.repeat == nil) {
        self.repeat = @"once";
    }
    [self.schedulingModelArray removeAllObjects];
    [self.schedulingModelArray addObjectsFromArray:[RHTimerItem initWithArray:self.schedulingInfoArray]];
    
    BOOL canAdd = YES;
    RHTimerItem * aItem = [[RHTimerItem alloc]init];
    aItem.mTimePoint = timePoint;
    aItem.mEndTime = endTime;
    aItem.timeCycle = self.repeat;
    
    for (RHTimerItem * item in self.schedulingModelArray) {
        
        if ([item.taskId isEqualToString:taskIdStr]) {
            continue;
        }
        
        if (item.deviceId != deviceId) {
            continue;
        }
        canAdd = [item checkWithItem:aItem];
        if (canAdd == NO) {
            break;
        }
        
    }
    if (canAdd == NO) {
        [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_show_appointmenttimeoverlap_text")];
        self.isAddAction = NO;
        return;
    }

    
    NSString *timeCycle = self.repeat;
    NSString *timeSp = [NSDate getCurrentTimeStamp];

//    NSString *descriptor01 = [NSString stringWithFormat:@"0:%@:%lld:%@", timeSp, deviceId, self.mode2Array[modelState]];
//    NSString *descriptor02 = [NSString stringWithFormat:@"1:%@:%lld:%@", timeSp, deviceId, self.mode2Array[modelState]];
//    msg.describe = descriptor01;
    
    ACDeviceMsg *msg = [self setAddSchedulingDeviceMsgWithIndex:0 timeStamp:timeSp modelState:modelState notificationArray:mArray];
    //做判断是否能添加
    WEAKSELF(ws);
    [mgr modifyTaskWithDeviceId:deviceId
                         taskId:taskId1
                           name:deviceName
                      timePoint:timePoint
                      timeCycle:timeCycle
                      deviceMsg:msg
                       callback:^(NSError *error) {
        
                           ws.isAddAction = NO;
        
                           if (error == nil) {
            
//                               Byte command2[] = {(Byte)0xFF,(Byte)0xFF ,0x00, 0x10 ,0x03 ,0x00 ,0x00, 0x00, 0x01, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00 ,0x00 ,0x00, 0x00, 0x18};
//                               NSData * data2 = [NSData dataWithBytes:command2 length:sizeof(command2)];
//                               ACDeviceMsg * msg2 = [[ACDeviceMsg alloc] init];
//                               msg2.payload = data2;
//                               msg2.describe = descriptor02;
//                               msg2.msgCode=66;
                               
                               ACDeviceMsg *msg2 = [self setAddSchedulingDeviceMsgWithIndex:1 timeStamp:timeSp modelState:modelState notificationArray:mArray];
                               ACTimerManager *mgr2 = [[ACTimerManager alloc] init];
            
                               [mgr2 modifyTaskWithDeviceId:deviceId
                                                     taskId:taskId2
                                                       name:deviceName
                                                  timePoint:endTime
                                                  timeCycle:ws.repeat
                                                  deviceMsg:msg2
                                                   callback:^(NSError *err) {
                                                       if (err == nil) {
                                                           [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_show_verifydingtimesuccess_text")];
                                                           [ws queryAllDeviceSchedulingWithShowHUD:YES complete:nil];
                                                       }
                                                   }];
                           }
                       }];

}

- (void)addTaskWithNotification:(NSNotification *)notification {
    //    @[str_deviceId, name, timePoint, endTime]
    NSArray * arr = notification.object;

//    ACTimerManager * mgr = [[ACTimerManager alloc] init];
    long long deviceId = [arr[0] longLongValue];
    NSString * name = arr[1];
    NSInteger modelState = [arr[2] integerValue];
    NSString * start = arr[3];
    NSString * end = arr[4];
    if (self.repeat == nil) {
        self.repeat = @"once";
    }
    
    if (![self checkSchedulingCanAddedWithStartTime:start endTime:end deviceID:deviceId]) {
        [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_show_appointmenttimeoverlap_text")];
        self.isAddAction = NO;
        return;
    }
    NSString *timeSp = [NSDate getCurrentTimeStamp];
    ACDeviceMsg *deviceMsg = [self setAddSchedulingDeviceMsgWithIndex:0 timeStamp:timeSp modelState:modelState notificationArray:arr];
  
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD show];
    
    WEAKSELF(ws);
    ACTimerManager * timerManager = [[ACTimerManager alloc] init];
    [timerManager addTaskWithDeviceId:deviceId
                                 name:name
                            timePoint:start
                            timeCycle:self.repeat
                            deviceMsg:deviceMsg
                               OnType:0
                             callback:^(NSError *error) {
        
                                 if (error) {
                                     [ZSVProgressHUD showErrorWithStatus:TIPS_REQUEST_ERROR];
                                     ws.isAddAction = NO;
                                 } else {
                                     ACDeviceMsg *secondDeviceMsg = [self setAddSchedulingDeviceMsgWithIndex:1 timeStamp:timeSp modelState:modelState notificationArray:arr];
                                     ACTimerManager * mgr2 = [[ACTimerManager alloc] init];
                                     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
                                     [SVProgressHUD show];
            
                                     [mgr2 addTaskWithDeviceId:deviceId
                                                          name:name
                                                     timePoint:end
                                                     timeCycle:ws.repeat
                                                     deviceMsg:secondDeviceMsg
                                                        OnType:0
                                                      callback:^(NSError *error) {
                                                          ws.isAddAction = NO;
                
                                                          if (error) {
                                                              [ZSVProgressHUD showErrorWithStatus:TIPS_REQUEST_ERROR];
                                                          } else {
                                                              [ZSVProgressHUD showSimpleText:GetLocalResStr(@"airpurifier_more_show_adddingtimesuccess_text")];
                                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                  [ws queryAllDeviceSchedulingWithShowHUD:YES complete:nil];
                                                              });
                                                          }
                                                      }];
                                 }
                             }];

}

- (BOOL)checkSchedulingCanAddedWithStartTime:(NSString *)startTime endTime:(NSString *)endTime deviceID:(long long)deviceID {
    [self.schedulingModelArray removeAllObjects];
    [self.schedulingModelArray addObjectsFromArray:[RHTimerItem initWithArray:self.schedulingInfoArray]];

    BOOL canAdd = YES;

    RHTimerItem * aItem = [[RHTimerItem alloc]init];
    aItem.mTimePoint = startTime;
    aItem.mEndTime = endTime;
    aItem.timeCycle = self.repeat;

    for (RHTimerItem * item in self.schedulingModelArray) {
        if (item.deviceId != deviceID) {
            continue;
        }
        canAdd = [item checkWithItem:aItem];
        if (canAdd == NO) {
            break;
        }
    }
    return canAdd;
}

- (ACDeviceMsg *)setAddSchedulingDeviceMsgWithIndex:(NSInteger)index timeStamp:(NSString *)timeStamp modelState:(NSInteger)modelState notificationArray:(NSArray *)array {
    NSData *byteData = nil;
    if (index == 0) {
        long long model;
        long long model2;
        long long model3;
        
        if (modelState == 0) {
            model = 0x00;
            model2 = 0x04;
            model3 = 0x19;
        } else if (modelState == 1) {
            model = 0x01;
            model2 = 0x0c;
            model3 = 0x22;
        } else if (modelState == 2) {
            model = 0x02;
            model2 = 0x0c;
            model3 = 0x23;
        } else if (modelState == 3) {
            model = 0x03;
            model2 = 0x0c;
            model3 = 0x24;
        } else {
            model = 0x04;
            model2 = 0x0c;
            model3 = 0x25;
        }
        
        Byte byte[] = {(Byte)0xff, (Byte)0xff, (Byte)0x00, (Byte)0x10, (Byte)0x03,
            (Byte)0x00, (Byte)0x00, (Byte)0x00, (Byte)0x01, (Byte)0x00, model2, (Byte)0x01, model, (Byte)0x00, (Byte)0x00, (Byte)0x00, (Byte)0x00, (Byte)0x00, (Byte)0x00, model3};
        byteData = [NSData dataWithBytes:byte length:sizeof(byte)];
    } else if (index == 1) {
        Byte command2[] = {(Byte)0xff, (Byte)0xff, (Byte)0x00, (Byte)0x10, (Byte)0x03, (Byte)0x00, (Byte)0x00, (Byte)0x00, (Byte)0x01, (Byte)0x00, (Byte)0x04, (Byte)0x00, (Byte)0x00, (Byte)0x00, (Byte)0x00, (Byte)0x00, (Byte)0x00, (Byte)0x00, (Byte)0x00, (Byte)0x18};
        
        byteData = [NSData dataWithBytes:command2 length:sizeof(command2)];
    }
    
    
    // silent 1 boost 4 auto day 3 auto night 2
    NSString *descriptor = [NSString stringWithFormat:@"%ld:%@:%@:%@", (long)index, timeStamp, array[0], self.mode2Array[modelState]];
    ACDeviceMsg *msg = [[ACDeviceMsg alloc] init];
    msg.describe = descriptor;
    msg.payload = byteData;
    msg.msgCode = 66;
    return msg;

}

#pragma mark - UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_myorder_text");
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSTimerModel *model  = [[JSTimerModel alloc] init];
    self.jsContext[@"timer"] = model;
    model.jsContext = self.jsContext;
    model.webView = self.webView;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        RHLog(@"exception message：%@", exceptionValue);
    };
    NSString * strUrl = self.webView.request.URL.absoluteString;

    [self.webView stringByEvaluatingJavaScriptFromString:self.jsString];
    
    //如果是列表页面
    if ([strUrl containsString:@"appointment-list"]) {
        
        if (self.lastControllerType == SchedulingFromMore) {
            
            [self setSchedulingListNavItem];
            NSString * js = [NSString stringWithFormat:@"setValueIos('%@')", self.schedulingInfoArray.mj_JSONString];
             [self.webView stringByEvaluatingJavaScriptFromString:js];
            [self setSchedulingListNavItem];
            
        } else {
        
            NSString * devStr = [NSString stringWithFormat:@"%lld", self.deviceId];
            NSMutableArray * arrM = [NSMutableArray array];
            for (NSDictionary * dict in self.schedulingInfoArray) {
                
                NSString * deviceIdStr = [NSString stringWithFormat:@"%@", dict[@"deviceId"]];
                if ([devStr isEqualToString:deviceIdStr]) {
                    [arrM addObject:dict];
                }
            }
            
            NSString * js = [NSString stringWithFormat:@"setValueIos('%@')", arrM.mj_JSONString];
             [self.webView stringByEvaluatingJavaScriptFromString:js];
            [self setSchedulingListNavItem];
        }
       
    }
    
      NSString * js = nil;
    //更改定时
    if ([self.indexStr isEqualToString:@"3"] && [strUrl containsString:@"appointment-item.html"]) {
        
        self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_editscheduling_tex");
        
        [self setAddSchedulingNavItem];
        
        NSString * taskIdStr = self.arr[3];
        NSDictionary * temp = nil;
        for (NSDictionary * dict in self.schedulingInfoArray) {
            
            NSString * taskId = [NSString stringWithFormat:@"%@",  dict[@"taskId"]];

            NSArray *arr = [dict[@"description"] componentsSeparatedByString:@":"];
            NSString *deviceMode = nil;
            /*
             GetLocalResStr(@"airpurifier_more_show_silentword_tex"), GetLocalResStr(@"airpurifier_more_show_autonight_tex"), GetLocalResStr(@"airpurifier_more_show_autoday_tex"), GetLocalResStr(@"airpurifier_more_show_boostword_tex")
             */
            if ([taskId isEqualToString:taskIdStr]) {
                temp = dict;
                NSString *str = [[arr lastObject] lowercaseString];
                if ([str isEqualToString:@"auto day"]) {
                    deviceMode = GetLocalResStr(@"airpurifier_more_show_autoday_tex");
                } else if ([str isEqualToString:@"auto night"]) {
                    
                    deviceMode = GetLocalResStr(@"airpurifier_more_show_autonight_tex");
                } else if ([str isEqualToString:@"boost"]) {
                    
                    deviceMode = GetLocalResStr(@"airpurifier_more_show_boostword_tex");
                }else if ([str isEqualToString:@"silent"]) {
                    
                    deviceMode = GetLocalResStr(@"airpurifier_more_show_silentword_tex");
                }
                [temp setValue:deviceMode forKey:@"devicMode"];
                
                break;
            }
        }
        
        js = [NSString  stringWithFormat:@"setValueIos('%@')", [@[temp] mj_JSONString]];
        NSString * ret = [self.webView stringByEvaluatingJavaScriptFromString:js];
        NSArray * deviceList = [AppDelegate sharedInstance].deviceList;
        
        NSDictionary * temp2 = nil;
        for (ACUserDevice * device in deviceList) {
            if (device.deviceId  == [self.arr[1] longLongValue]) {
                temp2 = @{@"deviceId" : @(device.deviceId), @"deviceName" : device.deviceName};
                break;
            }
        }
        
        js = [NSString stringWithFormat:@"setDevice('%@','%@', '%@')", @"0", temp2[@"deviceName"], self.indexStr];
        ret = [self.webView stringByEvaluatingJavaScriptFromString:js];
        
        if (ret) {
            self.repeat = temp[@"timeCycle"];
        }
    }
    
    //点上边右上角添加的
    if ([self.indexStr isEqualToString:@"2"] && [strUrl containsString:@"appointment-item.html"]) {
        
        self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_addscheduling_text");
        
        [self setAddSchedulingNavItem];
        
        NSArray * deviceList = [AppDelegate sharedInstance].deviceList;
        NSMutableArray * arrayM = [NSMutableArray array];
        for (ACUserDevice * device in deviceList) {
            NSDictionary * dict = @{@"deviceId" : @(device.deviceId), @"deviceName" : device.deviceName};
            [arrayM addObject:dict];
        }
        
        if (self.lastControllerType == SchedulingFromMore) {
            
            js = [NSString stringWithFormat:@" setDeviceIos('%@','%@', '%@')", @"1", arrayM.mj_JSONString , self.indexStr];
            NSString * ret = [self.webView stringByEvaluatingJavaScriptFromString:js];
            RHLog(@"ret = %@", ret);
            
        }else{
           
            js = [NSString stringWithFormat:@" setDevice('%@','%@', '%@')", @"0", self.deviceName, self.indexStr];
            NSString * ret = [self.webView stringByEvaluatingJavaScriptFromString:js];
            RHLog(@"ret = %@", ret);
            
            js = [NSString stringWithFormat:@" setDefault('%@','%@')", [NSString stringWithFormat:@"%lld", self.deviceId], self.deviceName];
            ret = [self.webView stringByEvaluatingJavaScriptFromString:js];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
}

#pragma mark - AppointmentDetailViewControllerDelegate
- (void)week:(NSString *)week repeat:(NSString *)repeat {
    NSString *tempString;
    self.week = week;
    if ([self.week isEqualToString:@"Once"]) {
        tempString = GetLocalResStr(@"airpurifier_more_show_onceword_tex");
    } else {
        tempString = self.week;
    }
    self.repeat = repeat;
    NSString * js = [NSString stringWithFormat:@"set_repeat('%@')", tempString];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    [self setAddSchedulingNavItem];
}

#pragma mark - Lazyload Method
- (NSMutableArray *)schedulingModelArray {
    if (_schedulingModelArray == nil) {
        _schedulingModelArray = [[NSMutableArray alloc] init];
    }
    return _schedulingModelArray;
}

- (NSMutableArray *)schedulingInfoArray {
    if (_schedulingInfoArray == nil) {
        _schedulingInfoArray = [[NSMutableArray alloc] init];
    }
    return _schedulingInfoArray;
}

- (NSArray *)modeArray {
    if (!_modeArray) {
        _modeArray = @[@"null" ,
                       GetLocalResStr(@"airpurifier_more_show_silentword_tex"), GetLocalResStr(@"airpurifier_more_show_autonight_tex"), GetLocalResStr(@"airpurifier_more_show_autoday_tex"), GetLocalResStr(@"airpurifier_more_show_boostword_tex")];
    }
    return _modeArray;
}

- (NSArray *)mode2Array {
    if (!_mode2Array) {
        _mode2Array = @[@"null" ,@"silent", @"auto night",@"auto day",@"boost"];
    }
    return _mode2Array;
}


- (NSString *)jsString {
    if (_jsString == nil) {
        _jsString = [NSString stringWithFormat:@"setLabelIos('{\"no_device\":\"%@\", \"add_scheduling\":\"%@\", \"delete_word\":\"%@\", \"sure_to_delete\":\"%@\", \"ok_word\":\"%@\", \"cancel_word\":\"%@\", \"save_word\":\"%@\", \"sunday_word\":\"%@\", \"monday_word\":\"%@\", \"thesday_word\":\"%@\", \"wednesday_word\":\"%@\", \"thursday_word\":\"%@\", \"firday_word\":\"%@\", \"saturday_word\":\"%@\", \"my_scheduling\":\"%@\", \"edit_scheduling\":\"%@\", \"delete_scheduling\":\"%@\", \"repeat_setting\":\"%@\", \"sun_word\":\"%@\", \"mon_word\":\"%@\", \"tues_word\":\"%@\", \"wed_word\":\"%@\", \"thur_word\":\"%@\", \"fri_word\":\"%@\", \"sat_word\":\"%@\", \"choose_device\":\"%@\", \"choose_mode\":\"%@\", \"on_time\":\"%@\", \"off_time\":\"%@\", \"repeat_word\":\"%@\", \"device_name\":\"%@\", \"device_mode\":\"%@\", \"auto_day\":\"%@\", \"auto_night\":\"%@\", \"boost_word\":\"%@\", \"silent_word\":\"%@\", \"once_word\":\"%@\", \"time_warning\":\"%@\", \"delete_scheduling\":\"%@\"}')",
                     [GetLocalResStr(@"airpurifier_more_show_noscheduling_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_addscheduling_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_deleteword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_suretodelete_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_public_ok") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_public_cancel") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_saveword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_sundayword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_mondayword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_tuesdayword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_wednesdayword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_thursdayword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_fridayword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_saturdayword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_myscheduling_tex") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_editscheduling_tex") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_deletescheduling_tex") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_repeatsetting_tex") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_sunword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_monword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_tuesword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_wedword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_thurword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_friword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_satword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_choosedevice_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_choosemode_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_ontime_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_offtime_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_repeatword_text") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_devicename_tex") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_devicemode_tex") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_autoday_tex") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_autonight_tex") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_boostword_tex") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_silentword_tex") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_onceword_tex") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_add_shchedule_tip") stringByReplacingOccurrencesOfString:@"\'" withString:@" "],
                     [GetLocalResStr(@"airpurifier_more_show_deletescheduling_tex") stringByReplacingOccurrencesOfString:@"\'" withString:@" "]]
        ;
    }
    return _jsString;
}

@end
