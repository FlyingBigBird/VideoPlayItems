//
//  BasicKeychainHelper.m
//  FotileCSS
//
//  Created by ojbk on 2018/8/13.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import "BasicKeychainHelper.h"

NSString *const kKeyUserDefaultName = @"Fotile.com";
NSString *const kKeyUUID = @"UUID";

@interface BasicKeychainHelper ()
{
    NSUserDefaults *_defaults;
}

@end

@implementation BasicKeychainHelper

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        if (iOS7_OR_LATER) {
            
            _defaults = [[NSUserDefaults alloc] initWithSuiteName:kKeyUserDefaultName];
        }
    }
    return self;
}

- (void)setUUID:(NSString *)uuid {
    
    if (_defaults == nil) {
        return;
    }
    
    [_defaults setObject:uuid forKey:kKeyUUID];
}

- (NSString *)uuid {
    
    if (_defaults == nil) {
        return nil;
    }
    
    return [_defaults objectForKey:kKeyUUID];
}

@end
