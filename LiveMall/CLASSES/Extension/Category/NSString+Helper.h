//
//  NSString+Helper.h
//  FotileCSS
//
//  Created by ojbk on 2018/8/29.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)

+ (CGFloat)floatForDevice:(CGFloat)floatNum;

+ (NSString *)getUcidCode;

+ (NSString *)getSecodeCode;

+ (NSString *)getTokenCode;

+ (NSString *)getUrlStringWithString:(NSString *)urlString;

+ (NSString *)filterStringEmpty:(NSString *)currentString;

+ (NSString *)getCurrentLocationInfo;

//金额格式化 --->0.00
- (NSString *)moneyString;

//金额转换 带","分割 备用（在多语言环境不为中文的时候）
- (NSString *)toMoneyStr;

//把20091008 或者 2009-10-08 转成 NSDate
- (NSDate *)toDate;

//转成yyyy-MM-dd 用于显示  或者yyyy-MM-ddhh:mm:ss
- (NSString *)toStrForShow;

//转成yyyyMMdd 用于报文
- (NSString *)toStrForXml;

//字典转json
+ (NSString *)convertToJsonData:(NSDictionary *)dict;

// 获取新高度
+ (CGFloat)getNewHeightWithOriginWidth:(CGFloat)OrginWidth andOriginHeight:(CGFloat)OrginHeight andNewWidth:(CGFloat)newWidth;

// 获取新宽度...
+ (CGFloat)getNewWidthWithOriginWidth:(CGFloat)OrginWidth andOriginHeight:(CGFloat)OrginHeight andNewHeight:(CGFloat)newHeight;

//汉字转拼音 默认小写
+ (NSString *)transformPinYinWithString:(NSString *)chinese;

/**
 AttributedStringA
 
 @param textString 原字符串
 @param rangeString 需要改变字符串
 @param fontSize 字号
 @param lineSpacing 字号间隙
 @param foregroundColor 字体颜色
 @return 新AttributedString
 */
+ (NSMutableAttributedString *)setAttributeString:(NSString *)textString WithRange:(NSString *)rangeString andFontSize:(CGFloat)fontSize andLineSpacing:(CGFloat)lineSpacing andForegroundColor:(UIColor *)foregroundColor;

/**
 自定义控件高度
 
 @param text 显示文字
 @param size 字体大小
 @param width 控件宽度
 @return 字体占的size...
 */
+ (CGSize)labelWidthWithText:(NSString *)text fondSize:(float)size width:(CGFloat)width;

/**
 自定义控件宽度
 
 @param text 显示文字
 @param size 字体大小
 @param height 控件高度
 @return 字体占的size...
 */
+ (CGSize)labelHeightWithText:(NSString *)text fondSize:(float)size height:(CGFloat)height;

/**
 转换金额
 
 @param money 转换后金额
 @param moneyFormat 金额类型
 @return 金额数量
 */
+ (NSString *)getMoneyStringWithMoneyNumber:(double)money format:(NSString *)moneyFormat;

/**
 日期返回字符串
 
 @param currentDate 当前日期
 @param dateFormat 日期格式
 @return 转换后的字符串
 */
+ (NSString *)transformDateToTimeString:(NSDate *)currentDate
                             dateFormat:(NSString *)dateFormat;

/**
 时间戳转化时间
 
 @param timeString 时间戳
 @param format 格式
 @return 转化后时间格式
 */
+ (NSString *)setTimeDateWithTimeString:(NSString *)timeString
                              withFomat:(NSString *)format;

/**
 时间戳转周
 */
+ (NSString*)weekdayStringFromDate:(NSString *)inputString;

/**
 NSDate戳转周
 */
+ (NSString *)weekdayStringFromInputDate:(NSDate *)inputDate;

/**
 日期转时间戳

 @param date 日期
 @return 时间戳
 */
+ (NSString *)timerTansformFormData:(NSDate *)date;

/**
 *  NSDictionary转Json...
 */
+ (NSString *)dataTOjsonString:(id)object;

+ (NSString *)transformDateStringToTimeString:(NSString *)strSrcDate
                                   dateFormat:(NSString *)dateFormat;

/**
 通过图片Data数据第一个字节 来获取图片扩展名

 @param data imageData
 @return 图片拓展名
 */
+ (NSString *)contentTypeForImageData:(NSData *)data;

// 转义数组...
+ (NSString *)jsonStringWithArr:(NSArray *)dataArr;

// Json字符串解析
+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;


/*
 *  判断用户输入的密码是否符合规范，符合规范的密码要求：
 *  密码中必须同时包含数字和字母
 */
- (BOOL)judgePassWordLegal:(NSString *)pass;

/*
 *  判断是否有中文
 */
+ (BOOL)hasChinese:(NSString *)str;

- (NSURL *)urlScheme:(NSString *)scheme;

- (CGSize)singleLineSizeWithText:(UIFont *)font;

- (CGSize)singleLineSizeWithAttributeText:(UIFont *)font;

+ (NSString *)formatCount:(NSInteger)count;


/**
 准确获取字符串宽高...

 @param attrStringText 内容
 @param constraint 控件大小
 @return 字符串宽高
 */
+ (CGSize)optimumSize:(NSMutableAttributedString *)attrStringText forConstrainnt:(CGSize)constraint;


@end
