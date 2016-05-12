//
//  NSDate+ITTAdditions.m
//  iTotemFrame
//
//  Created by guo hua on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+ITTAdditions.h"

@implementation NSDate(ITTAdditions)

+ (NSString *) getDateWithInterval:(NSString *)time {
    
    NSTimeInterval times = [time doubleValue];// + 28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:times];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return  currentDateStr;
}

+ (NSString *) timeStringWithInterval:(NSTimeInterval)time
{
    
    int distance = [[NSDate date] timeIntervalSince1970] - time;
    NSString *string;
    if (distance < 1){//avoid 0 seconds
        string = @"刚刚";
    }
    else if (distance < 60) {
        string = [NSString stringWithFormat:@"%d秒前", (distance)];
    }
    else if (distance < 3600) {//60 * 60
        distance = distance / 60;
        string = [NSString stringWithFormat:@"%d分钟前", (distance)];
    }  
    else if (distance < 86400) {//60 * 60 * 24
        distance = distance / 3600;
        string = [NSString stringWithFormat:@"%d小时前", (distance)];
    }
    else if (distance < 604800) {//60 * 60 * 24 * 7
        distance = distance / 86400;
        string = [NSString stringWithFormat:@"%d天前", (distance)];
    }
    else if (distance < 2419200) {//60 * 60 * 24 * 7 * 4
        distance = distance / 604800;
        string = [NSString stringWithFormat:@"%d周前", (distance)];
    }
    else {
        NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
        
    }
    return string;
}

- (NSString *)stringWithSeperator:(NSString *)seperator
{
	return [self stringWithSeperator:seperator includeYear:YES];
}

// Return the formated string by a given date and seperator.
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSDate *date = [formatter dateFromString:str];
	return date;
}

- (NSString *)stringWithFormat:(NSString*)format
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	NSString *string = [formatter stringFromDate:self];
	return string;
}

+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

// Return the formated string by a given date and seperator, and specify whether want to include year.
- (NSString *)stringWithSeperator:(NSString *)seperator includeYear:(BOOL)includeYear
{
	if( seperator==nil ){
		seperator = @"-";
	}
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	if( includeYear ){
		[formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd",seperator,seperator]];
	}else{
		[formatter setDateFormat:[NSString stringWithFormat:@"MM%@dd",seperator]];
	}
	NSString *dateStr = [formatter stringFromDate:self];
	
	return dateStr;
}

// return the date by given the interval day by today. interval can be positive, negtive or zero. 
+ (NSDate *)relativedDateWithInterval:(NSInteger)interval
{
	return [NSDate dateWithTimeIntervalSinceNow:(24*60*60*interval)];
}

// return the date by given the interval day by given day. interval can be positive, negtive or zero. 
- (NSDate *)relativedDateWithInterval:(NSInteger)interval
{
	NSTimeInterval givenDateSecInterval = [self timeIntervalSinceDate:[NSDate relativedDateWithInterval:0]];
	return [NSDate dateWithTimeIntervalSinceNow:(24*60*60*interval+givenDateSecInterval)];
}

+ (NSString *)weekday
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:now];
	NSString *weekdayStr = nil;
    NSInteger weekday = [comps weekday];
	if( weekday==1 ){
		weekdayStr = @"星期日";
	}else if( weekday==2 ){
		weekdayStr = @"星期一";
	}else if( weekday==3 ){
		weekdayStr = @"星期二";
	}else if( weekday==4 ){
		weekdayStr = @"星期三";
	}else if( weekday==5 ){
		weekdayStr = @"星期四";
	}else if( weekday==6 ){
		weekdayStr = @"星期五";
	}else if( weekday==7 ){
		weekdayStr = @"星期六";
	}
	return weekdayStr;
}
///12/03日期格式
+ (NSString *)stringWithData
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:now];
    NSString *data = [NSString stringWithFormat:@"%ld/%ld",[comps month],[comps day]];
    return data;
}


+ (NSString *)getDeadLineTimeFromDieTime:(NSString *)dietimeString
{
    NSInteger dietime = dietimeString.intValue;
    NSString *dayString = [NSString stringWithFormat:@"%d",(int)dietime/(3600*24)];
    NSString *hourString = [NSString stringWithFormat:@"%d",(int)dietime%(3600*24)/3600];
    NSString *minuteString = [NSString stringWithFormat:@"%d",(int)dietime/60];
    if ([dietimeString isEqualToString:@"0"]) {
        dayString = @"";
        hourString = @"";
        minuteString = @"0分钟";
    } else {
        if (dayString.intValue == 0 && hourString.intValue == 0) {
            dayString = @"";
            if (minuteString.integerValue == 0) {
                minuteString = @"1分钟";
            } else if (minuteString.integerValue == 59) {
                hourString = @"1小时";
                minuteString = @"";
            } else {
                hourString = @"";
                minuteString = [NSString stringWithFormat:@"%@分钟",minuteString];
            }
        } else {
            if (dayString.integerValue == 0) {
                dayString = @"";
            } else {
                dayString = [NSString stringWithFormat:@"%@天",dayString];
            }
            if (hourString.integerValue == 0) {
                hourString = @"";
            } else if (hourString.integerValue == 23) {
                dayString = [NSString stringWithFormat:@"%d天",(int)dayString.integerValue + 1];
                hourString = @"";
            } else {
                hourString = [NSString stringWithFormat:@"%@小时",hourString];
            }
            minuteString = @"";
        }
    }
    return [NSString stringWithFormat:@"%@%@%@",dayString,hourString,minuteString];
}

+ (NSInteger)stringWithYear
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger year = [dateComponent year];
    return year;
}


- (NSDate *)zeroOfDate
 {
     NSCalendar *calendar = [NSCalendar currentCalendar];
     NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:self];
     components.hour = 0;
     components.minute = 0;
     components.second = 0;

    // components.nanosecond = 0 not available in iOS
     NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
     return [NSDate dateWithTimeIntervalSince1970:ts];
 }

+(NSString *)stringWithNowData
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
     return [dateFormatter stringFromDate:[NSDate date]];
}

+(NSString *)dateAddSomeNum
{
    NSInteger dis = 1; //前后的天数
    
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    
    if(dis!=0)
        
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*dis];
        //or
       // theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*dis];
    }
    else
    {
        theDate = nowDate;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    return [dateFormatter stringFromDate:theDate];
    
}

+(NSInteger)numDayFromDate:(NSDate*)date
{
    NSDate *selectDate = date;
    NSDate *nowDate = [NSDate date];
    
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    
    NSInteger num =  ([selectDate timeIntervalSince1970]*1 - [nowDate timeIntervalSince1970]*1)/oneDay;
    
    //NSLog(@"%ld",num);
    
    return num;
}

@end
