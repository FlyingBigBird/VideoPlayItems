//
//  NSObject+SwizzleMethod.m
//  FotileCSS
//
//  Created by ojbk on 2018/9/18.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import "NSObject+SwizzleMethod.h"
#import <objc/runtime.h>

@implementation NSObject (SwizzleMethod)

/**
 *  对系统方法进行替换
 *
 *  @param systemSelector 被替换的方法
 *  @param swizzledSelector 实际使用的方法
 *  @param error            替换过程中出现的错误消息
 *
 *  @return 是否替换成功
 */
+ (BOOL)systemSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector error:(NSError *)error {
    
    Class class = [self class];
    
    Method systemMethod = class_getInstanceMethod(self, systemSelector);
    if (!systemMethod) {
        return [class unrecognizedSelector:systemSelector error:error];
    }
    
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    if (!swizzledMethod) {
        
        return [class unrecognizedSelector:swizzledSelector error:error];
    }
    
    // 若已经存在，则添加会失败
    BOOL didAddMethod = class_addMethod(class,
                                        systemSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    // 若原来的方法并不存在，则添加即可
    if (didAddMethod) {
        
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(systemMethod),
                            method_getTypeEncoding(systemMethod));
    } else {
        
        method_exchangeImplementations(systemMethod, swizzledMethod);
    }
    return YES;
}

+ (BOOL)unrecognizedSelector:(SEL)selector error:(NSError *)error {
    
    NSString *errorString = [NSString stringWithFormat:@"%@类没有找到%@", NSStringFromClass([self class]), NSStringFromSelector(selector)];
    
    error = [NSError errorWithDomain:@"NSCocoaErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorString}];
    return NO;
}

@end
