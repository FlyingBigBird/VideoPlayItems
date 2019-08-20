//
//  UIButton+UIButton_CornerRadius.m
//  WristWatchSample
//
//  Created by BaoBaoDaRen on 17/3/10.
//  Copyright © 2017年 康振超. All rights reserved.
//

#import "UIButton+UIButton_CornerRadius.h"
#import "objc/runtime.h"

@implementation UIButton (UIButton_CornerRadius)

static const void * titleNameBy = &titleNameBy;
@dynamic titleName;

- (void)resetWithButton:(UIButton *)senderButton withCornerRadius:(CGFloat)radius withTitleColor:(UIColor *)titColor withBackColor:(UIColor *)bgColor withTitleFont:(CGFloat)titFont
{ 
    [senderButton setBackgroundColor:bgColor];
    [senderButton setTitleColor:titColor forState:UIControlStateNormal];
    senderButton.titleLabel.font = [UIFont systemFontOfSize:titFont];
    
    senderButton.layer.masksToBounds = YES;
    senderButton.layer.cornerRadius = radius;
    
//    senderButton.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
}

- (void)resetButton:(UIButton *)button withBoarderWidth:(CGFloat)borderWidth andBoarderColor:(UIColor *)boarderColor
{
    button.layer.borderColor = boarderColor.CGColor;
    button.layer.borderWidth = borderWidth;
}

// 添加自定义属性
- (void)setTitleName:(NSString *)titleName {
    
    objc_setAssociatedObject(self, titleNameBy, titleName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)titleName {
    
    return objc_getAssociatedObject(self, titleNameBy);
}

// 设置背景颜色for state
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

// 设置颜色
+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
