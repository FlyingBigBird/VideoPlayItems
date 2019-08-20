//
//  BaseContentController.m
//  XLBasePage
//
//  Created by BaoBaoDaRen on 2019/6/19.
//  Copyright © 2019 ZXL. All rights reserved.
//

#import "BaseContentController.h"
#import "ListViewController.h"
//#import "NestViewController.h"
#import "NaviSegmentedControlViewController.h"

@interface BaseContentController () <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@end

@implementation BaseContentController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _shouldHandleScreenEdgeGesture = YES;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self controllerEdgeSet];
    
    [self ContainerUiInit];
    
}
- (void)ContainerUiInit
{
    self.categoryView.delegate = self;
    [self.view addSubview:self.categoryView];
    
    self.listContainerView.didAppearPercent = 0.01; //滚动一点就触发加载
    [self.view addSubview:self.listContainerView];
    
    self.categoryView.contentScrollView = self.listContainerView.scrollView;
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (![self isKindOfClass:[NaviSegmentedControlViewController class]]) {
        self.categoryView.frame = CGRectMake(0, StatusBar_H, self.view.bounds.size.width, [self preferredCategoryViewHeight]);
    }
    self.listContainerView.frame = CGRectMake(0, StatusBar_H + [self preferredCategoryViewHeight], SCREEN_WIDTH, SCREEN_HEIGHT - StatusBar_H - [self preferredCategoryViewHeight] - TabBar_H);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //处于第一个item的时候，才允许屏幕边缘手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryBaseView alloc] init];
}

- (CGFloat)preferredCategoryViewHeight {
    
    return 50;
}

#pragma mark - 初始化
- (id<JXCategoryListContentViewDelegate>)preferredListAtIndex:(NSInteger)index {
    
    return [[ListViewController alloc] init];
}

- (JXCategoryBaseView *)categoryView {
    if (_categoryView == nil) {
        _categoryView = [self preferredCategoryView];
    }
    return _categoryView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (_listContainerView == nil) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
    }
    return _listContainerView;
}

- (void)rightItemClicked {
    JXCategoryIndicatorView *componentView = (JXCategoryIndicatorView *)self.categoryView;
    for (JXCategoryIndicatorComponentView *view in componentView.indicators) {
        if (view.componentPosition == JXCategoryComponentPosition_Top) {
            view.componentPosition = JXCategoryComponentPosition_Bottom;
        }else {
            view.componentPosition = JXCategoryComponentPosition_Top;
        }
    }
    [componentView reloadData];
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //侧滑手势处理
    if (_shouldHandleScreenEdgeGesture) {
        self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    }
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    id<JXCategoryListContentViewDelegate> list = [self preferredListAtIndex:index];
    return list;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

- (void)controllerEdgeSet
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        //        self.<#scrollView#>.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
}


@end
