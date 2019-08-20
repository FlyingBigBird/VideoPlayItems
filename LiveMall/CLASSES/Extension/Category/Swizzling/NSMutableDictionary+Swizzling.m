//
//  NSMutableDictionary+Swizzling.m
//  FotileCSS
//
//  Created by ojbk on 2018/9/18.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import "NSMutableDictionary+Swizzling.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (Swizzling)

+ (void)load {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        [objc_getClass("__NSDictionaryM") systemSelector:@selector(setValue:forKey:) swizzledSelector:@selector(exchange_setValue:forKey:) error:nil];
        
        [objc_getClass("__NSDictionaryM") systemSelector:@selector(setObject:forKey:) swizzledSelector:@selector(exchange_setObject:forKey:) error:nil];
        
        [objc_getClass("__NSDictionaryM") systemSelector:@selector(removeObjectForKey:) swizzledSelector:@selector(exchange_removeObjectForKey:) error:nil];
    });
}

- (void)exchange_setValue:(id)value forKey:(NSString *)key {
    
    if (!key) {
        
        SLog(@"key为nil");
        return;
    }
    if (!value) {
        
        SLog(@"value为nil");
        return;
    }
    [self exchange_setValue:value forKey:key];
}

- (void)exchange_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    
    if (aKey == nil) {
        
        SLog(@"key为nil");
        return ;
    }
    
    if (!anObject) {
        
        SLog(@"object为nil");
        return ;
    }
    [self exchange_setObject:anObject forKey:aKey];
}

- (void)exchange_removeObjectForKey:(id)aKey {
    
    if (!aKey) {
        
        SLog(@"key为nil");
        return;
    }
    [self exchange_removeObjectForKey:aKey];
}

@end
