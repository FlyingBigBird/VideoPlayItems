//
//  ScrollHeader.h
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/21.
//  Copyright © 2019 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollHeader : UIView

@property (nonatomic, strong) NSArray *itemArr;

- (void)selectItemAtIndex:(NSInteger)index;

typedef void (^ClickedItemBlock)(NSInteger index);
@property (nonatomic, copy) ClickedItemBlock itemClick;

@end

NS_ASSUME_NONNULL_END
