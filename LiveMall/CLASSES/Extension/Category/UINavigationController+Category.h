//
//  UINavigationController+Category.h
//  FotileCSS
//
//  Created by ojbk on 2018/6/28.
//  Copyright © 2018年 康振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Category)

/**
 pop到第一个类对应的实例（如果没发现类对应的实例，返回NO）

 @param aClass 类
 @return pop结果：YES/NO
 */
- (BOOL)poptoClass:(Class)aClass;

/**
 栈中查找类对应的实例 （如果没发现类对应的实例，返回NO）

 @param aClass 类
 @return 查找结果：YES/NO
 */
- (BOOL)canFindClassInNaviControllers:(Class)aClass;

/**
 根据类从栈中获取实例

 @param aClass 类名
 @return 实例
 */
- (id)findvcOfClass:(Class)aClass;

@end
