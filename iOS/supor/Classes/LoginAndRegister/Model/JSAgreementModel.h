//
//  JSAgreementModel.h
//  supor
//
//  Created by 赵冰冰 on 16/6/30.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "JSBaseModel.h"

@protocol  JSAgreementModelDelegate <JSExport>

-(void)agree;

@end

@interface JSAgreementModel : JSBaseModel<JSAgreementModelDelegate>

@end
