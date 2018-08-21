//
//  Public.h
//  millHeater
//
//  Created by 赵冰冰 on 16/5/3.
//  Copyright © 2016年 colin. All rights reserved.
//

#define TIPS_QUERYING @"   ...   " //
#define TIPS_REQUEST_ERROR GetLocalResStr(@"airpurifier_public_fail")
#define TIPS_REQUEST_SUCCESS GetLocalResStr(@"airpurifier_public_success")
#define TIPS_REQUEST_FAIL GetLocalResStr(@"airpurifier_public_fail")
#define TIPS_SUCCESS GetLocalResStr(@"airpurifier_public_success")
#define TIPS_FAILED GetLocalResStr(@"airpurifier_public_fail")
#define TIPS_FAILED_CONTROL GetLocalResStr(@"airpurifier_moredevice_show_controlfailed_text")
#define TIPS_NODATA GetLocalResStr(@"airpurifier_public_nodata")


#define UD_WIFILIKN @"wifilink"
#define UD_FIRST_OPEN @"firstOpen"
#define UD_FIRST_SHOW_NOTIFI_ALERT @"frist_show_noti_alert"
#define DEVICE_PHYID @"device_phy_id"


#define NOTIFY_OCCHANGE_CITY                  @"ocnotify_change_city"
#define NOTIFY_CHANGE_CITY                    @"notify_change_city"
#define NOTIFY_REPEAT                         @"repeat"
#define NOTIFY_RETURN_REPEAT                  @"returnRepeat"
#define NOTIFY_MODIFY_SAVED                   @"modifySaved"
#define NOTIFY_SHOW_TOAST                     @"showtoast"
#define NOTIFY_AGREEMENT                      @"agreement"
#define NOTIFY_SETREADFLAG                    @"set_read_flag"
#define NOTIFY_SHOUHOU                        @"shoushoufuwu"
#define NOTIFY_GETLOACTION                    @"getloaction"
#define NOTIFY_OPEN_AIR                       @"open_air"
#define NOTIFY_DELETE_APPOINT                 @"delete_appoint"
#define NOTIFY_ADD_APPOINT                    @"add_appoint"
#define NOTIFY_MODIFY_APPOINT                 @"modify_appointment"
#define NOTIFY_SET_TIME                       @"set_returnRepeat"
#define NOTIFY_ADDTASK                        @"addtask"
#define NOTIFY_MODIFY_TASK                    @"modify_task"
#define NOTIFY_OPEN_TASK                      @"open_task"
#define NOTIFY_CLOSE_TASK                     @"close_task"
#define NOTIFY_MESSAGE_ADVISER                @"message_adviser"
#define NOTIFY_PERSON_SELECTTIMER             @"person_selecttime"
#define NOTIFY_PERSON_CANCELTIMER             @"person_canceltime"
#define NOTIFY_GOTOSUPOR                      @"goto_supor"
#define NOTIFY_LOCATION                       @"notify_location"


#define RHBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

#ifdef DEBUG
#define MSGSHOW(text)   [ZSVProgressHUD showSimpleText:([NSString stringWithFormat:@"[func is %s]\n ++++ [line is %d]\n %@", __FUNCTION__, __LINE__, text])];
#else
#define MSGSHOW(text)   [ZSVProgressHUD showSimpleText:(text)];
#endif

#define BTN_ADDTARGET(btn, selector) \
[btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside]

#define BTN_HEIGHT 46
#define RATIO(a)  (((a) * [UIScreen mainScreen].bounds.size.width) / 1080.0)
