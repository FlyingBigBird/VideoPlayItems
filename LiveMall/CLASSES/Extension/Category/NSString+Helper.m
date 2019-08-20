//
//  NSString+Helper.m
//  FotileCSS
//
//  Created by ojbk on 2018/8/29.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import "NSString+Helper.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CTFramesetter.h>
#import <CoreText/CTFont.h>
#import <CoreText/CTStringAttributes.h>

@implementation NSString (Helper)

+ (CGFloat)floatForDevice:(CGFloat)floatNum
{
    if (iPhone6plus)
    {
        floatNum *= ZoomValue;
    }
    return floatNum;
}

+ (NSString *)getUcidCode
{
    NSString *ucid = @"";
    if (IsStrEmpty(ucid))
    {
        
    }
    return ucid;
}

+ (NSString *)getSecodeCode
{
    NSString *secode = @"";
    if (IsStrEmpty(secode))
    {
        
    }
    return secode;
}

+ (NSString *)getTokenCode
{
    NSString *token = @"";
    if (IsStrEmpty(token))
    {
        
    }
    return token;
}

+ (NSString *)getUrlStringWithString:(NSString *)urlString
{
    NSString *newUrlString = @"";
    urlString = [NSString stringWithFormat:@"%@",urlString];
    
    if ([urlString hasPrefix:@"http"])
    {
        newUrlString = urlString;
    } else
    {
        if ([urlString hasPrefix:@"/"])
        {
            newUrlString = [NSString stringWithFormat:@"%@%@",HostDomainCode,urlString];
        } else
        {
            newUrlString = [NSString stringWithFormat:@"%@/%@",HostDomainCode,urlString];
        }
    }
    
    return newUrlString;
}

+ (NSString *)filterStringEmpty:(NSString *)currentString
{
    NSString *filString = @"";
    
    NSString *getNewString = [NSString stringWithFormat:@"%@",currentString];
    if (IsStrEmpty(getNewString) || [getNewString isEqualToString:@"(null)"])
    {
        filString = @"";
    } else
    {
        filString = [NSString stringWithFormat:@"%@",getNewString];
    }
    return filString;
}

+ (NSString *)getCurrentLocationInfo
{
    NSString *localInfo = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"localInfo1"]];
    if (IsStrEmpty(localInfo))
    {
        localInfo = @"";
    }
    return localInfo;
}

- (NSString *)moneyString {
    
    NSString *strTemp  = [self stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *strTrimmed = [strTemp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (strTrimmed.length == 0) {
        return @"0.00";
    }
    if ([strTrimmed isEqualToString:@"."]) {
        return @"0.00";
    }
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setMaximumFractionDigits:2];
    [f setMinimumFractionDigits:2];
    NSNumber *number = [f numberFromString:strTrimmed];
    if (number == nil) {
        return @"0.00";
    }
    
    NSString *strRes = [f stringFromNumber:number];
    
    return strRes;
}

- (NSString *)toMoneyStr {
    
    NSString *source = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (source.length == 0)
        return nil;
    
    if ([source rangeOfString:@","].location != NSNotFound)
    {
        return source;
    }
    if (source.floatValue == 0)
    {
        return @"0.00";
    }
    //加减符号
    NSString  * strAddOrDelete  = [source substringToIndex:1];
    if ([strAddOrDelete isEqualToString:@"-"] || [strAddOrDelete isEqualToString:@"+"]) {
        
        source = [source substringFromIndex:1];
    } else {
        strAddOrDelete = nil;//表示没有加减符号
    }
    
    //前面有0而0后不是小数点，则删除
    while ([[source substringToIndex:1] isEqualToString:@"0"] &&
           (![[source substringWithRange:NSMakeRange(1,1)] isEqualToString:@"."]))
    {
        source = [source substringFromIndex:1];
    }
    
    //只保留到小数点后两位～～
    NSUInteger location = [source rangeOfString:@"."].location;
    
    if (location != NSNotFound) {
        
        //NSUInteger jjj = source.length-3;注意length是无符号整形，没负数
        if ( location+3 < source.length)
        {
            source = [source substringToIndex:(location+3)];
        }
    }
    
    //float so = sour.floatValue;
    NSMutableString  *text = [[NSMutableString alloc] init];
    [text setString:source];
    
    NSInteger index = 0;//text.length-3;//开始位置
    
    NSRange range = [text rangeOfString:@"."];
    if (range.location == NSNotFound)
    {
        [text appendString:@".00"];
        index = text.length - 6;
    }
    else
    {
        index = range.location-3;
    }
    
    for (NSInteger i=index; i>0 ;)
    {
        [text insertString:@"," atIndex:i];
        i -= 3;
    }
    //如果值是 .78的格式(第一位是小数点)  前加0
    [[text substringToIndex:1] isEqualToString:@"."];
    if ( [[text substringToIndex:1] isEqualToString:@"."] )
    {
        [text insertString:@"0" atIndex:0];
    }
    
    //如果值是 1.的格式（最后一位是小数点）后加00
    if ([[text substringFromIndex:text.length - 1] isEqualToString:@"."]) {
        [text appendString:@"00"];
    }
    
    //如果值是 1.0 、1.1的格式 (倒数第二位是小数点)后加0
    if ([[text substringWithRange:NSMakeRange(text.length - 2, 1)] isEqualToString:@"."]) {
        [text appendString:@"0"];
    }
    
    if (strAddOrDelete)//如果有加减符号  加上
    {
        [text insertString:strAddOrDelete atIndex:0];
    }
    
    return text;
}

- (NSString *)toStrForShow {
    
    if (self.length == 0 || [self isEqualToString:@"－－"] || [self isEqualToString:@"--"] || [self isEqualToString:@"00000000"] || [self isEqualToString:@"not find"])
        return self;
    
    
    if (self.length == 6)
    {
        NSMutableString  *tempStr = [[NSMutableString alloc] init];
        [tempStr setString:self];
        [tempStr insertString:@":" atIndex:4];
        [tempStr insertString:@":" atIndex:2];
        return tempStr;
    }
    else if (self.length != 14)
    {
        NSDate  *date = [self toDate];
        return [date toStrForShow];
    }
    else
    {
        NSMutableString  *tempStr = [[NSMutableString alloc] init];
        [tempStr setString:self];
        [tempStr insertString:@":" atIndex:12];
        [tempStr insertString:@":" atIndex:10];
        [tempStr insertString:@" " atIndex:8];
        [tempStr insertString:@"-" atIndex:6];
        [tempStr insertString:@"-" atIndex:4];
        return tempStr;
    }
}

- (NSString *)toStrForXml {
    
    if (self.length == 0 || [self isEqualToString:@"－－"] || [self isEqualToString:@"--"] )
        return self;
    NSDate *date = [self toDate];
    return [date toStrForXml];
}

- (NSDate *)toDate {
    
    NSDate *retDate = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    NSString *aString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (aString == nil || 0 == [aString length])
    {
        dateFormatter = nil;
    }
    else if ( aString.length == 8 && [aString rangeOfString:@"-"].length == 0)
    {
        [dateFormatter setDateFormat:@"yyyyMMdd"];
    }
    else if (aString.length == 10 && [aString rangeOfString:@"-"].length != 0 )
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    else if (aString.length == 14 && [aString rangeOfString:@"-"].length == 0)
    {
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    }
    else if (aString.length == 19 && [aString rangeOfString:@"-"].length != 0)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    retDate = [dateFormatter dateFromString:aString];
    return retDate;
}

+ (NSString *)convertToJsonData:(NSDictionary *)dict {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    if (!jsonData) {
        
    } else {
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

+ (CGFloat)getNewHeightWithOriginWidth:(CGFloat)OrginWidth andOriginHeight:(CGFloat)OrginHeight andNewWidth:(CGFloat)newWidth
{
    CGFloat newHeight = OrginHeight *newWidth / OrginWidth;
    return newHeight;
}

+ (CGFloat)getNewWidthWithOriginWidth:(CGFloat)OrginWidth andOriginHeight:(CGFloat)OrginHeight andNewHeight:(CGFloat)newHeight
{
    CGFloat newWidth = OrginWidth *newHeight / OrginHeight;
    return newWidth;
}

//汉字转拼音
+ (NSString *)transformPinYinWithString:(NSString *)chinese {
    
    NSString  *pinYinStr = [NSString string];
    
    if (chinese.length){
        
        NSMutableString *pinYin = [[NSMutableString alloc]initWithString:chinese];
        
        //1.先转换为带声调的拼音
        if (CFStringTransform((__bridge CFMutableStringRef)pinYin, NULL, kCFStringTransformMandarinLatin, NO)) {
            
        }
        
        //2.再转换为不带声调的拼音
        if (CFStringTransform((__bridge CFMutableStringRef)pinYin, NULL, kCFStringTransformStripDiacritics, NO)) {
            
        }
        
        //3.去除掉首尾的空白字符和换行字符
        pinYinStr = [pinYin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //4.去除掉其它位置的空白字符和换行字符
        pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return pinYinStr;
}

+ (NSMutableAttributedString *)setAttributeString:(NSString *)textString WithRange:(NSString *)rangeString andFontSize:(CGFloat)fontSize andLineSpacing:(CGFloat)lineSpacing andForegroundColor:(UIColor *)foregroundColor
{
    NSString *attS = [NSString stringWithFormat:@"%@",textString];
    
    NSMutableAttributedString *attributeS = [[NSMutableAttributedString alloc] initWithString:attS];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:foregroundColor, NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle};
    
    [attributeS addAttributes:attributes range:[attS rangeOfString:rangeString]];
    
    return attributeS;
}


+ (CGSize)labelWidthWithText:(NSString *)text fondSize:(float)size width:(CGFloat)width
{
    NSDictionary *send = @{NSFontAttributeName: [UIFont systemFontOfSize:size]};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(width, 0)
                                         options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:send context:nil].size;
    
    return textSize;
}
+ (CGSize)optimumSize:(NSMutableAttributedString *)attrStringText forConstrainnt:(CGSize)constraint{
    
    CFMutableAttributedStringRef attrString = (__bridge CFMutableAttributedStringRef)attrStringText;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFRange range;
    CGSize opetionSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [attrStringText length]), nil, constraint, &range);
    return opetionSize;
}
+ (CGSize)labelHeightWithText:(NSString *)text fondSize:(float)size height:(CGFloat)height
{
    NSDictionary *send = @{NSFontAttributeName: [UIFont systemFontOfSize:size]};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(0, height)
                                         options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:send context:nil].size;
    
    return textSize;
}

+ (NSString *)getMoneyStringWithMoneyNumber:(double)money format:(NSString *)moneyFormat
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    // 设置格式
    // ###,##0.00;
    [numberFormatter setPositiveFormat:[NSString stringWithFormat:@"%@",moneyFormat]];// 四舍五入...
    
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:money]];
    
    return [NSString stringWithFormat:@"%@",[formattedNumberString stringByReplacingOccurrencesOfString:@".00" withString:@""]];
}

+ (NSString *)transformDateToTimeString:(NSDate *)currentDate dateFormat:(NSString *)dateFormat
{
    // 格式化时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[NSString stringWithFormat:@"%@",dateFormat]];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    NSString *timeString = [formatter stringFromDate:currentDate];
    
    return timeString;
}

+ (NSString *)setTimeDateWithTimeString:(NSString *)timeString withFomat:(NSString *)format
{
    // 格式化时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateFormat:format];
    
    // 毫秒值转化为秒(毫秒则除以一千否则不除)...
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue] / 1000];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)weekdayStringFromDate:(NSString *)inputString
{
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    // 毫秒值转化为秒
    NSDate *inputDate = [NSDate dateWithTimeIntervalSince1970:[inputString doubleValue] ];
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone:timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

+ (NSString *)weekdayStringFromInputDate:(NSDate *)inputDate
{
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    //    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone:timeZone];
    
    //    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}


+ (NSString *)dataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        
    } else {
        jsonString = [[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    return jsonString;
}

+ (NSString *)transformDateStringToTimeString:(NSString *)strSrcDate
                                   dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    fmt.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];;
    
    NSDate *srcDate=[fmt dateFromString:strSrcDate];
    
    NSString *getTimeStr = [self transformDateToTimeString:srcDate dateFormat:dateFormat];
    return getTimeStr;
}
+ (NSString *)contentTypeForImageData:(NSData *)data {
    
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

// 转义数组...
+ (NSString *)jsonStringWithArr:(NSArray *)dataArr
{
    NSString *jsonStr = @"";
    for (int i = 0; i < dataArr.count; i++)
    {
        NSString *getObj = [NSString stringWithFormat:@"%@",dataArr[i]];
        NSString *jsonObj = [NSString stringWithFormat:@"\"%@\"",getObj];
        if (i == 0)
        {
            jsonStr = jsonObj;
        } else
        {
            NSString *appendStr = [NSString stringWithFormat:@",%@",jsonObj];
            jsonStr = [jsonStr stringByAppendingString:appendStr];
        }
    }
    return [NSString stringWithFormat:@"[%@]",jsonStr];
}

+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

- (BOOL)judgePassWordLegal:(NSString *)pass
{
    //  正则表达式判断是否同时包含字母和数字
    NSString *regex = @"\\d{0,}([a-z]{1,}\\d{1,}){1,}[a-z]{0,}";
    regex = @"((?=.  *\\d)(?=.  *[a-zA-Z]))[\\da-zA-Z]  *";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [predicate evaluateWithObject:pass];;
}

+ (NSString *)timerTansformFormData:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString  *beginStr = [self transformDateToTimeString:[NSDate date] dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *beginDate=[formatter dateFromString:beginStr];
    NSTimeInterval beginTime = [beginDate timeIntervalSince1970];
    
    NSString *getTime = [NSString stringWithFormat:@"%.0f", beginTime];
    
    return getTime;
}

//判断是否有中文
+ (BOOL)hasChinese:(NSString *)str {
    
    for (int i = 0; i < [str length]; i++) {
        
        int a = [str characterAtIndex:i];
        
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}


//计算单行文本行高、支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围
- (CGSize)singleLineSizeWithAttributeText:(UIFont *)font {
  
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef) font.fontName, font.pointSize, NULL);
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    CTParagraphStyleSetting paragraphSettings[1] = { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof (CGFloat), &leading };
    
    CTParagraphStyleRef  paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    CFRange textRange = CFRangeMake(0, self.length);
    
    CFMutableAttributedStringRef string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.length);
    
    CFAttributedStringReplaceString(string, CFRangeMake(0, 0), (CFStringRef) self);
    
    CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont);
    CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(DBL_MAX, DBL_MAX), nil);
    
    CFRelease(paragraphStyle);
    CFRelease(string);
    CFRelease(cfFont);
    CFRelease(framesetter);
    return size;
}

//固定宽度计算多行文本高度，支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围、
- (CGSize)multiLineSizeWithAttributeText:(CGFloat)width font:(UIFont *)font {
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef) font.fontName, font.pointSize, NULL);
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    CTParagraphStyleSetting paragraphSettings[1] = { kCTParagraphStyleSpecifierLineBreakMode, sizeof (CGFloat), &leading };
    
    CTParagraphStyleRef  paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    CFRange textRange = CFRangeMake(0, self.length);
    
    //  Create an empty mutable string big enough to hold our test
    CFMutableAttributedStringRef string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.length);
    
    //  Inject our text into it
    CFAttributedStringReplaceString(string, CFRangeMake(0, 0), (CFStringRef) self);
    
    //  Apply our font and line spacing attributes over the span
    CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont);
    CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(width, DBL_MAX), nil);
    
    CFRelease(paragraphStyle);
    CFRelease(string);
    CFRelease(cfFont);
    CFRelease(framesetter);
    
    return size;
}

//计算单行文本宽度和高度，返回值与UIFont.lineHeight一致，支持开头空格计算。包含emoji表情符的文本行高返回值有较大偏差。
- (CGSize)singleLineSizeWithText:(UIFont *)font{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (NSString *) md5 {
    const char *str = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( str, (CC_LONG)strlen(str), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

- (NSURL *)urlScheme:(NSString *)scheme {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:self] resolvingAgainstBaseURL:NO];
    components.scheme = scheme;
    return [components URL];
}

+ (NSString *)formatCount:(NSInteger)count {
    if(count < 10000) {
        return [NSString stringWithFormat:@"%ld",(long)count];
    }else {
        return [NSString stringWithFormat:@"%.1fw",count/10000.0f];
    }
}

+(NSDictionary *)readJson2DicWithFileName:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return dic;
}






@end
