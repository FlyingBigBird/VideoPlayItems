//
//  DeviceHelper.h
//  FotileCSS
//
//  Created by ojbk on 2018/8/13.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceHelper : NSObject

+ (NSString *)judgeDevice;

+ (NSString *)uuid;

+ (NSString *)resetUUID;

@end
