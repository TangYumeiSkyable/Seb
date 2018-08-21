//
//  RHTimerItem.m
//  supor
//
//  Created by 赵冰冰 on 16/7/1.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHTimerItem.h"
#import "NSString+LKExtension.h"
#import "NSDate+YYAdd.h"
@implementation RHTimerItem

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"mDescription" : @"description"};
}

-(long long)deviceId
{
    long long deviceId = 0;
    NSArray * arr = [self.mDescription componentsSeparatedByString:@":"];
    if (arr) {
        if (arr.count > 2) {
            NSNumber * n = arr[2];
             deviceId = n.longLongValue;
        }
    }
  
    return deviceId;
}

-(NSString *)timeStamp
{
    NSString * timeStamp = @"";
    if (self.mDescription) {
        NSArray * arr = [self.mDescription componentsSeparatedByString:@":"];
        if (arr.count > 1) {
             timeStamp = arr[1];
        }
       
    }
    return timeStamp;
}

-(BOOL)isTop
{
    NSArray * arr = [self.mDescription componentsSeparatedByString:@":"];
    
    if (arr.count > 1) {
        if ([arr[0] isEqualToString:@"0"]) {
            return YES;
        }
    }
  
    return NO;
}

-(NSTimeInterval)transformTime:(NSString * )time
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:timeZone];
    NSDate * date1 = [formatter dateFromString:time];
    NSTimeInterval t1 = [date1 timeIntervalSince1970];
    return t1;
}

-(BOOL)onceContainTimeSlotWithStartTime:(NSString *)startTime andEndTime:(NSString *)endTime
{
    NSTimeInterval t3 = [self transformTime:startTime];
    NSTimeInterval t4 = [self transformTime:endTime];
    
    //如果开始时间大于结束时间
    if (t3 > t4) {
        t4 += 24 * 60 * 60;
    }

    NSString * fStartTime = self.mTimePoint;
    NSString * fEndTime = self.mEndTime;
    NSTimeInterval t1 = [self transformTime:fStartTime];
    NSTimeInterval t2 = [self transformTime:fEndTime];
    
    if (t1 > t2) {
        t2 += 24 * 60 * 60;
    }
    
    
    //如果t4在t1 和 t2之间
    if ((t4 < t2) && (t4 > t1)) {
        RHLog(@"有重叠 -- %@", self);
        return NO;
    }
    
    //如果t3在 t1 和 t2 之间
    if ((t3 < t2) && (t3 > t1))  {
        RHLog(@"有重叠 -- %@", self);
        return NO;
    }
    
    //如果新添加的块包含以前的块 或者和原来的块相等
    if ((t3 <= t1) && (t4 >= t2)) {
        return NO;
    }
    
    return YES;
}


-(BOOL)containTimeSlotWithStartTime:(NSString *)startTime andEndTime:(NSString *)endTime selfStartTime:(NSString *)selfStartTime selfEndTime:(NSString *)selfEndTime
{
    
    startTime = [startTime componentsSeparatedByString:@" "][1];
    startTime = [NSString stringWithFormat:@"2000-01-01 %@", startTime];
    
    endTime = [endTime componentsSeparatedByString:@" "][1];
    endTime = [NSString stringWithFormat:@"2000-01-01 %@", endTime];
    
    NSTimeInterval t3 = [self transformTime:startTime];
    NSTimeInterval t4 = [self transformTime:endTime];
    
    //如果开始时间大于结束时间
    if (t3 > t4) {
        t4 += 24 * 60 * 60;
    }
    
    NSString * fStartTime = [selfStartTime componentsSeparatedByString:@" "][1];
    fStartTime = [NSString stringWithFormat:@"2000-01-01 %@", fStartTime];
    
    NSString * fEndTime = [selfEndTime componentsSeparatedByString:@" "][1];
    fEndTime = [NSString stringWithFormat:@"2000-01-01 %@", fEndTime];
    
    NSTimeInterval t1 = [self transformTime:fStartTime];
    NSTimeInterval t2 = [self transformTime:fEndTime];
    
    if (t1 > t2) {
        t2 += 24 * 60 * 60;
    }
    
    
    //如果t4在t1 和 t2之间
    if ((t4 < t2) && (t4 > t1)) {
        RHLog(@"有重叠 -- %@", self);
        return NO;
    }
    
    //如果t3在 t1 和 t2 之间
    if ((t3 < t2) && (t3 > t1))  {
        RHLog(@"有重叠 -- %@", self);
        return NO;
    }
    
    //如果新添加的块包含以前的块 或者和原来的块相等
    if ((t3 <= t1) && (t4 >= t2)) {
        return NO;
    }
    
    return YES;

    
    return NO;
}

-(BOOL)newContainTimeSlotWithStartTime:(NSString *)startTime adnEndTime:(NSString *)endTime andRepeat:(NSString *)weekDay andTaskId:(NSString *)taskId andIsSelf:(BOOL)isSelf andDeviceId:(NSInteger)deviceId
{
    startTime = [startTime componentsSeparatedByString:@" "][1];
    startTime = [NSString stringWithFormat:@"2000-01-01 %@", startTime];
    
    endTime = [endTime componentsSeparatedByString:@" "][1];
    endTime = [NSString stringWithFormat:@"2000-01-01 %@", endTime];
    
    
    return YES;
}


-(BOOL)overDay:(NSString *)timePoint :(NSString *)endTime
{
    NSString * startTime = [timePoint componentsSeparatedByString:@" "][1];
    startTime = [NSString stringWithFormat:@"2000-01-01 %@", startTime];
    endTime = [endTime componentsSeparatedByString:@" "][1];
    endTime = [NSString stringWithFormat:@"2000-01-01 %@", endTime];
    NSTimeInterval t1 = [self transformTime:startTime];
    NSTimeInterval t2 = [self transformTime:endTime];
    
    BOOL ret = NO;
    if (t2 > t1) {
        ret = YES;
    }
    return ret;
}

-(BOOL)checkWithItem:(RHTimerItem *)aItem
{
    BOOL ret = YES;
    
    NSMutableArray * aArray = [aItem assembleTimeLinesWithTimePoint:aItem.mTimePoint andEndTime:aItem.mEndTime];
    NSMutableArray * bArray = [self assembleTimeLinesWithTimePoint:self.mTimePoint andEndTime:self.mEndTime];
    
    for (NSDictionary * aDict in aArray) {
        
        if (ret == NO) {
            break;
        }
        NSTimeInterval t1 = [aDict[@"start"] longLongValue];
        NSTimeInterval t2 = [aDict[@"end"] longLongValue];

        for (NSDictionary * bDict in bArray) {
            NSTimeInterval t3 = [bDict[@"start"] longLongValue];
            NSTimeInterval t4 = [bDict[@"end"] longLongValue];
            
            //t1 落到t3和t4之间
            if ((t1 > t3) && (t1 < t4)) {
                ret = NO;
                break;
            }
            
            if (t1 == t4) {
                ret = NO;
                break;
            }
            
            if (t2 == t3) {
                ret = NO;
                break;
            }
            
            //t2 落到t3和t4之间
            if ((t2 > t3) && (t2 < t4)) {
                ret = NO;
                break;
            }
            
           
            
            //新的包含旧的
            if ((t1 <= t3) && (t2 >= t4)) {
                ret = NO;
                break;
            }
            
        }
    }
    return ret;
}

//item必须有 startTime endTime 和 timeclycle
//组装时间线段
-(NSMutableArray *)assembleTimeLinesWithTimePoint:(NSString *)startTime andEndTime:(NSString *)endTime
{
    
    NSMutableArray * arrayM = [[NSMutableArray alloc]init];
    //如果自己是once
    if ([[self weeksArray] containsObject:@"-1"]) {
        
        NSString * weekDay = [[self class] getWeekdayWithTimePoint:[NSString stringWithFormat:@"%ld", (long)[startTime longlongFromDate] * 1000]];
        
        NSString * str = weekDay;
        NSInteger increment = str.integerValue;
        if (increment == 0) {
            increment = 7;
        }
        
        startTime = [startTime componentsSeparatedByString:@" "][1];
        startTime = [NSString stringWithFormat:@"2000-01-0%ld %@", (long)increment,startTime];
        
        endTime = [endTime componentsSeparatedByString:@" "][1];
        endTime = [NSString stringWithFormat:@"2000-01-0%ld %@", (long)increment,endTime];
        
        NSTimeInterval t3 = [self transformTime:startTime];
        NSTimeInterval t4 = [self transformTime:endTime];
        
        if (t3 >= t4) {
            t4 += 24 * 60 * 60;
        }
        
        endTime = [@"" TimeStamp:[NSString stringWithFormat:@"%ld", (long)t4 * 1000] format:@"yyyy-MM-dd HH:mm:ss" timeOffset:0];
        NSRange  range = NSMakeRange(9, 1);
        NSString * lastChar = [endTime substringWithRange:range];
        
        //证明是这个星期跨天
        if ([lastChar isEqualToString:@"8"]) {
            
            NSTimeInterval t1 = [@"" longlongFromDate:@"2000-01-07 23:59:59"];
            NSTimeInterval t2 = [@"" longlongFromDate:@"2000-01-01 00:00:00"];
            NSDictionary * dic1 = @{@"start":@(t3), @"end":@(t1)};
            NSDictionary * dic2 = @{@"start":@(t2), @"end":@(t4 - 7 * 24 * 3600 * 1000)};
            [arrayM addObject:dic1];
            [arrayM addObject:dic2];
            
        }else{
            
            NSDictionary * dic1 = @{ @"start": @(t3), @"end" : @(t4)};
            [arrayM addObject:dic1];
        }
        
        return arrayM;
    }
    
    for (NSString * str in [self weeksArray]) {
        
        NSInteger increment = str.integerValue;
        if (increment == 0) {
            increment = 7;
        }
        
        startTime = [startTime componentsSeparatedByString:@" "][1];
        startTime = [NSString stringWithFormat:@"2000-01-0%ld %@", (long)increment,startTime];
        
        endTime = [endTime componentsSeparatedByString:@" "][1];
        endTime = [NSString stringWithFormat:@"2000-01-0%ld %@", (long)increment,endTime];
        
        NSTimeInterval t3 = [self transformTime:startTime];
        NSTimeInterval t4 = [self transformTime:endTime];
        
        if (t3 >= t4) {
            t4 += 24 * 60 * 60;
        }
        
        endTime = [@"" TimeStamp:[NSString stringWithFormat:@"%ld", (long)t4 * 1000] format:@"yyyy-MM-dd HH:mm:ss" timeOffset:0];
        NSRange  range = NSMakeRange(9, 1);
        NSString * lastChar = [endTime substringWithRange:range];
        
        //证明是这个星期跨天
        if ([lastChar isEqualToString:@"8"]) {
            
            NSTimeInterval t1 = [@"" longlongFromDate:@"2000-01-07 23:59:59"];
            NSTimeInterval t2 = [@"" longlongFromDate:@"2000-01-01 00:00:00"];
            NSDictionary * dic1 = @{@"start":@(t3), @"end":@(t1 / 1000)};
            NSDictionary * dic2 = @{@"start":@(t2 / 1000), @"end":@(t4 - 7 * 24 * 3600)};
            [arrayM addObject:dic1];
            [arrayM addObject:dic2];
            
        }else{
            
            NSDictionary * dic1 = @{ @"start": @(t3), @"end" : @(t4)};
            [arrayM addObject:dic1];
        }
    }
    
    return arrayM;
}


-(BOOL)containTimeSlotWithStartTime:(NSString *)startTime andEndTime:(NSString *)endTime
{
    startTime = [startTime componentsSeparatedByString:@" "][1];
    startTime = [NSString stringWithFormat:@"2000-01-0 %@", startTime];
    
    endTime = [endTime componentsSeparatedByString:@" "][1];
    endTime = [NSString stringWithFormat:@"2000-01-01 %@", endTime];
    
    NSTimeInterval t3 = [self transformTime:startTime];
    NSTimeInterval t4 = [self transformTime:endTime];
    
    //如果开始时间大于结束时间
    if (t3 > t4) {
        t4 += 24 * 60 * 60;
    }
    
    NSString * fStartTime = [self.mTimePoint componentsSeparatedByString:@" "][1];
    fStartTime = [NSString stringWithFormat:@"2000-01-01 %@", fStartTime];
    
    NSString * fEndTime = [self.mEndTime componentsSeparatedByString:@" "][1];
    fEndTime = [NSString stringWithFormat:@"2000-01-01 %@", fEndTime];
    
    NSTimeInterval t1 = [self transformTime:fStartTime];
    NSTimeInterval t2 = [self transformTime:fEndTime];
    
    if (t1 > t2) {
        t2 += 24 * 60 * 60;
    }
    
    
    //如果t4在t1 和 t2之间
    if ((t4 < t2) && (t4 > t1)) {
        RHLog(@"有重叠 -- %@", self);
        return NO;
    }
    
    //如果t3在 t1 和 t2 之间
    if ((t3 < t2) && (t3 > t1))  {
        RHLog(@"有重叠 -- %@", self);
        return NO;
    }
    
    //如果新添加的块包含以前的块 或者和原来的块相等
    if ((t3 <= t1) && (t4 >= t2)) {
        return NO;
    }
    
    return YES;
    
}

-(NSString *)description
{
    NSString * json = [[self mj_JSONString] stringByAppendingString:@"------"];
    return json;
}

-(NSString *)getWeekdays
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:self.timePoint.longLongValue / 1000];
    NSString * week = [[self class] getDayWeek:date];
    return week;
}

+(NSString *)getWeekdayWithTimePoint:(NSString *)timePoint
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timePoint.longLongValue / 1000];
    NSString * week = [[self class] getDayWeek:date];
    return week;
}

+(NSString *)getDayWeek:(NSDate *)dateNow{
    NSString *weekDay;
//    dateNow=[NSDate dateWithTimeIntervalSinceNow:dayDelay*24*60*60];//dayDelay代表向后推几天，如果是0则代表是今天，如果是1就代表向后推24小时，如果想向后推12小时，就可以改成dayDelay*12*60*60,让dayDelay＝1
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSCalendar * calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;//这句我也不明白具体时用来做什么。。。
    NSDateComponents *comps = [calendar components:unitFlags fromDate:dateNow];
    long weekNumber = [comps weekday]; //获取星期对应的长整形字符串
//    long day=[comps day];//获取日期对应的长整形字符串
//    long year=[comps year];//获取年对应的长整形字符串
//    long month=[comps month];//获取月对应的长整形字符串
//    long hour=[comps hour];//获取小时对应的长整形字符串
//    long minute=[comps minute];//获取月对应的长整形字符串
//    long second=[comps second];//获取秒对应的长整形字符串
//    NSString *riQi =[NSString stringWithFormat:@"%ld日",day];//把日期长整形转成对应的汉字字符串
    switch (weekNumber) {
        case 1:
            weekDay=@"0";
            break;
        case 2:
            weekDay=@"1";
            break;
        case 3:
            weekDay=@"2";
            break;
        case 4:
            weekDay=@"3";
            break;
        case 5:
            weekDay=@"4";
            break;
        case 6:
            weekDay=@"5";
            break;
        case 7:
            weekDay=@"6";
            break;
            
        default:
            break;
    }
//    weekDay=[riQi stringByAppendingString:weekDay];//这里我本身的程序里只需要日期和星期，所以上面的年月时分秒都没有用上
    return weekDay;
}

-(NSArray *)weeksArray
{
    if ([self.timeCycle isEqualToString:@"once"]) {
        return @[@"-1"];
    }
    NSString * str = [self.timeCycle stringByReplacingOccurrencesOfString:@"week[" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"]" withString:@""];
    NSArray * arr = [str componentsSeparatedByString:@","];
    return arr;
}

+(NSArray *)assibleTimeArrayWithTimePoint:(NSString *)timePoint andEndTime:(NSString *)endTime
{
    NSString * newStr = [RHTimerItem getWeekdayWithTimePoint:[NSString stringWithFormat:@"%.0lf", [timePoint longlongFromDate:timePoint]]];
    
    NSString * newStr2 = [RHTimerItem getWeekdayWithTimePoint:[NSString stringWithFormat:@"%.0lf", [timePoint longlongFromDate:endTime]]];
    
    NSArray * timArr = nil;
    //两个时间不在同一天
    if (![newStr isEqualToString:newStr2]) {
        
        NSString * centerTim = [[endTime componentsSeparatedByString:@" "] objectAtIndex:0];
        centerTim = [centerTim stringByAppendingString:@" 00:00:00"];
        
        NSDictionary * dict1 = @{@"timePoint" : timePoint, @"endTime" : centerTim, @"week" : newStr};
        NSDictionary * dict2 = @{@"timePoint" : centerTim, @"endTime" : endTime, @"week": newStr2};
        
        timArr = @[dict1, dict2];
        
    }else{
        NSDictionary * dict1 = @{@"timePoint" : timePoint, @"endTime" : endTime, @"week" : newStr};
        timArr = @[dict1];
    }
    return timArr;
}

@end
