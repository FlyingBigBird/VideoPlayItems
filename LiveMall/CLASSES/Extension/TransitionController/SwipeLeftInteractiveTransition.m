//
//  SwipeLeftInteractiveTransition.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/25.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "SwipeLeftInteractiveTransition.h"
@interface SwipeLeftInteractiveTransition ()

@property (nonatomic, strong) UIViewController *presentingVC;
@property (nonatomic, assign) CGPoint viewControllerCenter;

@end

@implementation SwipeLeftInteractiveTransition

- (void) addGestureToController:(UIViewController *)controller
{
    _presentingVC = controller;
    _viewControllerCenter = controller.view.center;
    [self addGestureToView:controller.view];
}
- (void)addGestureToView:(UIView*)view {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
}
- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
 
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    if(!_interacting && (translation.x < 0 || translation.y < 0 || translation.x < translation.y)) {
        return;
    }
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            _interacting = YES;
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat progress = translation.x / SCREEN_WIDTH;
            progress = fminf(fmaxf(progress, 0.0), 1.0);
            
            CGFloat ratio = 1.0f - progress*0.5f;
            [_presentingVC.view setCenter:CGPointMake(_viewControllerCenter.x + translation.x * ratio, _viewControllerCenter.y + translation.y * ratio)];
            _presentingVC.view.transform = CGAffineTransformMakeScale(ratio, ratio);
            [self updateInteractiveTransition:progress];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            CGFloat progress = translation.x / SCREEN_WIDTH;
            progress = fminf(fmaxf(progress, 0.0), 1.0);
            if (progress < 0.2){
                [UIView animateWithDuration:progress
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [self.presentingVC.view setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
                                     self.presentingVC.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                                 } completion:^(BOOL finished) {
                                     self.interacting = NO;
                                     [self cancelInteractiveTransition];
                                 }];
            }else {
                _interacting = NO;
                [self finishInteractiveTransition];
                [_presentingVC dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        }
        default:
            break;
    }
}

@end
