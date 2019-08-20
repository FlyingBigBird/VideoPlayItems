//
//  NSDate-Helper.m
//  FotileCSS
//
//  Created by ojbk on 2018/8/13.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import "NSDate-Helper.h"

@implementation NSDate(Helpers)

- (NSString *)getFormatYearMonthDay
{
    NSString *string;
    if ([self getMonth] < 10 && [self getDay] < 10) {
        
        string = [NSString stringWithFormat:@"%lu-0%lu-0%lu",(unsigned long)[self getYear],(unsigned long)[self getMonth],(unsigned long)[self getDay]];
    }
    else if ([self getMonth] < 10 && [self getDay] >= 10) {
        
        string = [NSString stringWithFormat:@"%lu-0%lu-%lu",(unsigned long)[self getYear],(unsigned long)[self getMonth],(unsigned long)[self getDay]];
    }
    else if ([self getMonth] >= 10 && [self getDay] >= 10) {
        
        string = [NSString stringWithFormat:@"%lu-%lu-%lu",(unsigned long)[self getYear],(unsigned long)[self getMonth],(unsigned long)[self getDay]];
    }
    else {
        
        string = [NSString stringWithFormat:@"%lu-%lu-0%lu",(unsigned long)[self getYear],(unsigned long)[self getMonth],(unsigned long)[self getDay]];
    }
    return string;
}

- (NSString *)getFormatHourMinuteSecond {
    
    NSString *string = @"- -";

    NSString *hour = @"";
    NSString *minute = @"";
    NSString *second = @"";
    
    if ([self getHour] < 10) {
        
        hour = [NSString stringWithFormat:@"0%d", [self getHour]];
    } else {
        hour = [NSString stringWithFormat:@"%d", [self getHour]];
    }
    
    if ([self getMinute] < 10) {
        
        minute = [NSString stringWithFormat:@"0%d", [self getMinute]];
    } else {
        minute = [NSString stringWithFormat:@"%d", [self getMinute]];
    }

    if ([self getSecond] < 10) {
        
        second = [NSString stringWithFormat:@"0%d", [self getSecond]];
    } else {
        second = [NSString stringWithFormat:@"%d", [self getSecond]];
    }
    string = [NSString stringWithFormat:@"%@:%@:%@", hour, minute, second];
    return string;
}

- (int )getWeekNumOfMonth
{
    return [[self endOfMonth] getWeekOfYear] - [[self beginningOfMonth] getWeekOfYear] + 1;
}

- (int )getWeekOfYear
{
    int i;
    NSUInteger year = [self getYear];
    NSDate *date = [self endOfWeek];
    for (i = 1;[[date dateAfterDay:-7 * i] getYear] == year;i++)
    {
    }
    return i;
}

- (NSDate *)dateAfterDay:(int)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    //	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:day];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    
    return dateAfterDay;
}

- (NSDate *)dateafterMonth:(int)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    //	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setMonth:month];
    NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    
    return dateAfterMonth;
}

- (NSUInteger)getDay {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitDay) fromDate:self];
    return [dayComponents day];
}

- (NSUInteger)getMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMonth) fromDate:self];
    return [dayComponents month];
}

- (NSUInteger)getYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitYear) fromDate:self];
    return [dayComponents year];
}

- (int )getHour {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | //年
    NSCalendarUnitMonth | //月份
    NSCalendarUnitDay | //日
    NSCalendarUnitHour |  //小时
    NSCalendarUnitMinute |  //分钟
    NSCalendarUnitSecond;  // 秒
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger hour = [components hour];
    return (int)hour;
}

- (int)getMinute {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | //年
    NSCalendarUnitMonth | //月份
    NSCalendarUnitDay | //日
    NSCalendarUnitHour |  //小时
    NSCalendarUnitMinute |  //分钟
    NSCalendarUnitSecond;  // 秒
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger minute = [components minute];
    return (int)minute;
}

- (int)getSecond {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | //年
    NSCalendarUnitMonth | //月份
    NSCalendarUnitDay | //日
    NSCalendarUnitHour |  //小时
    NSCalendarUnitMinute |  //分钟
    NSCalendarUnitSecond;  // 秒
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger second = [components second];
    return (int)second;
}

- (int)getHour:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | //年
    NSCalendarUnitMonth | //月份
    NSCalendarUnitDay | //日
    NSCalendarUnitHour |  //小时
    NSCalendarUnitMinute |  //分钟
    NSCalendarUnitSecond;  // 秒
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    NSInteger hour = [components hour];
    return (int)hour;
}

- (int)getMinute:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | //年
    NSCalendarUnitMonth | //月份
    NSCalendarUnitDay | //日
    NSCalendarUnitHour |  //小时
    NSCalendarUnitMinute |  //分钟
    NSCalendarUnitSecond;  // 秒
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    NSInteger minute = [components minute];
    return (int)minute;
}

- (NSUInteger)daysAgo {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components day];
}

- (NSUInteger)daysAgoWithDate: (NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay)
                                               fromDate:self
                                                 toDate:date
                                                options:0];
    return [components day];
}

- (NSUInteger)daysAgoAgainstMidnight {
    
    // get a midnight version of ourself:
    NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
    
    return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSString *)stringDaysAgo {
    
    return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
    
    NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
    NSString *text = nil;
    switch (daysAgo) {
        case 0:
            text = @"Today";
            break;
        case 1:
            text = @"Yesterday";
            break;
        default:
            text = [NSString stringWithFormat:@"%lu days ago", (unsigned long)daysAgo];
    }
    return text;
}

- (NSUInteger)weekday {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitWeekday) fromDate:self];
    return [weekdayComponents weekday];
}

+ (NSDate *)dateFromString:(NSString *)string {
    
    return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    
    return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    
    return [date string];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
    /*
     * if the date is in today, display 12-hour time with meridian,
     * if it is within the last 7 days, display weekday name (Friday)
     * if within the calendar year, display as Jan 23
     * else display as Nov 11, 2008
     */
    
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offsetComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                     fromDate:today];
    
    NSDate *midnight = [calendar dateFromComponents:offsetComponents];
    
    NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
    NSString *displayString = nil;
    
    // comparing against midnight
    if ([date compare:midnight] == NSOrderedDescending) {
        
        if (prefixed) {
            [displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
        } else {
            [displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
        }
    } else {
        // check if date is within last 7 days
        NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
        [componentsToSubtract setDay:-7];
        NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
        
        if ([date compare:lastweek] == NSOrderedDescending) {
            
            [displayFormatter setDateFormat:@"EEEE"]; // Tuesday
        } else {
            
            // check if same calendar year
            NSInteger thisYear = [offsetComponents year];
            
            NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                           fromDate:date];
            NSInteger thatYear = [dateComponents year];
            
            if (thatYear >= thisYear) {
                [displayFormatter setDateFormat:@"MMM d"];
            } else {
                [displayFormatter setDateFormat:@"MMM d, yyyy"];
            }
        }
        if (prefixed) {
            NSString *dateFormat = [displayFormatter dateFormat];
            NSString *prefix = @"'on' ";
            [displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
        }
    }
    
    // use display formatter to return formatted date string
    displayString = [displayFormatter stringFromDate:date];
    return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
    
    return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSString *)stringWithFormat:(NSString *)format {
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    return timestamp_str;
}

- (NSString *)string {
    
    return [self stringWithFormat:[NSDate dbFormatString]];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateStyle:dateStyle];
    [outputFormatter setTimeStyle:timeStyle];
    NSString *outputString = [outputFormatter stringFromDate:self];
    return outputString;
}

//返回周日的的开始时间
- (NSDate *)beginningOfWeek {
    
    // largely borrowed from "Date and Time Programming Guide for Cocoa"
    // we'll use the default calendar and hope for the best
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *beginningOfWeek = nil;
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth startDate:&beginningOfWeek
                           interval:NULL forDate:self];
    if (ok) {
        return beginningOfWeek;
    }
    
    // couldn't calc via range, so try to grab Sunday, assuming gregorian style
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    beginningOfWeek = nil;
    beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
    
    //normalize to midnight, extract the year, month, and day components and create a new date from those components.
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                               fromDate:beginningOfWeek];
    return [calendar dateFromComponents:components];
}

//返回当前天的年月日.
- (NSDate *)beginningOfDay {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                               fromDate:self];
    return [calendar dateFromComponents:components];
}

- (NSDate *)beginningOfMonth
{
    return [self dateAfterDay:-(int)[self getDay] + 1];
}

- (NSDate *)endOfMonth
{
    return [[[self beginningOfMonth] dateafterMonth:1] dateAfterDay:-1];
}

//返回当前周的周末
- (NSDate *)endOfWeek {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:(7 - [weekdayComponents weekday])];
    NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    
    return endOfWeek;
}

+ (NSString *)dateFormatString {
    
    return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString {
    
    return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString {
    
    return @"yyyy-MM-dd HH:mm:ss";
}

// preserving for compatibility
+ (NSString *)dbFormatString {
    
    return [NSDate timestampFormatString];
}

// convert 20120318 to 2012-03-18
+ (NSString *)ConvertStrToStr:(NSString *) str {
    
    NSString *fmt = @"yyyyMMdd";
    
    NSDate *date = [NSDate dateFromString:str withFormat:fmt];
    
    fmt = @"yyyy-MM-dd";
    
    NSString *tmp = [NSDate stringFromDate:date withFormat:fmt];
    
    return tmp;
}


+ (NSString *)ConvertDateTimeStrToStr:(NSString *) str {
    
    NSString *fmt = @"yyyyMMddHHmmss";
    
    NSDate *date = [NSDate dateFromString:str withFormat:fmt];
    
    fmt = @"yyyy-MM-dd";
    
    NSString *tmp = [NSDate stringFromDate:date withFormat:fmt];
    
    return tmp;
}

+ (NSString *) NowString {
    
    NSDate *today = [NSDate date];
    
    NSString *fmt = @"yyyyMMdd";
    
    NSString *tmp = [NSDate stringFromDate:today withFormat:fmt];
    
    return tmp;
}

+ (NSString *) AfterDateString:(int)year Month:(int) month Day:(int) day {
    
    
    NSDate *dateAfterDay = [NSDate AfterDate:year Month: month Day:day];
    
    NSString *fmt = @"yyyyMMdd";
    
    NSString *tmp = [NSDate stringFromDate:dateAfterDay withFormat:fmt];
    
    return tmp;
}

+ (NSDate *)AfterDate:(int)year Month:(int) month Day:(int) day {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *add = [[NSDateComponents alloc] init];
    
    [add setYear:year];
    [add setMonth:month];
    [add setDay:day];
    
    NSDate *today = [NSDate date];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:add toDate:today options:0];
    
    return dateAfterDay;
}

+ (NSDate *)AfterDate:(int)year Month:(int) month Day:(int) day curr:(NSDate *) curr {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *add = [[NSDateComponents alloc] init];
    
    [add setYear:year];
    [add setMonth:month];
    [add setDay:day];
    
    NSDate *today = curr;
    NSDate *dateAfterDay = [calendar dateByAddingComponents:add toDate:today options:0];
    
    return dateAfterDay;
}

+ (int) DateComp:(NSString *) str {
    
    NSDate *today = [NSDate date];
    
    NSString *fmt = @"yyyyMMdd";
    
    NSDate *date = [NSDate dateFromString:str withFormat:fmt];
    
    return [today compare:date];
}

+ (int) DateComp:(NSString *) str curr:(NSString *) curr {

    NSDate *today = [NSDate dateFromString:curr withFormat:@"yyyyMMdd"];
    
    NSString* fmt = @"yyyyMMdd";
    
    NSDate* date = [NSDate dateFromString:str withFormat:fmt];
    
    return [today compare:date];
}

- (NSString *)toStrForShow
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *retSTR = [dateFormatter stringFromDate:self];
    
    return retSTR;
}

- (NSString *)toStrForXml
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString* retSTR = [dateFormatter stringFromDate:self];
    return retSTR;
}

+ (NSDate *)getLocalDate;   //获取本地日期(北京时间)
{
    NSDate *oldDate = [NSDate date];
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT]; //获取当前时区，并转换为秒差
    NSDate  *newDate = [oldDate dateByAddingTimeInterval:timeZoneOffset];
    return newDate;
}

//传入两个字符串 计算日期差
+ (long)getBeginDate:(NSString *)beginDate toEnDate:(NSString *)enDate {
    
    long d = 0;
    NSString *begin = [beginDate toStrForShow];
    NSString *end    = [enDate toStrForShow];
    
    //起始时间段
    NSDateFormatter *matter1 = [[NSDateFormatter alloc] init];
    [matter1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [matter1 setTimeZone:timeZone];
    NSString *str1 = begin;
    if (begin.length == 10) {
        str1 = [NSString stringWithFormat:@"%@ 00:00:00", begin];
    }
    NSDate *date1 = [matter1 dateFromString:str1];
    
    //结束时间段
    NSDateFormatter *matter2  = [[NSDateFormatter alloc] init];
    [matter2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [matter2 setTimeZone:timeZone];
    NSString *str2 = end;
    if (end.length == 10) {
        str2 = [NSString stringWithFormat:@"%@ 00:00:00", end];
    }
    NSDate *date2 = [matter2 dateFromString:str2];
    
    long dd = [date2 timeIntervalSince1970] - [date1 timeIntervalSince1970];
    long day = dd / 86400;
    NSComparisonResult result = NSOrderedSame;
    result = [date1 compare:date2];
    if (day > 0 && result == NSOrderedAscending) {
        
        //结束时间比起始时间 晚
        d = day;
    }
    else if (day == 0 && result == NSOrderedSame) {
        //结束时间等于起始时间
        d = 0;
    }
    else if (day < 0 && result == NSOrderedDescending) {
        //结束时间小于起始时间
        d = -1;
    }    
    return d;
}

+ (NSInteger)getDaysWithYear:(NSInteger)year month:(NSInteger)month {
    
    switch (month) {
        case 1:
            return 31;
            break;
        case 2:
            if (year % 400 == 0 || (year % 100 != 0 && year % 4 == 0)) {
                return 29;
            } else {
                return 28;
            }
            break;
        case 3:
            return 31;
            break;
        case 4:
            return 30;
            break;
        case 5:
            return 31;
            break;
        case 6:
            return 30;
            break;
        case 7:
            return 31;
            break;
        case 8:
            return 31;
            break;
        case 9:
            return 30;
            break;
        case 10:
            return 31;
            break;
        case 11:
            return 30;
            break;
        case 12:
            return 31;
            break;
        default:
            return 0;
            break;
    }
}

@end
