//
//  JSGotoSuporModel.h
//  supor
//
//  Created by 赵冰冰 on 16/9/2.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "JSBaseModel.h"

@protocol JSGotoSuporDelegate <JSExport>

-(void)toSupor:(int)value;

@end

@interface JSGotoSuporModel : JSBaseModel<JSGotoSuporDelegate>

@end
