//
//  NSObject+SwizzleMethod.h
//  FotileCSS
//
//  Created by ojbk on 2018/9/18.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SwizzleMethod)

/**
 *  对系统方法进行替换(交换实例方法)
 *
 *  @param systemSelector 被替换的方法
 *  @param swizzledSelector 实际使用的方法
 *  @param error            替换过程中出现的错误消息
 *
 *  @return 是否替换成功
 */
+ (BOOL)systemSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector error:(NSError *)error;

@end
