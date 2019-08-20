//
//  TabBarView.h
//  CommentSample
//
//  Created by BaoBaoDaRen on 2017/8/15.
//  Copyright © 2017年 康振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabBarViewDelegate <NSObject>

- (void)tabBarItemDidSelectAtIndex:(NSInteger)selectedIndex;

@end

@interface TabBarView : UIView

@property (nonatomic, weak) id <TabBarViewDelegate> delegate;

/**
 自定义底部tabbar替换系统原生tabbar修改框架,不可滑动类型小于等于5个模块儿
 
 @param itemNum 底部tabBarItem数量
 @param isCenterLarge 中心按钮是否变大
 @param titleArray 标题
 @param selectedImageArray 选中图片
 @param UnSelectedImageArray 非选中下图片
 @param centerImage 中心图片
 */
- (void)customTabBarItemNumber:(NSInteger)itemNum
               withCenterLarge:(BOOL)isCenterLarge
                withTitleArray:(NSArray *)titleArray
        withSelectedImageArray:(NSArray *)selectedImageArray
      withUnSelectedImageArray:(NSArray *)UnSelectedImageArray
               withCenterImage:(UIImage *)centerImage
           withBackGroundColor:(UIColor *)backColor
          withTitleSelectColor:(UIColor *)titleSelectColor
        withTitleUnSelectColor:(UIColor *)titleUnSelectColor;

/**
 设置选中索引

 @param selectedIndex 选中条目...
 */
- (void)setCustomTabBarSelectedIndex:(NSInteger)selectedIndex;

@end
