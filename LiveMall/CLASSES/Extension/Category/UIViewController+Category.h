//
//  UIViewController+Category.h
//  FotileCSS
//
//  Created by ojbk on 2018/8/24.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Category)

/**
 只保留栈中首尾两个对象，用于结果页面返回首页，跳过中间页面, 兼容点击back按钮和左滑返回。
 */
- (void)resetStackObj;

@end
