//
//  NSDictionary+Uicode.m
//  FotileCSS
//
//  Created by ojbk on 2018/7/31.
//  Copyright © 2018年 康振超. All rights reserved.
//

#import "NSDictionary+Uicode.h"

@implementation NSDictionary (Uicode)

- (NSString *)my_description {
    
    NSString *desc = [self my_description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}

@end
