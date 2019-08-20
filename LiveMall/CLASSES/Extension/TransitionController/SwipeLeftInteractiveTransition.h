//
//  SwipeLeftInteractiveTransition.h
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/25.
//  Copyright © 2019 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwipeLeftInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interacting;

- (void) addGestureToController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
