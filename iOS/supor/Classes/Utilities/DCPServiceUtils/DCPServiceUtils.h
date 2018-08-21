//
//  DCPServiceUtils.h
//  supor
//
//  Created by fariel huang on 2017/4/18.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const DCPServiceParamTokenName;

/**
 * dcp content type
 */
typedef NS_ENUM(NSInteger, DCPServiceContentType) {
    DCPServiceContentTypeTermOfUse,
    DCPServiceContentTypeLegalNotice,
    DCPServiceContentAfterSales,
    DCPServiceContentCookies,
    DCPServiceContentPersonalData,
    DCPServiceContentManual,
    DCPServiceContentAppliances,
    DCPServiceContentLibraries,
    DCPServiceContentApplianceShop,
};

@interface DCPServiceUtils : NSObject

/**
 * 登录
 */
+ (void)loginWithName:(NSString *)loginName
             password:(NSString *)password
             callback:(void(^)(ACUserInfo *userInfo, NSError *error))callback;

/**
 * 注册
 */
+ (void)registerWithNickName:(NSString *)nickName
                       email:(NSString *)email
                    password:(NSString *)password
                  verifyCode:(NSString *)verifyCode
                    callback:(void(^)(ACUserInfo *user, NSError *error))callback;

/**
 * 重置密码
 */
+ (void)resetPasswordWithAccount:(NSString *)account
                        callback:(void(^)(BOOL success, NSError *error))callback;

/**
 * 修改密码
 */
+ (void)updatePasswordWithAccount:(NSString *)account
                         password:(NSString *)password
                         callback:(void(^)(ACUserInfo *user, NSError *error))callback;

/**
 * 修改nickName
 */
+ (void)changeNickName:(NSString *)nickName callback:(void(^)(NSError *error))callback;

+ (NSString *)getDcpToken;

/**
 * 设置dcp服务token失效回调
 * @discussion 所有uds请求的dcpToken有效性check都在uds做的，
 平台的请求的check在客户端通过uds的checkToken接口进行check后再发起
 */
+ (void)setDCPTokenInvalidCallback:(void(^)())callback;

/**
 * 同步dcp内容部分信息
 */
+ (void)syncContent:(DCPServiceContentType)type
           callback:(void(^)(ACMsg *responseMsg, NSError *error))callback;

/**
 * 设置 syncContent 的语言 如： @"fr" @"en"
 */
+ (void)setLanguage:(NSString *)language;


/**
 * 设置市场 如： @"GS_FR"
 */
+ (void)setMarket:(NSString *)market;

+ (NSString *)getDcpUid;

+ (void)sendToDCPService:(ACMsg *)msg callback:(void(^)(ACMsg *responseMsg, NSError *error))callback;

+ (NSString *)getMarket;

+ (NSString *)getLanguage;

@end
