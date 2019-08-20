//
//  CustomFlowLayout.h
//  TextDemo
//
//  Created by BaoBaoDaRen on 2019/6/17.
//  Copyright © 2019 BaoBao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomFlowLayoutDelegate <NSObject>

- (CGFloat)heightForItemAtIndex:(NSInteger)index;

@end

@interface CustomFlowLayout : UICollectionViewFlowLayout

//这个数组就是我们自定义的布局配置数组
@property (nonatomic, strong) NSMutableArray * attributeAttay;

@property (nonatomic, strong) NSArray *itemHeightArr;

@property (nonatomic, assign) CGFloat itemCount; 

@property (nonatomic, weak) id <CustomFlowLayoutDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
