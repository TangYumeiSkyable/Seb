//
//  JSShouhouModel.m
//  supor
//
//  Created by 赵冰冰 on 16/6/30.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "JSShouhouModel.h"

@implementation JSShouhouModel

-(void)getLocation {
    [self sendMessage:NOTIFY_GETLOACTION withObject:nil];
}

-(void)call:(NSString *)call {
    [self sendMessage:NOTIFY_SHOUHOU withObject:call];
}
@end
