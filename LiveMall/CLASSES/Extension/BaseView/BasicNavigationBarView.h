//
//  BasicNavigationBarView.h
//  FotileCSS
//
//  Created by BaoBaoDaRen on 2018/6/22.
//  Copyright © 2018年 康振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BasicNavigationBarViewDelegate <NSObject>

@optional
- (void)customNavgationBarDidClicked;

@optional
- (void)customNavgationRightBarButtonClicked;

@end

@interface BasicNavigationBarView : UIView

@property (nonatomic, weak) id <BasicNavigationBarViewDelegate> delegate;

- (void)setCustomBarBgImage:(UIImage *)image;

- (void)setCustomBarTitle:(NSString *)title;

- (void)setCustomBarTitleColor:(UIColor *)titleColor;

- (void)setCustomBarTitleFont:(CGFloat)titleFont;

- (void)setCustomBarBoLineHidden:(BOOL)isHidden;

- (void)setCustomBarBackImageWidthHeight:(CGFloat)WH;

- (void)setCustomNavBarRightButtonHidden:(BOOL)hidden withImage:(UIImage *)image;

- (void)setCustomNavBarRightButtonTitle:(NSString *)rightTitle andTitleColor:(UIColor *)titleColor;

- (void)setNavigationBarWith:(NSString *)title andBGColor:(UIColor *)backGroundColor andTitleColor:(UIColor *)titleColor andImage:(NSString *)imgString andHidLine:(BOOL)hidLine;

@end


