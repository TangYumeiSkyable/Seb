//
//  JSAgreementModel.m
//  supor
//
//  Created by 赵冰冰 on 16/6/30.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "JSAgreementModel.h"

@implementation JSAgreementModel

- (void)agree {
    [self sendMessage:NOTIFY_AGREEMENT withObject:nil];
}

@end
