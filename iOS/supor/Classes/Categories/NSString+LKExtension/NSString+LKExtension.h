//
//  NSString+LKExtension.h
//  LKLookingFor
//
//  Created by huayiyang on 16/3/7.
//  Copyright © 2016年 RiHui. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <AFNetworking.h>
@interface NSString (LKExtension)
/**
 *  生成MD5字符串
 */
- (NSString *)MD5String;
/**
 *  生成 SHA256 字符串
 */
- (NSString *)SHA256String;

/**
 *  检查11位手机号
 *
 *  @return <#return value description#>
 */
- (BOOL)checkPhoneNumber;
/**
 *  检查 6-30 的密码 字母数字混合输入
 *
 *  @return <#return value description#>
 */
- (BOOL)checkPassword;
/**
 *  检查用户名
 *
 *  @return <#return value description#>
 */


- (BOOL)checkUserName;

/**
 *  检查座机号码
 *
 *  @return <#return value description#>
 */

-(BOOL)checkPhone;

/**
 *  检查身份证号
 *
 *  @return <#return value description#>
 */

- (BOOL)checkUserIDCard;
/**
 *  检查邮箱
 *
 *  @return <#return value description#>
 */
-(BOOL)checkMail;

/**
 *  检查验证码
 *
 *  @return <#return value description#>
 */

- (BOOL)checkVerifyCode;

/**
 *  检查验证码
 *
 *  @return <#return value description#>
 */
-(BOOL)checkWithdraw;
/**
 *  正整数
 *
 *  @return <#return value description#>
 */
-(BOOL)checkNum;
/**
 *  正则表达式 验证数字格式  非负数 小数点后保留两位
 *
 *  @return <#return value description#>
 */

-(BOOL)checkFloatNum;
/**
 *  比较今天和其他日期的早晚
 */



//+ (BOOL)compareTodayWithOneday:(NSString *)oneday AddOne:(BOOL)addOne;

//- (NSString *)transFromNSTimeInterval;
/**
 *  将时间字符串转为秒间隔
 */
- (NSTimeInterval)longlongFromDate:(NSString *)dateTimeString;

/**
 *  比较日期字符串之间的天数差 小时差
 */
//+ (NSTimeInterval)compareDateOfStringA:(NSString *)stringA StringB:(NSString *)stringB;

/**
 *  日期转换成字符串 并拼接
 */
+ (NSString *)componentDateToStringWithDateStringA:(NSString *)dateA DateStringB:(NSString *)dateB;
/**
 *  时间转换成字符串 并拼接
 */
+ (NSString *)componentTimeToStringWithTimeStringA:(NSString *)dateA TimeStringB:(NSString *)dateB;

/**
 *  将两个2012-12-21 类型的时间串拼接成2012.12.12的字符串 同时截取月和日
 */
//+ (NSString *)componentDateToStringWithDateString:(NSString *)dateA DateString:(NSString *)dateB;

/**
 *  字符串转换成日期
 */
//+ (NSDate *)translateToDateWithString:(NSString *)dateString;
/**
 *  字符串转换成时间
 */
//+ (NSDate *)translateToTimeWithString:(NSString *)timeString;

//传入时间格和时间戳
//-(NSString *)transFromNSTimeIntervalWithFormat:(NSString *)format;
//传入时间戳和时间格式
//-(NSString *)timeStamp:(NSString *)timeStamp format:(NSString *)format;

- (NSTimeInterval)longlongFromDate;

-(NSString *)TimeStamp:(NSString *)strTime;
//
//-(NSString *)TimeStamp:(NSString *)strTime format:(NSString *)format;
/**
 *  传入时间戳 转换为 时间字符串
 *
 *  @param strTimexxx 时间戳
 *  @param timeOffset 相对于GTM时间的偏移量
 *
 *  @return 时间字符串
 */
-(NSString *)TimeStamp:(NSString *)strTimexxx timeOffset:(NSInteger)timeOffset;

/**
 *  传入时间戳 转换为 时间字符串
 *
 *  @param strTime    时间戳
 *  @param format     时间格式 
 *  @param timeOffset 相对于GTM时间的偏移量
 *
 *  @return 时间字符串
 */
-(NSString *)TimeStamp:(NSString *)strTime format:(NSString *)format timeOffset:(NSInteger)timeOffset;

- (NSString *)stringFromDate:(NSDate *)date;

-(NSDate *)DateFromString:(NSString *)time;

/*
 去掉html标签
 */
-(NSString *)filterHTML:(NSString *)html;

/*
 是否在7点到21点之间
 */
+ (BOOL)isInTheRange;

+ (NSString *)strKey;
@end
