//
//  UILabel+LabCornerRadius.m
//  qwz
//
//  Created by BaoBaoDaRen on 17/3/21.
//  Copyright © 2017年 康振超. All rights reserved.
//

#import "UILabel+LabCornerRadius.h"

@implementation UILabel (LabCornerRadius)

- (void)resetLabelCornerRadius:(CGFloat)radius withTitleColor:(UIColor *)titColor withBgColor:(UIColor *)bgColor withTitleFont:(CGFloat)titFont withNumberLine:(CGFloat)lineNumber
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
    self.textColor = titColor;
    self.backgroundColor = bgColor;
    self.font = [UIFont systemFontOfSize:titFont];
    self.numberOfLines = lineNumber;
}

- (void)resetLabelBoarderWidth:(CGFloat)borderWidth andBoarderColor:(UIColor *)boarderColor
{
    self.layer.borderColor = boarderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

@end
