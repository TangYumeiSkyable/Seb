//
//  NSString+LKExtension.m
//  LKLookingFor
//
//  Created by huayiyang on 16/3/7.
//  Copyright © 2016年 RiHui. All rights reserved.
//

#import "NSString+LKExtension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LKExtension)
// 生成MD5String
- (NSString *)MD5String {
    //要进行UTF8的转码
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *MD5String = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [MD5String appendFormat:@"%02x", result[i]];
    }
    
    return MD5String;
}

// 生成SHA256
- (NSString *)SHA256String {
    const char *input = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(input, (CC_LONG)strlen(input), result);
    
    NSMutableString* SHA256String = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [SHA256String appendFormat:@"%02x", result[i]];
    return SHA256String;
}

#pragma 正则匹配11位手机号
- (BOOL)checkPhoneNumber {
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:self];
    BOOL res2 = [regextestcm evaluateWithObject:self];
    BOOL res3 = [regextestcu evaluateWithObject:self];
    BOOL res4 = [regextestct evaluateWithObject:self];
    
    if (res1 || res2 || res3 || res4 ) {
        return YES;
    } else {
        return NO;
    }
    
}


/*
 字母数字大小写 8位以上
 */
- (BOOL)checkPassword {
    
    NSString * pattern = @"^(?=.*[0-9].*)(?=.*[A-Z].*)(?=.*[a-z].*).{8,30}$";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:self];
}

#pragma 正则匹配用户姓名,2-16个英文 1至8个中文
- (BOOL)checkUserName {
    
    NSString *pattern = @"^[a-zA-Z0-9\u4E00-\u9FA5]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
    
}

// 身份证号
#pragma 正则匹配用户身份证号15或18位
- (BOOL)checkUserIDCard {
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    
    NSString * temp = self;
    NSString * lastChar = [self substringFromIndex:self.length - 1];
    NSString * forntStr = [self substringToIndex:self.length - 1];
    if ([lastChar isEqualToString:@"x"]) {
        temp = [forntStr stringByAppendingString:@"X"];
    }
    
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:temp];
    return isMatch;
    
}

- (BOOL)checkPhone {
    NSString * pattern = @"d{3}-d{8}|d{4}-d{7}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (BOOL)checkMail {
    NSString * regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    if (!isMatch) {
        return NO;
    }
    else{
        return YES;
    }
}

// 匹配非负浮点数（正浮点数 + 0）
- (BOOL)checkWithdraw {
    NSString * pattern = @"^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (BOOL)checkFloatNum {
    NSString * pattern = @"^(([1-9]+)|([0-9]+\\.[0-9]{1,2}))$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
    
}

-(BOOL)checkNum {
    NSString * pattern = @"^[1-9]\\d*$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

// 验证码
#pragma 正则匹验证码,6位的数字
- (BOOL)checkVerifyCode {
    NSString *pattern = @"^[0-9]{6}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
    
}


//-(NSString *)transFromNSTimeIntervalWithFormat:(NSString *)format
//{
//    //    NSTimeInterval time = [self doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
//    NSTimeInterval time = [self doubleValue];//因为时差问题要加8小时 == 28800 sec
//    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
//    
//    //实例化一个NSDateFormatter对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:format];
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [dateFormatter setTimeZone:timeZone];
//    
//    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
//    return currentDateStr;
//}

//- (NSString *)transFromNSTimeInterval {
//    
//    //    NSTimeInterval time = [self doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
//    NSTimeInterval time = [self doubleValue];//因为时差问题要加8小时 == 28800 sec
//    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
//    
//    //实例化一个NSDateFormatter对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [dateFormatter setTimeZone:timeZone];
//    
//    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
//    return currentDateStr;
//}

// 比较两个日期之间的天数差和时间差
//+ (NSTimeInterval)compareDateOfStringA:(NSString *)stringA StringB:(NSString *)stringB {
//    
//    // 创建日期格式对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [dateFormatter setTimeZone:timeZone];
//    NSDate *dateA = [dateFormatter dateFromString:stringA];
//    NSDate *dateB = [dateFormatter dateFromString:stringB];
//    
//    NSTimeInterval time = [dateB timeIntervalSinceDate:dateA];
//    
//    //    int days = ((int)time) / (3600 * 24);
//    //    int hours = ((int)time) % (3600 * 24) / 3600;
//    //
//    //    NSString *dateContent = [[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
//    
//    return time;
//}
- (NSTimeInterval)longlongFromDate {
    // 创建日期格式对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone =[NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate *date = [dateFormatter dateFromString:self];
    return [date timeIntervalSince1970];
}

- (NSTimeInterval)longlongFromDate:(NSString *)dateTimeString {
    // 创建日期格式对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate *date = [dateFormatter dateFromString:dateTimeString];
    return [date timeIntervalSince1970]*1000;
}

//  将日期转换为字符串 @"yyyy-MM-dd HH:mm:ss"
+ (NSString *)componentDateToStringWithDateA:(NSDate *)dateA DateB:(NSDate *)dateB {
    NSString *componentString = @"";
    NSDateFormatter *dateAFormatter = [[NSDateFormatter alloc] init];
    [dateAFormatter setDateFormat:@"yyyy-MM"];
    NSString *stringA = [dateAFormatter stringFromDate:dateA];
    NSString *stringB = [dateAFormatter stringFromDate:dateB];
    componentString = [stringA stringByAppendingString:@" - "];
    componentString = [componentString stringByAppendingString:stringB];
    return componentString;
}
//  将日期转换为字符串 @"yyyy-MM-dd HH:mm:ss"
+ (NSString *)componentDateToStringWithDateStringA:(NSString *)dateA DateStringB:(NSString *)dateB {
    NSString *componentString = @"";
    NSDateFormatter *dateAFormatter = [[NSDateFormatter alloc] init];
    [dateAFormatter setDateFormat:@"yyyy-MM"];
    
    NSDate *dateA1 = [dateAFormatter dateFromString:dateA];
    NSDate *dateB1 = [dateAFormatter dateFromString:dateB];
    
    NSString *stringA = [dateAFormatter stringFromDate:dateA1];
    NSString *stringB = [dateAFormatter stringFromDate:dateB1];
    
    componentString = [stringA stringByAppendingString:@" - "];
    componentString = [componentString stringByAppendingString:stringB];
    return componentString;
}

//  将时间转化为字符串
+ (NSString *)componentTimeToStringWithTimeStringA:(NSString *)dateA TimeStringB:(NSString *)dateB {
    NSString *componentString = @"";
    NSDateFormatter *dateAFormatter = [[NSDateFormatter alloc] init];
    [dateAFormatter setDateFormat:@"HH:mm"];
    
    NSDate *dateA1 = [dateAFormatter dateFromString:dateA];
    NSDate *dateB1 = [dateAFormatter dateFromString:dateB];
    
    
    NSString *stringA = [dateAFormatter stringFromDate:dateA1];
    NSString *stringB = [dateAFormatter stringFromDate:dateB1];
    
    componentString = [stringA stringByAppendingString:@" - "];
    componentString = [componentString stringByAppendingString:stringB];
    return componentString;
}

//+ (NSString *)componentDateToStringWithDateString:(NSString *)dateA DateString:(NSString *)dateB {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [dateFormatter setTimeZone:timeZone];
//    
//    NSString *dateStr1 = [dateFormatter stringFromDate:[dateFormatter dateFromString:dateA]];
//    NSString *dateStr2 = [dateFormatter stringFromDate:[dateFormatter dateFromString:dateB]];
//    
//    NSString *dateString = @"";
//    dateString = [[[dateStr1 substringFromIndex:5] stringByAppendingString:@" - "] stringByAppendingString:[dateStr2 substringFromIndex:5]];
//    return dateString;
//}


////  将字符串转为日期
//+ (NSDate *)translateToDateWithString:(NSString *)dateString {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [dateFormatter setTimeZone:timeZone];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *date = [dateFormatter dateFromString:dateString];
//    return date;
//}
//
////  将时间转换为字符串
//+ (NSDate *)translateToTimeWithString:(NSString *)timeString {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [dateFormatter setTimeZone:timeZone];
//    [dateFormatter setDateFormat:@"HH:mm:ss"];
//    NSDate *date = [dateFormatter dateFromString:timeString];
//    return date;
//}

//-(NSString *)timeStamp:(NSString *)timeStamp format:(NSString *)format
//{
//    NSString*str=@"1368082020";//时间戳
//    
//    NSTimeIntervaltime=[strdoubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
//    
//    NSDate*detaildate=[NSDatedateWithTimeIntervalSince1970:time];
//    
//    NSLog(@"date:%@",[detaildatedescription]);
//    
//    //实例化一个NSDateFormatter对象
//    
//    NSDateFormatter*dateFormatter = [[NSDateFormatteralloc]init];
//    
//    //设定时间格式,这里可以设置成自己需要的格式
//    
//    [dateFormattersetDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    NSString*currentDateStr = [dateFormatterstringFromDate:detaildate];
//    
//    
//    
//
//    
//    -(NSString *)TimeStamp:(NSString *)strTime
//    
//    {
//        
//        //实例化一个NSDateFormatter对象
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        
//        //设定时间格式,这里可以设置成自己需要的格式
//        
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        
//        //用[NSDate date]可以获取系统当前时间
//        
//        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
//        
//        //输出格式为：2010-10-27 10:22:13
//        
//        NSLog(@"%@",currentDateStr);
//        
//        //alloc后对不使用的对象别忘了release
//        
//        [dateFormatter release];
//        
//        return currentDateStr;
//        
//    }
//    
//
//}

- (NSString *)TimeStamp:(NSString *)strTimexxx timeOffset:(NSInteger)timeOffset {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[strTimexxx longLongValue] / 1000.0 - timeOffset * 60 * 60];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    
    return currentDateStr;
}

- (NSString *)TimeStamp:(NSString *)strTime format:(NSString *)format timeOffset:(NSInteger)timeOffset {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
  
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[strTime longLongValue] / 1000.0 -  timeOffset * 60 * 60];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

#warning - 现在暂时认为服务器给的时间都是格林威治时间
- (NSString *)TimeStamp:(NSString *)strTime format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[strTime longLongValue] / 1000.0 - 8 * 3600];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    NSLog(@"%@",currentDateStr);
    return currentDateStr;
}

#warning - 现在暂时认为服务器给的时间都是格林威治时间
- (NSString *)TimeStamp:(NSString *)strTimexxx {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[strTimexxx longLongValue] / 1000.0];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];

    return currentDateStr;
}


- (NSString *)stringFromDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

- (NSDate *)DateFromString:(NSString *)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:time];
    return date;
}

- (NSString *)filterHTML:(NSString *)html {
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        
        html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    }
    return html;
}

+ (BOOL)isInTheRange {
    NSDate *today = [NSDate date];
    
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:[NSDate date]];
    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    [dateComponentsForDate setDay:dateComponents.day];
    [dateComponentsForDate setMonth:dateComponents.month];
    [dateComponentsForDate setYear:dateComponents.year];
    [dateComponentsForDate setHour:7];
    [dateComponentsForDate setMinute:00];
    NSDate *start = [greCalendar dateFromComponents:dateComponentsForDate];
    
    NSCalendar *greCalendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents1 = [greCalendar1 components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:[NSDate date]];
    NSDateComponents *dateComponentsForDate1 = [[NSDateComponents alloc] init];
    [dateComponentsForDate1 setDay:dateComponents1.day];
    [dateComponentsForDate1 setMonth:dateComponents1.month];
    [dateComponentsForDate1 setYear:dateComponents1.year];
    [dateComponentsForDate1 setHour:21];
    [dateComponentsForDate1 setMinute:00];
    NSDate *end = [greCalendar1 dateFromComponents:dateComponentsForDate1];
    
    NSLog(@"%@", today);
    NSLog(@"%@", start);
    NSLog(@"%@", end);
    
    if ([today compare:start] == NSOrderedDescending && [today compare:end] == NSOrderedAscending) {
        NSLog(@"之内");
        return YES;
    }
    NSLog(@"之外");
    return NO;
}

+ (NSString *)strKey {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *dt = [NSDate date];
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp = [gregorian components: unitFlags fromDate:dt];
    NSString *strKey = [NSString stringWithFormat:@"%ld%ld%ld", (long)comp.year, (long)comp.month, (long)comp.day];
    return strKey;
}


@end
