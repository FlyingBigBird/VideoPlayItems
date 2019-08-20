//
//  TopAlertView.h
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/24.
//  Copyright © 2019 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopAlertView : UIView

typedef void (^ShowDetailBlock)(void);
@property (nonatomic, copy) ShowDetailBlock showBlock;

- (instancetype)initWithImage:(UIImage * _Nullable )image title:(NSString * _Nullable)title superView:(UIView * _Nullable)supView;

// 背景色
- (void)changeBackgroundColor:(UIColor *)backColor;

// 背景图...
- (void)changeBackgroundImage:(UIImage *)backImage;

// 选择按钮图片...
- (void)rightBarItemImage:(UIImage *)image finished:(ShowDetailBlock)complete;

// 视图展示...
- (void)showWithAnimation:(BOOL)isAnimate;

@end

NS_ASSUME_NONNULL_END
