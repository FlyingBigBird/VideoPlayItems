//
//  NSDate-Helper.h
//  FotileCSS
//
//  Created by ojbk on 2018/8/13.
//  Copyright © 2018年 BaoBao. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSDate (Helpers)

- (NSString *)getFormatYearMonthDay;
- (NSString *)getFormatHourMinuteSecond;
- (int )getWeekNumOfMonth;
- (int )getWeekOfYear;
- (NSDate *)dateAfterDay:(int)day;    //几天后的时间
- (NSDate *)dateafterMonth:(int)month; //几月后的时间， 几月前的时间则传入month为 负数即可
- (NSUInteger)getDay;
- (NSUInteger)getMonth;
- (NSUInteger)getYear;
- (int)getHour;
- (int)getMinute;
- (int)getSecond;
- (int)getHour:(NSDate *)date;
- (int)getMinute:(NSDate *)date;
- (NSUInteger)daysAgo; // 计算间隔多少天
- (NSUInteger)daysAgoWithDate: (NSDate *)date;

- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)getLocalDate;   //获取本地日期(北京时间) added by Alex Song
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;

- (NSString *)string;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfMonth;
- (NSDate *)endOfMonth;
- (NSDate *)beginningOfDay;
- (NSDate *)endOfWeek;

+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;

// convert 20120318 to 2012-03-18
+ (NSString *)ConvertStrToStr:(NSString*) str;

// convert 20120318 to 2012-03-18
+ (NSString *)ConvertDateTimeStrToStr:(NSString*) str;

- (NSString *)toStrForShow; //to 2012-03-18
- (NSString *)toStrForXml; //to 20120318

+ (NSString *)NowString;
+ (NSString *)AfterDateString:(int)year Month:(int) month Day:(int) day;

+ (NSDate *)AfterDate:(int)year Month:(int) month Day:(int) day;
+ (NSDate *)AfterDate:(int)year Month:(int) month Day:(int) day curr:(NSDate*) curr;

+ (int) DateComp:(NSString *) str;
+ (int) DateComp:(NSString *) str curr:(NSString*) curr;

//传入两个字符串 计算日期差
+ (long)getBeginDate:(NSString *)beginDate toEnDate:(NSString *)enDate;

//获取当前年月的天数
+ (NSInteger)getDaysWithYear:(NSInteger)year month:(NSInteger)month;

@end
