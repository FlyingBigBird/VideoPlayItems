//
//  UILabel+LabCornerRadius.h
//  qwz
//
//  Created by BaoBaoDaRen on 17/3/21.
//  Copyright © 2017年 康振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LabCornerRadius)

- (void)resetLabelCornerRadius:(CGFloat)radius withTitleColor:(UIColor *)titColor withBgColor:(UIColor *)bgColor withTitleFont:(CGFloat)titFont withNumberLine:(CGFloat)lineNumber;

- (void)resetLabelBoarderWidth:(CGFloat)borderWidth andBoarderColor:(UIColor *)boarderColor;

@end
