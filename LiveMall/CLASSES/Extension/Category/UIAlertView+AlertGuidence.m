//
//  UIAlertView+AlertGuidence.m
//  WristWatchSample
//
//  Created by BaoBaoDaRen on 17/3/14.
//  Copyright © 2017年 康振超. All rights reserved.
//

#import "UIAlertView+AlertGuidence.h"

@implementation UIAlertView (AlertGuidence)

+ (void)showCustomEnsureAlert:(NSString *)message
{
    UIAlertView * ensureAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [ensureAlert show];
}

@end
