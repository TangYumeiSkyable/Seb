//
//  JSMessageListModel.h
//  supor
//
//  Created by 赵冰冰 on 16/6/30.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "JSBaseModel.h"

@protocol JSMessageListModelDelegate <JSExport>

-(void)setReadFlg:(NSString *)msg;
-(void)getMessage:(NSString *)msg;
-(void)openAirCleaner:(NSString *)msg;
-(void)toSupor;

@end

@interface JSMessageListModel : JSBaseModel<JSMessageListModelDelegate>

@end
