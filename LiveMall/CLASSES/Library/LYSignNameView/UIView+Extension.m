//
//  UIView+Extension.m
//  SignName
//
//  Created by Misaya on 16/5/18.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView(Extension)

+ (UIImage*)captureWithView:(UIView *)view
{
    /**
     *  开启上下文
     */
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    
    /**
     *  将控制器的view的layer渲染到上下文
     */
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    /**
     *  取出图片
     */
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    /**
     *  结束上下文
     */
    UIGraphicsEndImageContext();
    return newImage;
}
/// 添加单边阴影效果
+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
 
    theView.layer.shadowColor = GDeepGrayColor.CGColor;
    theView.layer.shadowPath = [UIBezierPath bezierPathWithRect:theView.bounds].CGPath;
    theView.layer.shadowOffset = CGSizeMake(-2,0);
    theView.layer.shadowOpacity = 0.5;
    theView.layer.masksToBounds = YES;
    theView.layer.shadowRadius = 3;
    theView.clipsToBounds = NO;
}

@end
