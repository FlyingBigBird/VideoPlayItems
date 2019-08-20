//
//  HomeDataCell.h
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/21.
//  Copyright © 2019 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeDataCell : UICollectionViewCell

@property (nonatomic, strong) UIView *bgV;

@property (nonatomic, strong) UIImageView *bgPic;// 大图

@property (nonatomic, strong) UIImageView *goodPic;// 商品
@property (nonatomic, strong) UILabel *goodsTit;// 产品标题

@property (nonatomic, strong) UILabel *detailLab;// 产品简介...
@property (nonatomic, strong) UIImageView *headPic;// 头像...
@property (nonatomic, strong) UILabel *nameLab;// 昵称

@property (nonatomic, strong) UIImageView *heartImgV;// 关注
@property (nonatomic, strong) UILabel *favNumLab;// 关注人数...

@property (nonatomic, strong) NSIndexPath *itemIndexPath;

- (void) cellData:(NSArray *)dataArr cellAtIndexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
