//
//  JSBaseModel.h
//  supor
//
//  Created by 赵冰冰 on 16/6/29.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface JSBaseModel : NSObject

@property (nonatomic, weak) JSContext * jsContext;
@property (nonatomic, weak) UIWebView * webView;

-(void)sendMessage:(NSString *)sendMessage withObject:(id)obj;

-(void)sendMessage:(NSString *)sendMessage withObjectArray:(NSArray *)array;

-(void)sendMessage:(NSString *)sendMessage withObjectDict:(NSDictionary *)dict;

@end
