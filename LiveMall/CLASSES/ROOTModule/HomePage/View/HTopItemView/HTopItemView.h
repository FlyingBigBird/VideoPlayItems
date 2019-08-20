//
//  HTopItemView.h
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/7/1.
//  Copyright © 2019 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTopItemView : UIView

@property (nonatomic, strong) UIImageView *bgImgV;

@property (nonatomic, strong) UIView *topV;

typedef void (^DataTypeCallBack)(NSInteger type);
@property (nonatomic, copy) DataTypeCallBack selectType;

- (instancetype)initWithFrame:(CGRect)frame
                     typeData:(NSArray *)data
                    compelete:(DataTypeCallBack)compelete;

@end

NS_ASSUME_NONNULL_END
