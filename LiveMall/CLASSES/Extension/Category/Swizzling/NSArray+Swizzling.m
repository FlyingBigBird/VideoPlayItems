//
//  NSArray+Swizzling.m
//  FotileCSS
//
//  Created by ojbk on 2018/9/18.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import "NSArray+Swizzling.h"
#import <objc/runtime.h>

@implementation NSArray (Swizzling)

+ (void)load {
    
    
    [super load];
    
    //无论怎样 都要保证方法只交换一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        @autoreleasepool {
            
            //交换NSArray中的objectAtIndex方法
            [objc_getClass("__NSSingleObjectArray0") systemSelector:@selector(objectAtIndex:) swizzledSelector:@selector(emptyObjectIndex:) error:nil];
            
            [objc_getClass("__NSSingleObjectArrayI") systemSelector:@selector(objectAtIndex:) swizzledSelector:@selector(exchange_objectAtIndex:) error:nil];
            
            //交换NSArray中的objectAtIndexedSubscript方法
            [objc_getClass("__NSSingleObjectArrayI") systemSelector:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(exchange_objectAtIndexedSubscript:) error:nil];
        }
        
    });
}
- (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
- (id)emptyObjectIndex:(NSInteger)index{
    return nil;
}

- (id)arrObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self arrObjectIndex:index];
}

- (id)mutableObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self mutableObjectIndex:index];
}

- (void)mutableInsertObject:(id)object atIndex:(NSUInteger)index{
    if (object) {
        [self mutableInsertObject:object atIndex:index];
    }
}

- (id)exchange_objectAtIndexedSubscript:(NSUInteger)idx {
    
    if (idx < self.count) {
        return [self exchange_objectAtIndexedSubscript:idx];
    } else {
        
        SLog(@"NSArray已经越界，当前索引：%lu，数组个数：%lu  %@", (unsigned long)idx, (unsigned long)self.count, [self class]);
        return nil;
    }
}

- (id)exchange_objectAtIndex:(NSUInteger)idx {
    
    if (idx < self.count) {
        return [self exchange_objectAtIndex:idx];
    } else {
        
        SLog(@"NSArray已经越界，当前索引：%lu，数组个数：%lu  %@", (unsigned long)idx, (unsigned long)self.count, [self class]);
        return nil;
    }
}

@end
