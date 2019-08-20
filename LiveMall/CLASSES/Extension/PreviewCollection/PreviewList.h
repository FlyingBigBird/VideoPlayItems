//
//  PreviewList.h
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/7/15.
//  Copyright © 2019 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreviewItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PreviewList : UIView

@property (nonatomic, strong) UICollectionView *colView;

@property (nonatomic, strong, setter=setSourceData:) NSArray *sourceData;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) NSInteger currentIndex;


- (void)refreshImages:(NSArray * _Nullable)images atIndex:(NSInteger)index;


@end



// TODO: header : footer
@interface colHeader : UICollectionReusableView

@end

@interface colFooter : UICollectionReusableView

@end

NS_ASSUME_NONNULL_END

