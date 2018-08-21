//
//  DCPServiceUtils.m
//  supor
//
//  Created by fariel huang on 2017/4/18.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "DCPServiceUtils.h"
#import "ACloudLib.h"
#import "ACUserInfo.h"
#import "ACKeyChain.h"
#import "ACObject.h"
#import <objc/runtime.h>

typedef void(* _SERVICEIMP) (id target, id noUse, ACMsg *msg, id callback); //sendToService 实现

NSString *const DCPServiceParamTokenName = @"dcpToken"; //dcp token参数名
static NSString *const kDCPServiceDCPTokenName = @"kDCPServiceDCPTokenName"; //存储dcp token的key
NSString *const DCPServiceParamUidName = @"dcpUid"; //dcp uid参数名
static NSString *const kDCPServiceDCPUidName = @"kDCPServiceDCPUidName"; //存储dcp uid的key
NSString *const DCPServiceParamMarketName = @"dcpMarket"; //dcp market参数名
static NSString *const kDCPServiceDCPMarketName = @"kDCPServiceDCPMarketName"; //存储market的key
static NSString *const kDCPServiceDCPLanguageName = @"kDCPServiceDCPLanguageName"; //存储language的key

static void(^DCPTokenInvalidCallback)(); //dcp服务token失效回调

static NSString *const kDCPServicePathBase = @"dcp-"; //dcp相关uds service前缀
static NSString *const kDCPServicePathLogin = @"login"; //登陆kDCPServiceDCPMarketName
static NSString *const kDCPServicePathResetPassword = @"resetPassword"; //重置密码
static NSString *const kDCPServicePathUpdatePassword = @"updatePassword"; //修改密码
static NSString *const kDCPServicePathRegister = @"register"; //注册
static NSString *const kDCPServicePathGetProfile = @"getProfile"; //获取用户拓展信息
static NSString *const kDCPServicePathUpdateProfile = @"updateProfile"; //更新nickName
static NSString *const kDCPServicePathCheckToken = @"checkToken"; //检查token有效性
static NSString *const kDCPServicePathLogout = @"logout"; //注销
static NSString *const kDCPServicePathSyncContent = @"syncContent"; //同步content信息
static const NSInteger kDCPServiceTokenInvalidCode = 8888; //dcp token失效错误码

static inline NSString * msgName(NSString *path) {
    return [NSString stringWithFormat:@"%@%@", kDCPServicePathBase, path];
}

@implementation DCPServiceUtils

+ (void)load {
    [super load];
    //增加注销操作处理
    Class accoutClass = [ACAccountManager class];
    SEL logout = @selector(logout);
    IMP logoutIMP = method_getImplementation(class_getClassMethod(accoutClass,
                                                                  logout));
    class_replaceMethod(object_getClass((id)accoutClass),
                        logout,
                        imp_implementationWithBlock(^() {
        logoutIMP();
        [self saveDcpToken:nil uid:nil];
        [self logoutDCP];
    }),
                        nil);
    //增加请求前的dcpToken检查
    Class serviceClass = [ACServiceClient class];
    SEL sendToService = @selector(sendToService:callback:);
    _SERVICEIMP serviceIMP = (_SERVICEIMP)method_getImplementation(class_getInstanceMethod(serviceClass,
                                                                                           sendToService));
    class_replaceMethod(serviceClass,
                        sendToService,
                        imp_implementationWithBlock(^(ACServiceClient *target, ACMsg *msg, void(^callback)(ACMsg *responseObject, NSError *error)) {
        if ([target.service rangeOfString:@"zc-"].location != NSNotFound) {
//            [self checkToken:^(BOOL valid) {
//                if (valid) {
//                    serviceIMP(target, nil, msg, callback);
//                } else if (DCPTokenInvalidCallback) {
//                    DCPTokenInvalidCallback();
//                }
//            }];
            serviceIMP(target, nil, msg, callback);
        } else {
            [msg put:DCPServiceParamTokenName value:[self getDcpToken]];
            [msg put:DCPServiceParamUidName value:[self getDcpUid]];
            [msg put:DCPServiceParamMarketName value:[self getMarket]];
            id respBlock = ^(ACMsg *responseMsg, NSError *error) {
                if (error.code == kDCPServiceTokenInvalidCode && DCPTokenInvalidCallback) {
                    DCPTokenInvalidCallback();
                }
                if (callback) {
                    callback(responseMsg, error);
                }
            };
            serviceIMP(target, nil, msg, respBlock);
        }
    }),
                        nil);
}

#pragma mark - account 部分
+ (void)loginWithName:(NSString *)loginName
             password:(NSString *)password
             callback:(void(^)(ACUserInfo *userInfo, NSError *error))callback {
    ACMsg *msg = [ACMsg msgWithName:msgName(kDCPServicePathLogin)];
    [msg put:@"loginName" value:loginName];
    [msg put:@"password" value:password];
    [self sendToDCPService:msg callback:^(ACMsg *responseMsg, NSError *error) {
        if (error) {
            NSLog(@"%@", [error debugDescription]);
            if (callback) { callback(nil, error); }
            return;
        }
        [self saveLoginData:responseMsg error:&error];
        ACUserInfo *user = [ACUserInfo userInfoWithDict:responseMsg.getObjectData];
        if (callback) { callback(user, nil); }
    }];
}

+ (void)registerWithNickName:(NSString *)nickName
                       email:(NSString *)email
                    password:(NSString *)password
                  verifyCode:(NSString *)verifyCode
                    callback:(void(^)(ACUserInfo *user, NSError *error))callback {
    ACMsg *msg = [ACMsg msgWithName:msgName(kDCPServicePathRegister)];
    [msg put:@"loginName" value:email];
    [msg put:@"password" value:password];
    [msg put:@"nickName" value:nickName];
    [msg put:@"verifyCode" value:verifyCode];
    [self sendToDCPService:msg callback:^(ACMsg *responseMsg, NSError *error) {
        if (error) {
            if (callback) { callback(nil, error); }
            return;
        }
        [self saveLoginData:responseMsg error:&error];
        ACUserInfo *user = [ACUserInfo userInfoWithDict:responseMsg.getObjectData];
        if (callback) { callback(user, nil); }
    }];
}

+ (void)resetPasswordWithAccount:(NSString *)account
                        callback:(void(^)(BOOL success, NSError *error))callback {
    ACMsg *msg = [ACMsg msgWithName:msgName(kDCPServicePathResetPassword)];
    [msg put:@"loginName" value:account];
    [self sendToDCPService:msg callback:^(ACMsg *responseMsg, NSError *error) {
        callback([responseMsg getBool:@"reset"], error);
    }];
}

+ (void)updatePasswordWithAccount:(NSString *)account
                         password:(NSString *)password
                         callback:(void(^)(ACUserInfo *user, NSError *error))callback {
    ACMsg *msg = [ACMsg msgWithName:msgName(kDCPServicePathUpdatePassword)];
    [msg put:@"loginName" value:account];
    [msg put:@"password" value:password];
    [self sendToDCPService:msg callback:^(ACMsg *responseMsg, NSError *error) {
        if (error) {
            if (callback) { callback(nil, error); }
            return;
        }
        [self saveLoginData:responseMsg error:&error];
        ACUserInfo *user = [ACUserInfo userInfoWithDict:responseMsg.getObjectData];
        if (callback) { callback(user, nil); }
    }];
}

+ (void)changeNickName:(NSString *)nickName
              callback:(void(^)(NSError *error))callback {
    ACMsg *msg = [ACMsg msgWithName:msgName(kDCPServicePathUpdateProfile)];
    [msg put:@"nickName" value:nickName];
    [self sendToDCPService:msg callback:^(ACMsg *responseMsg, NSError *error) {
        callback(error);
    }];
}

+ (void)checkToken:(void(^)(BOOL valid))callback {
    ACMsg *msg = [ACMsg msgWithName:msgName(kDCPServicePathCheckToken)];
    if ([self getDcpToken].length > 0) {
        [self sendToDCPService:msg callback:^(ACMsg *responseMsg, NSError *error) {
            callback([responseMsg getBool:@"valid"]);
        }];
    } else {
        callback(NO);
    }
}

+ (void)logoutDCP {
    ACMsg *msg = [ACMsg msgWithName:msgName(kDCPServicePathLogout)];
    [self sendToDCPService:msg callback:nil];
}

+ (void)setDCPTokenInvalidCallback:(void (^)())callback {
    DCPTokenInvalidCallback = callback;
}

#pragma mark - content 部分

+ (void)setLanguage:(NSString *)language {
    [[NSUserDefaults standardUserDefaults] setValue:language forKey:kDCPServiceDCPLanguageName];
}

+ (void)setMarket:(NSString *)market {
    [[NSUserDefaults standardUserDefaults] setValue:market forKey:kDCPServiceDCPMarketName];
}

+ (void)syncContent:(DCPServiceContentType)type
           callback:(void(^)(ACMsg *responseMsg, NSError *error))callback {
    ACMsg *msg = [ACMsg msgWithName:msgName(kDCPServicePathSyncContent)];
    NSString *contentType = @"sync";
    switch (type) {
        case DCPServiceContentTypeTermOfUse:
            contentType = [contentType stringByAppendingString:@"TermOfUse"];
            break;
        case DCPServiceContentTypeLegalNotice:
            contentType = [contentType stringByAppendingString:@"LegalNotice"];
            break;
        case DCPServiceContentAfterSales:
            contentType = [contentType stringByAppendingString:@"AfterSales"];
            break;
        case DCPServiceContentCookies:
            contentType = [contentType stringByAppendingString:@"Cookies"];
            break;
        case DCPServiceContentPersonalData:
            contentType = [contentType stringByAppendingString:@"PersonalData"];
            break;
        case DCPServiceContentManual:
            contentType = [contentType stringByAppendingString:@"Manual"];
            break;
        case DCPServiceContentAppliances:
            contentType = [contentType stringByAppendingString:@"Appliances"];
            break;
        case DCPServiceContentLibraries:
            contentType = [contentType stringByAppendingString:@"Libraries"];
            break;
        case DCPServiceContentApplianceShop:
            contentType = [contentType stringByAppendingString:@"ApplianceShop"];
            break;
    }
    [msg put:@"contentType" value:contentType];
    [msg put:@"lang" value:[self getLanguage]];
    [msg put:DCPServiceParamTokenName value:[self getDcpToken]];
    [msg put:DCPServiceParamUidName value:[self getDcpUid]];
    [msg put:DCPServiceParamMarketName value:[self getMarket]];
    [self sendToDCPService:msg callback:callback];
}

#pragma mark - private

+ (void)sendToDCPService:(ACMsg *)msg callback:(void(^)(ACMsg *responseMsg, NSError *error))callback {
    if ([[msg.name stringByReplacingOccurrencesOfString:kDCPServicePathBase
                                             withString:@""]
         isEqual:kDCPServicePathCheckToken]) {
        
        [ACloudLib sendToService:RHSUBDOMAIN
                     serviceName:RHService
                         version:RHServiceVersion
                             msg:msg
                        callback:callback];
        return;
    }
    
    [ACServiceClient sendToServiceWithoutSignWithSubDomain:RHSUBDOMAIN
                                               ServiceName:RHService
                                            ServiceVersion:RHServiceVersion
                                                       Req:msg
                                                  Callback:callback];
    
    [ACServiceClient sendToAnonymousService:RHService version:RHServiceVersion msg:msg callback:callback];
}

+ (void)saveLoginData:(ACMsg *)responseObject error:(NSError **)error {
    
    if (responseObject) {
        if ([responseObject isErr]) {
            NSString *errMsg = [responseObject getErrMsg];
            NSString *errDesc = [responseObject getErrDesc];
            
            if (errMsg) {
                *error = ACErrorMake([responseObject getErrCode], errMsg, errDesc);
            }
        }
        if ([responseObject contains:@"userId"]) {
            [ACKeyChain saveUserId:[responseObject get:@"userId"]];
        }
        
        if ([responseObject.getObjectData[@"token"] length] > 0) {
            [ACKeyChain saveToken:[responseObject get:@"token"]];
        }
        
        if ([responseObject.getObjectData[@"tokenExpire"] length] > 0) {
            [ACKeyChain saveTokenExpire:[responseObject get:@"tokenExpire"]];
        }
        
        if ([responseObject.getObjectData[@"refreshToken"] length] > 0) {
            [ACKeyChain saveRefreshToken:[responseObject get:@"refreshToken"]];
        }
        
        if ([responseObject.getObjectData[@"refreshTokenExpire"] length] > 0) {
            [ACKeyChain saveRefreshTokenExpire:[responseObject get:@"refreshTokenExpire"]];
        }
        
        if ([responseObject.getObjectData[DCPServiceParamTokenName] length] > 0) {
            [self saveDcpToken:[responseObject get:DCPServiceParamTokenName]
                           uid:[responseObject get:DCPServiceParamUidName]];
        }
    }
}

+ (void)saveDcpToken:(NSString *)token uid:(NSString *)uid {
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:kDCPServiceDCPTokenName];
    [[NSUserDefaults standardUserDefaults] setValue:uid forKey:kDCPServiceDCPUidName];
}

+ (NSString *)getDcpToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:kDCPServiceDCPTokenName];
    return token ? token : @"";
}

+ (NSString *)getDcpUid {
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:kDCPServiceDCPUidName];
    return token ? token : @"";
}

+ (NSString *)getLanguage {
    NSString *lan = [[NSUserDefaults standardUserDefaults]
                     valueForKey:kDCPServiceDCPLanguageName];
    if ([lan isEqualToString:@"fr-BE"]) {
        lan = @"fr";
    } else if ([lan isEqualToString:@"nl-BE"]) {
        lan = @"nl";
    } else if ([lan isEqualToString:@"zh-Hant-HK"]) {
        lan = @"zh";
    }
    return lan ? lan : @"en";
}

+ (NSString *)getMarket {
    NSString *mk = [[NSUserDefaults standardUserDefaults]
                     valueForKey:kDCPServiceDCPMarketName];
    return mk ? mk : @"GS_INT";
}

@end
