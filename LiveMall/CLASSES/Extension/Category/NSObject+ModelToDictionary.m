//
//  NSObject+ModelToDictionary.m
//  FotileCSS
//
//  Created by Minimalism C on 2018/9/30.
//  Copyright © 2018 BaoBao. All rights reserved.
//

#import "NSObject+ModelToDictionary.h"
#import <objc/runtime.h>

@implementation NSObject (ModelToDictionary)

- (NSDictionary *)dictionaryFromModelWhetherNumberToString:(BOOL)isNumberToString {
    
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        
        //only add it to dictionary if it is not nil
        if (key && value) {
            
            if ([value isKindOfClass:[NSString class]]) {
                
                //string类型直接存储
                [dict setObject:value forKey:key];
            } else if ([value isKindOfClass:[NSNumber class]]) {
                
                if (isNumberToString) {
                    
                    //NSNumber存入realm会crash，此处转成string
                    NSString *val = [NSNumberFormatter localizedStringFromNumber:value numberStyle:NSNumberFormatterNoStyle];
                    [dict setObject:val forKey:key];
                } else {
                    
                    [dict setObject:value forKey:key];
                }
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                
                // 数组类型或字典类型
                [dict setObject:[self idFromObject:value withNumberToString:isNumberToString] forKey:key];
            } else {
                
                // 如果model里有其他自定义模型，则递归将其转换为字典
                [dict setObject:[value dictionaryFromModelWhetherNumberToString:isNumberToString] forKey:key];
            }
        } else {
            
            // 如果key、value 为nil。NSMutableDictionary+Swizzling 有针对key、value为nil的处理，此处无需单独处理
            [dict setObject:value forKey:key];
        }
    }
    free(properties);
    return dict;
}

- (id)idFromObject:(nonnull id)object withNumberToString:(BOOL)isNumberToString {
    
    if ([object isKindOfClass:[NSArray class]]) {
        
        if (object != nil && [object count] > 0) {
            
            NSMutableArray *array = [NSMutableArray array];
            
            for (id obj in object) {
                
                if ([obj isKindOfClass:[NSString class]]) {
                    
                    //string类型直接存储
                    [array addObject:obj];
                } else if ([obj isKindOfClass:[NSNumber class]]) {
                    
                    if (isNumberToString) {
                        
                        //NSNumber存入realm会crash，此处转成string
                        NSString *val = [NSNumberFormatter localizedStringFromNumber:obj numberStyle:NSNumberFormatterNoStyle];
                        [array addObject:val];
                    } else {
                        
                        [array addObject:obj];
                    }
                } else if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
                    
                    // 字典或数组需递归处理
                    [array addObject:[self idFromObject:obj withNumberToString:isNumberToString]];
                } else {
                    
                    // model转化为字典
                    [array addObject:[obj dictionaryFromModelWhetherNumberToString:isNumberToString]];
                }
            }
            return array;
        } else {
            return object ? : [NSNull null];
        }
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        
        if (object && [[object allKeys] count] > 0) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (NSString *key in [object allKeys]) {
                
                if ([object[key] isKindOfClass:[NSString class]]) {
                    
                    //string类型直接存储
                    [dic setObject:object[key] forKey:key];
                } else if ([object[key] isKindOfClass:[NSNumber class]]) {
                    
                    if (isNumberToString) {
                        
                        //NSNumber存入realm会crash，此处转成string
                        NSString *val = [NSNumberFormatter localizedStringFromNumber:object[key] numberStyle:NSNumberFormatterNoStyle];
                        [dic setObject:val forKey:key];
                    } else {
                        
                        [dic setObject:object[key] forKey:key];
                    }
                } else if ([object[key] isKindOfClass:[NSArray class]] || [object[key] isKindOfClass:[NSDictionary class]]) {
                    
                    // 字典或数组需递归处理
                    [dic setObject:[self idFromObject:object[key] withNumberToString:isNumberToString] forKey:key];
                } else {
                    
                    // model转化为字典
                    [dic setObject:[object[key] dictionaryFromModelWhetherNumberToString:isNumberToString] forKey:key];
                }
            }
            return dic;
        } else {
            return object ? : [NSNull null];
        }
    }
    return [NSNull null];
}

@end
