//
//  PreViewImageZoomView.m
//  zoomScale_Sample
//
//  Created by BaoBaoDaRen on 16/10/4.
//  Copyright © 2016年 康振超. All rights reserved.
//

#import "PreViewImageZoomView.h"
#import "UIImageView+WebCache.h"

@implementation PreViewImageZoomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _initView];
    }
    return self;
}

- (void)resetViewFrame:(CGRect)newFrame
{
    self.frame = newFrame;
    _scrollView.frame = self.bounds;
    _containerView.frame = self.bounds;
}

- (void)_initView
{
    self.backgroundColor = [UIColor blackColor];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    [_scrollView addSubview:self.containerView];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.containerView addSubview:_imageView];
    self.imageView.clipsToBounds = YES;
    
    //    UITapGestureRecognizer * signalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signalTapped)];
    //    [signalTap setNumberOfTapsRequired:1];
    //    [self addGestureRecognizer:signalTap];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped)];
    [doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap];
    
    //    [signalTap requireGestureRecognizerToFail:doubleTap];
    
    _scrollView.maximumZoomScale = 5.0;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.zoomScale = 1.0;
}

//本地图片
- (void)updateImage:(NSString *)imgName {
    
    self.scrollView.scrollEnabled = YES;
    self.image = [UIImage imageNamed:imgName];
    [self setImageViewWithImg:self.image];
}
//本地图片
- (void)updateLocalImage:(UIImage *)imgName {
    
    self.scrollView.scrollEnabled = YES;
    self.image = imgName;
    [self setImageViewWithImg:self.image];
}

//网络图片
- (void)uddateImageWithUrl:(NSString *)imgUrl
{
    self.scrollView.scrollEnabled = NO;
    self.imageView.image = nil;
    downImgUrl = imgUrl;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:downImgUrl] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.image = image;
        [self setImageViewWithImg:self.image];
    }];
}

- (void)setImageViewWithImg:(UIImage *)img {
    
    self.scrollView.scrollEnabled = YES;
    
    self.imageView.image = img;
    CGSize showSize = [self newSizeByoriginalSize:img.size maxSize:self.bounds.size];
    self.imageView.frame = CGRectMake(0, 0, showSize.width, showSize.height);
    
    _scrollView.zoomScale = 1;
    _scrollView.contentOffset = CGPointZero;
    _containerView.bounds = _imageView.bounds;
    _scrollView.zoomScale = _scrollView.minimumZoomScale;
    [self scrollViewDidZoom:_scrollView];
}

// 获取尺寸
- (CGSize)newSizeByoriginalSize:(CGSize)oldSize maxSize:(CGSize)mSize
{
    if (oldSize.width <= 0 || oldSize.height <= 0) {
        return CGSizeZero;
    }
    
    CGSize newSize = CGSizeZero;
    if (oldSize.width > mSize.width || oldSize.height > mSize.height)
    {
        //按比例计算尺寸
        float percentage = [self getImgWidthFactor];
        float newHeight = oldSize.height * percentage;
        newSize = CGSizeMake(mSize.width, newHeight);
        
        if (newHeight > mSize.height) {
            percentage = [self getImgHeightFactor];
            float newWidth = oldSize.width * percentage;
            newSize = CGSizeMake(newWidth, mSize.height);
        }
    } else
    {
        newSize = oldSize;
    }
    return newSize;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _containerView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _containerView.frame.size.width;
    CGFloat H = _containerView.frame.size.height;
    
    CGRect rct = _containerView.frame;
    rct.origin.x = MAX((Ws-W)*0.5, 0);
    rct.origin.y = MAX((Hs-H)*0.5, 0);
    _containerView.frame = rct;
    
}

//获取图片和显示视图宽度的比例系数
- (float)getImgWidthFactor {
    
    return self.bounds.size.width / self.image.size.width;
}

//获取图片和显示视图高度的比例系数
- (float)getImgHeightFactor {
    
    return self.bounds.size.height / self.image.size.height;
}

- (void)doubleTapped
{
    if (_scrollView.minimumZoomScale <= self.scrollView.zoomScale && self.scrollView.maximumZoomScale > self.scrollView.zoomScale)
    {
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    } else
    {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

@end
