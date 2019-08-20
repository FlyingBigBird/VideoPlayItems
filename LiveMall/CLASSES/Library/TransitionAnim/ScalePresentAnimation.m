//
//  ScalePresentAnimation.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "ScalePresentAnimation.h"
#import "HomePageController.h"
#import "PlayItemController.h"
#import "VideoListCell.h"
#import "BasicTabController.h"

@implementation ScalePresentAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
  
    PlayItemController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UINavigationController *fromVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if ([fromVC.viewControllers.firstObject isKindOfClass:BasicTabController.class]) {
        
        BasicTabController *tabVC = fromVC.viewControllers.firstObject;
        HomePageController *homeVC = (HomePageController *)tabVC.currentViewController;
        UIView *selectCell = (VideoListCell *)[homeVC.homePage.sellV.colView  cellForItemAtIndexPath:[NSIndexPath indexPathForItem:homeVC.homePage.sellV.selectIndex inSection:1]];
        
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toVC.view];
        
        CGRect initialFrame = [homeVC.homePage.sellV.colView convertRect:selectCell.frame toView:[homeVC.homePage.sellV.colView superview]];
        CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        
        toVC.view.center = CGPointMake(initialFrame.origin.x + initialFrame.size.width/2, initialFrame.origin.y + initialFrame.size.height/2);
        toVC.view.transform = CGAffineTransformMakeScale(initialFrame.size.width/finalFrame.size.width, initialFrame.size.height/finalFrame.size.height);
        
        [UIView animateWithDuration:duration
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:1
                            options:UIViewAnimationOptionLayoutSubviews
                         animations:^{
                             toVC.view.center = CGPointMake(finalFrame.origin.x + finalFrame.size.width/2, finalFrame.origin.y + finalFrame.size.height/2);
                             toVC.view.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
}
@end
