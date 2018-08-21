//
//  JSShouhouModel.h
//  supor
//
//  Created by 赵冰冰 on 16/6/30.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "JSBaseModel.h"

@protocol JSShouhouModelDelegate <JSExport>

-(void)call:(NSString *)call;
-(void)getLocation;

@end

@interface JSShouhouModel : JSBaseModel<JSShouhouModelDelegate>

@end
