//
//  ScaleDismissAnimation.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "ScaleDismissAnimation.h"
#import "HomePageController.h"
#import "PlayItemController.h"
#import "VideoListCell.h"
#import "BasicTabController.h"

@implementation ScaleDismissAnimation

- (instancetype)init {
    self = [super init];
    if (self) {
        
        CGFloat finalWH = 5;
        _centerFrame = CGRectMake(SCREEN_WIDTH + finalWH, (SCREEN_HEIGHT - finalWH)/2, finalWH, finalWH);
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
 
    PlayItemController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *toVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if ([toVC.viewControllers.firstObject isKindOfClass:BasicTabController.class]) {
    
        BasicTabController *tabVC = toVC.viewControllers.firstObject;
        HomePageController *homeVC = (HomePageController *)tabVC.currentViewController;
        
        UIView *selectCell = (VideoListCell *)[homeVC.homePage.sellV.colView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:fromVC.currentIndex inSection:1]];
        
        UIView *snapshotView;
        CGFloat scaleRatio;
        CGRect finalFrame;
        if(selectCell) {
            snapshotView = [selectCell snapshotViewAfterScreenUpdates:NO];
            scaleRatio = fromVC.view.frame.size.width/selectCell.frame.size.width;
            snapshotView.layer.zPosition = 20;
            finalFrame = [homeVC.homePage.sellV.colView convertRect:selectCell.frame toView:[homeVC.homePage.sellV.colView superview]];
        }else {
            snapshotView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
            scaleRatio = fromVC.view.frame.size.width/SCREEN_WIDTH;
            finalFrame = _centerFrame;
        }
        
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:snapshotView];
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        
        fromVC.view.alpha = 0.0f;
        snapshotView.center = fromVC.view.center;
        snapshotView.transform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        [UIView animateWithDuration:duration
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0.2
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             snapshotView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                             snapshotView.frame = finalFrame;
                         } completion:^(BOOL finished) {
                             [transitionContext finishInteractiveTransition];
                             [transitionContext completeTransition:YES];
                             [snapshotView removeFromSuperview];
                         }];
    }
}

@end




