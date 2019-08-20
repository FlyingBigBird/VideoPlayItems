//
//  BasicDefine.h
//  直播商城
//
//  Created by BaoBaoDaRen on 2019/6/20.
//  Copyright © 2019 Boris. All rights reserved.
//

#ifndef BasicDefine_h
#define BasicDefine_h

// 屏幕rect
#define ScreenFrame [UIScreen mainScreen].bounds

/**
 *define:获取屏幕的宽
 */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

/**
 *define:获取屏幕的高
 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// appdelegate
#define APP_Delegate (AppDelegate*)[UIApplication sharedApplication].delegate

#define SafeAreaTopHeight ((SCREEN_HEIGHT >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"] ? 88 : 64)
#define SafeAreaBottomHeight ((SCREEN_HEIGHT >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"]  ? 30 : 0)

#define BackGroundColor @"#F8F7FC"
#define GeneralTextColor @"#333333"
#define SeparatorLineColor @"#e4e4e4"
#define BackGreenColor @"#2f6f6f"
#define BackBlackColor @"#2f2f2f"

#define RGBA(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
//#define HEX_C(color) [UIColor colorWithHexString:@"%@",color]


#define GDeepGrayColor [UIColor colorWithHexString:@"#666666"]
#define GGrayColor [UIColor colorWithHexString:@"#999999"]
#define GClearColor [UIColor clearColor]
#define GBlackColor [UIColor colorWithHexString:@"#2F2F2F"]
#define GWhiteColor [UIColor colorWithHexString:@"#FFFFFF"]
#define GBackGroundColor [UIColor colorWithHexString:@"#1B696D"]
#define GBoarderColor [UIColor colorWithHexString:@"#CCCCCC"]
#define GTableBGColor [UIColor colorWithHexString:@"#F3F4F6"]
#define GColorGray  [UIColor grayColor]


#define GPlaceHolder [UIImage imageNamed:@"placeHolder"]

// 适配比例，一般为1：1.25...
#define ZoomValue 1.25f

// 强弱引用...
#define WeakSelf(type)  __weak typeof(type) weak##type = type; // weak
#define StrongSelf(type)  __strong typeof(type) type = weak##type; // strong

// 由角度转换弧度
#define DegreesToRadian(x) (M_PI * (x) / 180.0)
// 由弧度转换角度
#define RadianToDegrees(radian) (radian*180.0)/(M_PI)

// 获取图片
#define GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

// 获取temp
#define PathTemp NSTemporaryDirectory()

// 获取沙盒 Document
#define PathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
// 获取沙盒 Cache
#define PathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
// GCD代码只执行一次
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

// 选择Font
#define FontL(s)             [UIFont systemFontOfSize:s weight:UIFontWeightLight]
#define FontR(s)             [UIFont systemFontOfSize:s weight:UIFontWeightRegular]
#define FontB(s)             [UIFont systemFontOfSize:s weight:UIFontWeightBold]
#define FontT(s)             [UIFont systemFontOfSize:s weight:UIFontWeightThin]
#define Font(s)              [UIFont systemFontOfSize:s]
#define CUFont(s)            [UIFont fontWithName:@"Helvetica-Bold" size:s];

// FORMAT
#define FORMAT(f, ...)      [NSString stringWithFormat:f, ## __VA_ARGS__]

// 在主线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

// 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);

// 通知
#define NOTIF_ADD(n, f)     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(f) name:n object:nil]
#define NOTIF_POST(n, o, u)    [[NSNotificationCenter defaultCenter] postNotificationName:n object:o userInfo:u]
#define NOTIF_REMV()        [[NSNotificationCenter defaultCenter] removeObserver:self]

//加入这个宏，可以省略所有 mas_ （除了mas_equalTo）
#define MAS_SHORTHAND

//加入这个宏，那么mas_equalTo就和equalTo一样的了
#define MAS_SHORTHAND_GLOBALS

//上面的两个宏一定要在这句之前
//#import "Masonry.h"

/**
 *define:iOS 7.0的版本判断
 */
#define iOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending)

/**
 *define:iOS 8.0的版本判断
 */
#define iOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)

/**
 *define:iOS 9.0的版本判断
 */
#define iOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"9" options:NSNumericSearch] != NSOrderedAscending)

/**
 *define:iOS 10.0的版本判断
 */
#define iOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"10" options:NSNumericSearch] != NSOrderedAscending)

/**
 *define:iOS 11.0的版本判断
 */
#define iOS11_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"11" options:NSNumericSearch] != NSOrderedAscending)

/**
 *define:iOS 12.0的版本判断
 */
#define iOS12_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"12" options:NSNumericSearch] != NSOrderedAscending)

/**
 *define:屏幕的宽高比
 */
#define CURRENT_SIZE(_size) _size / 375.0 * SCREEN_WIDTH

/**
 *  设备判断...
 */
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define is_Pad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !is_Pad : NO)
//判断iPhoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !is_Pad : NO) || ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1624), [[UIScreen mainScreen] currentMode].size) && !is_Pad : NO)
//判断iPhoneXsMax
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !is_Pad : NO)

//判断iPhoneX所有系列
#define ISIPhoneXSeries (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max)
#define StatusBar_H (ISIPhoneXSeries ? 44.0 : 20.0)
#define NavBar_H         44
#define TabBar_H  (ISIPhoneXSeries ? 83.0 : 49.0)

#define iPad ([[UIScreen mainScreen] currentMode].size.width/[[UIScreen mainScreen] currentMode].size.height>0.7)
#define iOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)

#define kNOTSUPPORTCAMERAL @"设备不支持访问相册，请在设置->隐私->相机中进行设置！"
#define kNOTSUPPORTALBUM @"设备不支持访问相册，请在设置->隐私->照片中进行设置！"

#define OPEN_SETTING_PATH [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]

/*
 * iPad调起相机需在主线程完成...
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"]]
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]]
 */

// 字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqualToString:@"(null)"]) || ([(_ref) isEqualToString:@"(Null)"]) || ([(_ref) isEqualToString:@"(NULL)"]) || ([(_ref) isEqualToString:@"(null)"]) || ([(_ref) isEqualToString:@"<null>"]) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isEqualToString:@""]) || ([(_ref) length] == 0))

// 数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) count] == 0))

// 转换ld
#define L(_ref) [NSString stringWithFormat:@"%@",_ref]
#define LInteger(_ref) [NSString stringWithFormat:@"%ld",(long)_ref]
#define LEmpty(_ref) [NSString filterStringEmpty:_ref]

#define UserDefaultKey(_ref) [[NSUserDefaults standardUserDefaults] objectForKey:_ref]
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

/**
 *  解决iOS10+Xcode8 NSLog下打印不全的问题...
 */
#ifdef DEBUG
#define SLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )

#else
#define SLog(format, ...)
#endif

//打印耗时
#define Code_execution_time(...)\
CFAbsoluteTime time = CFAbsoluteTimeGetCurrent(); \
__VA_ARGS__; \
SLog(@"代码行：%d 执行时间为：%lf s", __LINE__, CFAbsoluteTimeGetCurrent() - time);

#define isRetina ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

#define isPad       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kHeight(h)  (isPad ? 768 * (h) / 320.0 : (h))

#define UIColorRGB(r, g, b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0]
#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:((float)((r & 0xFF0000) >> 16)) / 255.0 green:((float)((g & 0xFF00) >> 8)) / 255.0 blue:((float)(b & 0xFF)) / 255.0 alpha:(fa)]
#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define UIColorFromHexA(hex, fa) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:(fa)]

#define ClientNumCode @""

//应用程序当前版本号
#define CurrentVersion ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

//服务器版本
#define ServiceVersion @"ServiceVersion"

//忽略版本
#define IgnoreVersion @"IgnoreVersion"

//忽略版本对应URL
#define UpdateAppURL @"UpdateAppURL"

/**
 * 域名
 * 测试域名:
 * 正式域名:
 @return 调试域名...
 */
#ifdef DEBUG
#define HostDomainCode @""
#else
#define HostDomainCode @""
#endif

#define STATUS_CODE_SUCCESS         @""
#define STATUS_CODE_FAILURE         @""
#define STATUS_CODE_EXPIRED         @""
#define STATUS_CODE_SERVICE_FAILURE @""






#endif /* BasicDefine_h */
