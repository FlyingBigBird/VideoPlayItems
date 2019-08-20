//
//  UIViewController+Category.m
//  FotileCSS
//
//  Created by ojbk on 2018/8/24.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import "UIViewController+Category.h"

@implementation UIViewController (Category)

- (void)resetStackObj {
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSMutableArray *viewCtrls = [NSMutableArray arrayWithArray:viewControllers];
    NSInteger i = viewControllers.count;
    
    while (i > 2) { 
        
        [viewCtrls removeObjectAtIndex:1];
        i--;
    }
    [self.navigationController setViewControllers:viewCtrls];
}

@end
