//
//  HomePageController.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/20.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "HomePageController.h"
#import "PlayItemController.h"
#import "ScalePresentAnimation.h"
#import "ScaleDismissAnimation.h"

@interface HomePageController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) ScalePresentAnimation            *scalePresentAnimation;
@property (nonatomic, strong) ScaleDismissAnimation            *scaleDismissAnimation;
@property (nonatomic, strong) SwipeLeftInteractiveTransition   *swipe;

@end

@implementation HomePageController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    _scalePresentAnimation = [ScalePresentAnimation new];
    _scaleDismissAnimation = [ScaleDismissAnimation new];
    _swipe = [SwipeLeftInteractiveTransition new];

    [self navInit];
    
}
- (void)navInit
{
    if (@available(iOS 11.0, *)) {
        self.homePage.colV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.homePage.backgroundColor = [UIColor whiteColor];
    WeakSelf(self);
    [self.homePage.sellV setPresentBack:^(NSInteger index) {
        
        PlayItemController *playVC = [[PlayItemController alloc] initWithVideoData:[NSMutableArray array] currentIndex:index pageIndex:1 pageSize:1 awemeType:AwemeFavorite uid:@""];
        weakself.swipe = [[SwipeLeftInteractiveTransition alloc] init];
        
        playVC.transitioningDelegate = weakself;
        
        playVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        weakself.modalPresentationStyle = UIModalPresentationCurrentContext;
        [weakself.swipe addGestureToController:playVC];
        [weakself presentViewController:playVC animated:YES completion:nil];

    }];

    [self.homePage setSearchBlock:^{
        
        [weakself doSearch];
    }];
    
    
    
}
//UIViewControllerTransitioningDelegate Delegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return _scalePresentAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return _scaleDismissAnimation;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return _swipe.interacting ? _swipe : nil;
}

// TODO: 搜索...
- (void)doSearch
{
    // 搜索...
    TopAlertView *alert = [[TopAlertView alloc] initWithImage:[UIImage imageNamed:@"football"] title:@"那是一条神奇的天路哎" superView:self.view];
    [alert rightBarItemImage:[UIImage imageNamed:@"football"] finished:^{
        
        
    }];
    [alert showWithAnimation:YES];
    
}

- (HomePageView *)homePage
{
    if (!_homePage) {
        
        _homePage = [[HomePageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_homePage];
    }
    return _homePage;
}


@end
