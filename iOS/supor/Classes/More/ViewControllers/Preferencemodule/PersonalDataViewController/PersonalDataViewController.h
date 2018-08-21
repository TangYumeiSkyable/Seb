//
//  PersonalDataViewController.h
//  supor
//
//  Created by 白云杰 on 2017/5/22.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PersonalRequestType) {
    PersonalRequestDataType = 0,
    PersonalRequestLegalNoticeType = 1,
    PersonalRequestTermOfUseType = 3
};


@interface PersonalDataViewController : UIViewController

@property (nonatomic, assign) NSInteger fromNumber;

@property (nonatomic, assign) PersonalRequestType requestType;

@end
