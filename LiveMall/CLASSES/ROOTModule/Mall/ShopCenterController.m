//
//  ShopCenterController.m
//  XLBasePage
//
//  Created by BaoBaoDaRen on 2019/6/19.
//  Copyright © 2019 ZXL. All rights reserved.
//

#import "ShopCenterController.h"
#import "JXCategoryTitleView.h"

@interface ShopCenterController () <JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;

@end

@implementation ShopCenterController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    if (self.titles == nil) {
        self.titles = @[@"螃蟹", @"麻辣小龙虾", @"苹果", @"营养胡萝卜", @"葡萄", @"美味西瓜", @"香蕉", @"香甜菠萝", @"鸡肉", @"鱼", @"海星"];
    }
    
    self.myCategoryView.titleFont = [UIFont systemFontOfSize:14];
    self.myCategoryView.titleSelectedFont = [UIFont systemFontOfSize:16];
    self.myCategoryView.titles = self.titles;


    self.myCategoryView.titleColorGradientEnabled = YES;
    
    JXCategoryIndicatorImageView *indicatorImageView = [[JXCategoryIndicatorImageView alloc] init];
    indicatorImageView.indicatorImageViewRollEnabled = NO;

    indicatorImageView.indicatorImageView.image = [UIImage imageNamed:@"huxian"];
    self.myCategoryView.indicators = @[indicatorImageView];
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}
- (JXCategoryTitleView *)myCategoryView {
    return (JXCategoryTitleView *)self.categoryView;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

@end
