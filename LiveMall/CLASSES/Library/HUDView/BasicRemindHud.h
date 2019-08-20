//
//  BasicRemindHud.h
//  FotileCSS
//
//  Created by BaoBaoDaRen on 2018/9/7.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicRemindHud : UIView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title;

+ (void)popHudWithView:(UIView *)view withTitle:(NSString *)title;

@end
