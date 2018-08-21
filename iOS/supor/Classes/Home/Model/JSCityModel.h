//
//  JSCityModel.h
//  supor
//
//  Created by 赵冰冰 on 16/6/23.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSCityModelDelegate <JSExport>

- (void)cityChange:(NSString *)para;
- (void)locCityChange;

@end

@interface JSCityModel : NSObject<JSCityModelDelegate>

@property (nonatomic, weak) JSContext * jsContext;
@property (nonatomic, weak) UIWebView * webView;

@end
