//
//  SharedInstance.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/20.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "SharedEntity.h"
#import "AppDelegate.h"

@implementation SharedEntity

static SharedEntity * s_Manager = nil;

+ (SharedEntity *)SharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        s_Manager = [[SharedEntity alloc] init];
    });
    return s_Manager;
}

- (void) doPush:(UIViewController *)controller animated:(BOOL)animated
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"class:%@",[delegate.window.rootViewController class]);
    id currentNav = delegate.window.rootViewController;
    
    if ([currentNav isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *nav = currentNav;

        UIViewController *vc = [[currentNav childViewControllers] firstObject];
        [vc.navigationController pushViewController:controller animated:animated];
    }
}


@end
