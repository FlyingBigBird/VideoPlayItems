//
//  BaseContentController.h
//  XLBasePage
//
//  Created by BaoBaoDaRen on 2019/6/19.
//  Copyright © 2019 ZXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryView.h"
#import "JXCategoryListContainerView.h"
//#import "NaviSegmentedControlViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseContentController : UIViewController

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) JXCategoryBaseView *categoryView;

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic, assign) BOOL isNeedIndicatorPositionChangeItem;

@property (nonatomic, assign) BOOL shouldHandleScreenEdgeGesture;

- (JXCategoryBaseView *)preferredCategoryView;

- (CGFloat)preferredCategoryViewHeight;

- (id<JXCategoryListContentViewDelegate>)preferredListAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
