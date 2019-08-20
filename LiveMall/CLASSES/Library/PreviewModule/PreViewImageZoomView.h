//
//  PreViewImageZoomView.h
//  zoomScale_Sample
//
//  Created by BaoBaoDaRen on 16/10/4.
//  Copyright © 2016年 康振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreViewImageZoomView : UIView<UIScrollViewDelegate>
{
    CGFloat viewscale;
    NSString * downImgUrl;
    BOOL navBarIsHided;
}

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, assign) BOOL isViewing;
@property (nonatomic, strong) UIView * containerView;

- (void)resetViewFrame:(CGRect)newFrame;
- (void)updateImage:(UIImage *)imgName;

/**
 *  加载图片
 *
 *  @param imgUrl 图片url链接
 */
- (void)uddateImageWithUrl:(NSString *)imgUrl;

//本地图片
- (void)updateLocalImage:(UIImage *)imgName;
@end
