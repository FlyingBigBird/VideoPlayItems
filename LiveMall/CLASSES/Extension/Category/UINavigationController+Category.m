//
//  UINavigationController+Category.m
//  FotileCSS
//
//  Created by ojbk on 2018/6/28.
//  Copyright © 2018年 康振超. All rights reserved.
//

#import "UINavigationController+Category.h"

@implementation UINavigationController (Category)

- (BOOL)poptoClass:(Class)aClass {
    
    for (int i = (int)self.viewControllers.count; --i >= 0;) {
        
        UIViewController *vc = self.viewControllers[i];
        
        if ([vc isKindOfClass:aClass]) {
            
            [self popToViewController:vc animated:YES];
            return YES;
        }
    }
    return NO;
}

- (id)findvcOfClass:(Class)aClass {
    
    for (int i = (int)self.viewControllers.count; --i >= 0;) {
        
        UIViewController *vc = self.viewControllers[i];
        
        if ([vc isKindOfClass:aClass]) {
            
            return vc;
        }
    }
    return nil;
}

- (BOOL)canFindClassInNaviControllers:(Class)aClass {
    
    for (int i = (int)self.viewControllers.count; --i >= 0;) {
        
        UIViewController *vc = self.viewControllers[i];
        
        if ([vc isKindOfClass:aClass]) {
            return YES;
        }
    }
    return NO;
}

@end
