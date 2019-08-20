
//
//  NSMutableArray+Swizzling.m
//  FotileCSS
//
//  Created by ojbk on 2018/9/18.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import "NSMutableArray+Swizzling.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Swizzling)

+ (void)load {
    
    [super load];
    
    //无论怎样 都要保证方法只交换一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        @autoreleasepool {
            
            //交换NSMutableArray中objectAtIndex方法
            [objc_getClass("__NSArray0") systemSelector:@selector(objectAtIndex:) swizzledSelector:@selector(emptyObjectIndex:) error:nil];
            
            [objc_getClass("__NSArrayM") systemSelector:@selector(objectAtIndex:) swizzledSelector:@selector(exchange_objectAtIndex:) error:nil];
            
            //交换NSMutableArray中objectAtIndexedSubscript方法
            [objc_getClass("__NSArrayM") systemSelector:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(exchange_objectAtIndexedSubscript:) error:nil];
            
            //交换NSMutableArray中addObject方法
            [objc_getClass("__NSArrayM") systemSelector:@selector(addObject:) swizzledSelector:@selector(exchange_addObject:) error:nil];
            
            //交换NSMutableArray中insertObject:atIndex:方法
            [objc_getClass("__NSArrayM") systemSelector:@selector(insertObject:atIndex:) swizzledSelector:@selector(exchange_insertObject:atIndex:) error:nil];
        }
        
    });
}

#pragma mark - 读取
- (id)exchange_objectAtIndex:(NSUInteger)idx {
    
    if (idx < self.count) {
        return [self exchange_objectAtIndex:idx];
    } else {
        
        SLog(@"NSMutableArray已经越界，当前索引：%lu，数组个数：%lu  %@", (unsigned long)idx, (unsigned long)self.count, [self class]);
        return nil;
    }
}

- (id)exchange_objectAtIndexedSubscript:(NSUInteger)idx {
    
    if (idx < self.count) {
        
        return [self exchange_objectAtIndexedSubscript:idx];
    } else {
        
        SLog(@"NSMutableArray已经越界，当前索引：%lu，数组个数：%lu  %@", (unsigned long)idx, (unsigned long)self.count, [self class]);
        return nil;
    }
}

#pragma mark - 写入
/**
 *  数组中添加数据
 */
- (void)exchange_addObject:(id)object {
    
    if (object) {
        [self exchange_addObject:object];
    } else {
        SLog(@"添加元素为nil");
    }
}

/**
 *  数组中插入数据
 */
- (void)exchange_insertObject:(id)anObject atIndex:(NSUInteger)idx {
    
    if (anObject == nil) {
        SLog(@"插入元素为nil");
    } else if (idx > self.count) {
        SLog(@"idx is invalid");
    } else {
        [self exchange_insertObject:anObject atIndex:idx];
    }
}

@end
