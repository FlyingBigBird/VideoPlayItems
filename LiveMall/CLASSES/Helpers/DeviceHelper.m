//
//  DeviceHelper.h
//  FotileCSS
//
//  Created by ojbk on 2018/8/13.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import "DeviceHelper.h"
#import "sys/utsname.h"
#import "KeychainItemWrapper.h"
#import "BasicKeychainHelper.h"

#define Def_UUID_Tag @"DEF_UUID"

@implementation DeviceHelper

+ (NSString *)judgeDevice {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine
                                                encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])         return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])         return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])         return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"] || [deviceString isEqualToString:@"iPhone3,2"] || [deviceString isEqualToString:@"iPhone3,3"])         return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])         return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"] || [deviceString isEqualToString:@"iPhone5,2"])         return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"] || [deviceString isEqualToString:@"iPhone5,4"])         return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"] || [deviceString isEqualToString:@"iPhone6,2"])         return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,2"])         return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone7,1"])         return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone8,1"])         return @"iPhone 6S";
    if ([deviceString isEqualToString:@"iPhone8,2"])         return @"iPhone 6S Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])         return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"] || [deviceString isEqualToString:@"iPhone9,3"])         return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"] || [deviceString isEqualToString:@"iPhone9,4"])         return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"] || [deviceString isEqualToString:@"iPhone10,4"])        return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"] || [deviceString isEqualToString:@"iPhone10,5"])        return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"] || [deviceString isEqualToString:@"iPhone10,6"])        return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,8"])        return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"])        return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"] || [deviceString isEqualToString:@"iPhone11,6"])        return @"iPhone XS Max";

    //iPod Touch
    if ([deviceString isEqualToString:@"iPod1,1"])           return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])           return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])           return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])           return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])           return @"iPod Touch 5G";
    if ([deviceString isEqualToString:@"iPod7,1"])           return @"iPod Touch 6G";

    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])           return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])           return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])           return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])           return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,5"])           return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])           return @"iPad Mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])           return @"iPad Mini (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])           return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])           return @"iPad 3 (GSM)";
    if ([deviceString isEqualToString:@"iPad3,3"])           return @"iPad 3 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,4"])           return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])           return @"iPad 4 (GSM)";
    if ([deviceString isEqualToString:@"iPad3,6"])           return @"iPad 4 (CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"] || [deviceString isEqualToString:@"iPad4,2"] || [deviceString isEqualToString:@"iPad4,3"])           return @"iPad air";
    if ([deviceString isEqualToString:@"iPad4,4"] || [deviceString isEqualToString:@"iPad4,5"] || [deviceString isEqualToString:@"iPad4,6"])           return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"] || [deviceString isEqualToString:@"iPad4,8"] || [deviceString isEqualToString:@"iPad4,9"])           return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"] || [deviceString isEqualToString:@"iPad5,2"])           return @"iPad mini 4";
    
    if ([deviceString isEqualToString:@"iPad5,3"] || [deviceString isEqualToString:@"iPad5,4"])           return @"iPad air 2";
    
    //Simulator
    if ([deviceString isEqualToString:@"i386"] || [deviceString isEqualToString:@"x86_64"])              return @"Simulator";
    return deviceString;
}

+ (NSString *)buildUUID {
    
    CFUUIDRef  theUUID = CFUUIDCreate(NULL);
    CFStringRef string  = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return  (__bridge_transfer NSString *)string;
}

+ (void)uuid:(NSString *)v {
    
    if (!v) return;
    KeychainItemWrapper *keychain=[[KeychainItemWrapper alloc] initWithIdentifier:Def_UUID_Tag
                                                                      accessGroup:nil];
    [keychain setObject:v forKey:(__bridge id)kSecAttrAccount];
}

+ (NSString *)uuid {
    
    KeychainItemWrapper *keychain=[[KeychainItemWrapper alloc] initWithIdentifier:Def_UUID_Tag
                                                                      accessGroup:nil];
    //清除keychain
    //    [keychain resetKeychainItem];
    NSString *uuidInKeychain = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    NSString *uuidInUserDefaults = [[NSUserDefaults standardUserDefaults] objectForKey:Def_UUID_Tag];
    //1.UUIDInKeychain表示为存到keychain里面的UUID
    //2.UUIDInUserDefaults表示存到NSUserDefaults里面的UUID
    //3.从4.1.2版本开始UUID存在keychain里面了，为了不影响老版本的正常使用先去取NSUserDefaults的UUID，然后把他从在keychain里
    
    if ([uuidInKeychain isEqualToString:@""] || uuidInKeychain == nil) {
        
        //如果UUIDInUserDefaults不为空
        if (uuidInUserDefaults.length != 0) {
            
            uuidInKeychain = uuidInUserDefaults;
        } else {
            
            //创建UUID
            uuidInKeychain = [DeviceHelper buildUUID];
        }
        //存到keychain里面
        [DeviceHelper uuid:uuidInKeychain];
    }
    
    //存到NSUserDefaults里面，keychain只存一次，为防止NSUserDefaults里无值，每次存一次NSUserDefaults
    [[[BasicKeychainHelper alloc] init] setUUID:uuidInKeychain];
    return uuidInKeychain;
}

+ (NSString *)resetUUID {
    
    NSString *tmp = [self buildUUID];
    [self uuid:tmp];
    return tmp;
}

@end

