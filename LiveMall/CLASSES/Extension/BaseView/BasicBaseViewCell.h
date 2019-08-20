//
//  FotileBaseViewCell.h
//  FotileCSS
//
//  Created by Minimalism C on 2019/1/22.
//  Copyright © 2019 BaoBao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 普通的带titleLabel 和 detailLabel的cell, titleLab centerY 居中， detailLabel高度自适应
 */
@interface BasicBaseViewCell : UITableViewCell

//configure title label
- (void)configureWithTitle:(NSString *)title;

//configure detail label
- (void)configureWithDetailInfo:(NSString *)detail;
- (void)configureWithDetailInfo:(NSString *)detail andDetailLabelAlignment:(NSTextAlignment)alignment;

//自适应计算高度
+ (CGFloat)getCellHeightWithDetail:(NSString *)detail;

//不自适应，默认高度
+ (CGFloat)getCellHeight;

@end

NS_ASSUME_NONNULL_END
