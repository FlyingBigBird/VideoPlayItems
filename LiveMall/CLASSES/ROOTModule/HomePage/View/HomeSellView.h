//
//  HomeSellView.h
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/20.
//  Copyright © 2019 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HomeSellView : UIView

typedef void (^SellDoPresentBack)(NSInteger index);
@property (nonatomic, copy) SellDoPresentBack presentBack;

@property (nonatomic, strong) UICollectionView *colView;
@property (nonatomic, assign) NSInteger selectIndex;

// 更多
@property (nonatomic, strong) UIButton *moreItem;

- (void)setItemCount:(NSInteger)itemCount;

@end

NS_ASSUME_NONNULL_END
