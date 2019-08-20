//
//  BasicRemindHud.m
//  FotileCSS
//
//  Created by BaoBaoDaRen on 2018/9/7.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import "BasicRemindHud.h"

@interface BasicRemindHud ()<MBProgressHUDDelegate>

@property (nonatomic, copy) NSString * titStr;

@end

@implementation BasicRemindHud 

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titStr = LEmpty(title);
        [self setBasicRemindHudSubs];
    }
    return self;
}

- (void)setBasicRemindHudSubs
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.delegate = self;
    hud.label.numberOfLines = 0;
    hud.label.text = self.titStr;
    [hud hideAnimated:YES afterDelay:2.0];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    [self removeFromSuperview];
}

+ (void)popHudWithView:(UIView *)view withTitle:(NSString *)title {
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.numberOfLines = 0;
    hud.label.text = LEmpty(title);
    [hud hideAnimated:YES afterDelay:2.0];
}

@end
