//
//  BLInnerResult.h
//  Let
//
//  Created by zhujunjie on 2017/9/8.
//  Copyright © 2017年 BroadLink Co., Ltd. All rights reserved.
//

#import <BLLetBase/BLLetBase.h>

@interface BLInnerResult : BLBaseResult

@property (nonatomic, copy) NSDictionary *info;

- (NSString *)getResultString;

@end
