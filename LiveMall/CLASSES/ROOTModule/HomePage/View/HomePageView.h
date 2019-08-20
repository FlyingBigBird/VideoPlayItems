//
//  HomePageView.h
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/20.
//  Copyright © 2019 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSellView.h"
#import "HomeNearView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePageView : UIView

@property (nonatomic, strong) UICollectionView *colV;

typedef void (^SearchCallBack)(void);
@property (nonatomic, copy) SearchCallBack searchBlock;


// 底部滑动: 推荐/北京
@property (nonatomic, strong) UIScrollView *homeScrolV;

@property (nonatomic, strong) HomeSellView *sellV;
@property (nonatomic, strong) HomeNearView *nearV;


@end

NS_ASSUME_NONNULL_END
