//
//  OrderInfo.m
//  supor
//
//  Created by 赵冰冰 on 16/7/8.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#define msgcode 66

#import "OrderInfoLibrary.h"

static NSInteger sn;

@implementation OrderInfoLibrary;

+(NSInteger)getSerialNumber
{
    sn++;
    return sn % 256;
}

+(NSString *)assimble
{
    NSString * hexSn = [self decimalToHex:[self getSerialNumber]];
    while (1) {
        if (hexSn.length < 2) {
            hexSn = [NSString stringWithFormat:@"0%@", hexSn];
        }else{
            break;
        }
    }
    hexSn = [NSString stringWithFormat:@"0x%@", hexSn];

    
    NSArray * arr = @[@"FFFF", @"0006", @"03", hexSn, @"0000", @"0000"];
    NSInteger sum = 0;
    for (NSString * str in arr) {
        if ([str isEqualToString:@"FFFF"]) {
            continue;
        }
        sum = sum + [[self decimalFromHex:str] integerValue];
    }
    
    NSString * checkSum = [NSString stringWithFormat:@"%ld", sum];
    checkSum = [self ToHex:checkSum.longLongValue];
    NSString * ret = @"";
    for (NSString * str in arr) {
        ret = [ret stringByAppendingString:str];
    }
    ret = [ret stringByAppendingString:checkSum];
    return ret;
}

+(NSString *)assimbleWith_attr_flags:(NSString *)att_flags attr_vals:(NSString *)attr_vals
{
    NSString * hexSn = [self decimalToHex:[self getSerialNumber]];
    while (1) {
        if (hexSn.length < 2) {
            hexSn = [NSString stringWithFormat:@"0%@", hexSn];
        }else{
            break;
        }
    }
    
    NSArray * arr = @[@"FFFF", @"001A", @"03", hexSn, @"0000", @"01", att_flags, attr_vals];
    NSInteger sum = 0;
    for (NSString * str in arr) {
        if ([str isEqualToString:@"FFFF"]) {
            continue;
        }
        sum = sum + [[self decimalFromHex:str] integerValue];
    }
    
    NSString * checkSum = [NSString stringWithFormat:@"%ld", sum];
    checkSum = [self ToHex:checkSum.longLongValue];
    NSString * ret = @"";
    for (NSString * str in arr) {
        ret = [ret stringByAppendingString:str];
    }
    ret = [ret stringByAppendingString:checkSum];
    return ret;
}

+(NSData *)getOrderInfo:(Order)order
{
    NSData * data = nil;
    
    NSString * ret = nil;
    
    switch (order) {
        case OrderWindSpeed_1:
        {
            ret = [self assimbleWith_attr_flags:@"0010" attr_vals:@"10000"];
        }
            break;
         case OrderWindSpeed_2:
        {
            ret = [self assimbleWith_attr_flags:@"0010" attr_vals:@"20000"];
        }
            break;
        case OrderWindSpeed_3:
        {
            ret = [self assimbleWith_attr_flags:@"0010" attr_vals:@"30000"];
        }
            break;
        case OrderWindSpeed_4:
        {
            ret = [self assimbleWith_attr_flags:@"0010" attr_vals:@"40000"];
        }
            break;
        case OrderOn:
        {
            ret = [self assimbleWith_attr_flags:@"0004" attr_vals:@"0000000000000001"];
        }
            break;
        case OrderOff:
        {
            ret = [self assimbleWith_attr_flags:@"0004" attr_vals:@"0000000000000000"];
            
        }
            break;
        case OrderSleep:
        {
            ret = [self assimbleWith_attr_flags:@"0008" attr_vals:@"0000000000000001"];
        }
            break;
        case OrderLampOff:
        {
            ret = [self assimbleWith_attr_flags:@"2000" attr_vals:@"0000000000000000"];
        }
            break;
        case OrderLamp_1:
        {
            ret = [self assimbleWith_attr_flags:@"2000" attr_vals:@"0000000000000001"];
        }
            break;
        case OrderLamp_2:
        {
            ret = [self assimbleWith_attr_flags:@"2000" attr_vals:@"0000000000000002"];
        }
            break;
        case OrderAnio_on:
        {
            ret = [self assimbleWith_attr_flags:@"1000" attr_vals:@"0000000000000040"];
        }
            break;
        case OrderAnion_off:
        {
            ret = [self assimbleWith_attr_flags:@"1000" attr_vals:@"0000000000000000"];
        }
            break;
        case OrderManual:
        {
            ret = [self assimbleWith_attr_flags:@"0008" attr_vals:@"0000000000000002"];
        }
            
            break;
        case OrderAuto:
        {
            ret = [self assimbleWith_attr_flags:@"0008" attr_vals:@"0000000000000000"];
        }
            break;
            
        case OrderQueryPM25:
        {
            ret = [self assimble];
        }
            break;
        default:
            break;
    }
    
    ret = [ret stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    data = [self hexToByteToNSData:ret];
//    data = [[NSData alloc]init];
    return data;
}

+(void)control:(NSInteger )deviceId msgCode:(NSInteger)msgCode OrderType:(Order)orderType  subDomian:(NSInteger)subDomainId callback:(void (^)(ACDeviceMsg *responseMsg, NSError *error))callback
{
    ACDeviceMsg * deviceMsg = [[ACDeviceMsg alloc]init];
    deviceMsg.msgCode = msgCode;
    deviceMsg.payload = [self getOrderInfo:orderType];
    
    
    
    [ACBindManager sendToDeviceWithOption:2 SubDomain:[self getSubDomainByID:[NSString stringWithFormat:@"%ld", subDomainId]] deviceId:deviceId msg:deviceMsg callback:^(ACDeviceMsg *responseMsg, NSError *error) {
        callback(responseMsg, error);
    }];
}


+(void)control:(NSInteger )deviceId msg:(ACDeviceMsg *)deviceMsg  subDomian:(NSInteger)subDomainId callback:(void (^)(ACDeviceMsg *responseMsg, NSError *error))callback
{
    [ACBindManager sendToDeviceWithOption:2 SubDomain:[self getSubDomainByID:[NSString stringWithFormat:@"%ld", subDomainId]] deviceId:deviceId msg:deviceMsg callback:^(ACDeviceMsg *responseMsg, NSError *error) {
        callback(responseMsg, error);
    }];
}

+(NSString*) getSubDomainByID:(NSString*)subDomainId{

    return @"airclear";
}

+(NSString *)translateIdtoStringWithID:(NSInteger)subDomainId
{
    return RHSUBDOMAIN;
}

+(NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}

/**
 *  十六进制字符串转化为 NSDate
 *
 *  @param str 十六进制字符
 *
 *  @return NSData
 */
+(NSData *)hexToByteToNSData:(NSString *)str{
    int j=0;
    Byte bytes[[str length]/2];
    for(int i=0;i<[str length];i++)
    {
        int int_ch;  ///两位16进制数转化后的10进制数
        unichar hex_char1 = [str characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [str characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里 }
        j++;
    }
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:[str length]/2 ];
    NSLog(@"%@",newData);
    return newData;
}


-(NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}

/**
 *  数字转化为16进制度字符串
 *
 *  @param tmpid 数字
 *
 *  @return
 */

+(NSString *)decimalToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}
/**
 *  把十六进制转化为十进制
 *
 *  @param hexString
 *
 *  @return
 */
+(NSString *)decimalFromHex:(NSString *)hexString
{
    NSString * numStr = [hexString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    NSInteger sum = 0;
    NSInteger i = 0;
    while (1) {
        NSInteger len = numStr.length;
        if (len == 0) {
            break;
        }
        
        //计算最后一位的integervalue
        NSString * lastStr = [numStr substringFromIndex:len - 1];
        NSInteger c = 0;
        if ([lastStr isEqualToString:@"A"] || [lastStr isEqualToString:@"a"]) {
            c = 10;
        }
        else if ([lastStr isEqualToString:@"B"] || [lastStr isEqualToString:@"b"]) {
            c = 11;
        }
        else if ([lastStr isEqualToString:@"C"] || [lastStr isEqualToString:@"c"]) {
            c = 12;
        }
        else if ([lastStr isEqualToString:@"D"] || [lastStr isEqualToString:@"d"]) {
            c = 13;
        }
        else if ([lastStr isEqualToString:@"E"] || [lastStr isEqualToString:@"e"]) {
            c = 14;
        }
        else if ([lastStr isEqualToString:@"F"] || [lastStr isEqualToString:@"f"]) {
            c = 15;
        }else{
            c = lastStr.integerValue;
        }
        
        sum = sum + c * pow(16, i);
        numStr = [numStr substringToIndex:len - 1];
        i++;
        
    }
    NSString * ret = [NSString stringWithFormat:@"%ld", sum];
    NSLog(@"传入 %@ 传出 %@", hexString, ret);
    return ret;
}


@end
