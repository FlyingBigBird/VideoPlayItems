//
//  NSObject+ModelToDictionary.h
//  FotileCSS
//
//  Created by Minimalism C on 2018/9/30.
//  Copyright © 2018 BaoBao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ModelToDictionary)

/**
 *  模型转字典
 *
 *  @param isNumberToString 是否需要NSNumber转NSString，NSNumber存入realm会crash
 *  @return 字典
 */
- (NSDictionary *)dictionaryFromModelWhetherNumberToString:(BOOL)isNumberToString;

/**
 *  带model的数组或字典转字典W
 *
 *  @param object 带model的数组或字典转
 *  @param isNumberToString 是否需要NSNumber转NSString，NSNumber存入realm会crash
 *  @return 字典
 */
- (id)idFromObject:(id)object withNumberToString:(BOOL)isNumberToString;

@end

NS_ASSUME_NONNULL_END
