//
//  UIButton+UIButton_CornerRadius.h
//  WristWatchSample
//
//  Created by BaoBaoDaRen on 17/3/10.
//  Copyright © 2017年 康振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UIButton_CornerRadius)

@property (nonatomic, strong) NSString * titleName;

- (void)resetWithButton:(UIButton *)senderButton withCornerRadius:(CGFloat)radius withTitleColor:(UIColor *)titColor withBackColor:(UIColor *)bgColor withTitleFont:(CGFloat)titFont;

- (void)resetButton:(UIButton *)button withBoarderWidth:(CGFloat)borderWidth andBoarderColor:(UIColor *)boarderColor;

@end
