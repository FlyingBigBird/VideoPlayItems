//
//  PreviewPage.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/7/15.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "PreviewPage.h"
#import "AppDelegate.h"

@interface PreviewPage () <UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isRotate;
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGPoint movePoint;

@end

#define maxScale 5.0f
#define minScale 1.0f

@implementation PreviewPage

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.isRotate = NO;
        self.portraitFrame = frame;
        self.landscapeFrame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);

        [self setPreviewPageSubs];
    }
    return self;
}

- (void)setPreviewPageSubs
{
    self.scrollView.backgroundColor = [UIColor blackColor];

    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    self.conView = [[UIView alloc] initWithFrame:self.bounds];
    self.conView.center = self.scrollView.center;
    [self.scrollView addSubview:self.conView];
    self.scrollView.contentOffset = CGPointZero;
    
    self.imgView = [[UIImageView alloc] initWithFrame:self.conView.bounds];
    [self.conView addSubview:self.imgView];
    self.imgView.center = self.conView.center;
    self.imgView.clipsToBounds = YES;
    
    
    //单击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signalTapAction:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapGesture];
    
    //双击
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTapGesture];
    
    //双击失败之后执行单击
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = minScale;
        _scrollView.maximumZoomScale = maxScale;
        _scrollView.zoomScale = 1.0;
        _scrollView.scrollEnabled = YES;
        
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
- (void)signalTapAction:(UITapGestureRecognizer *)signalTap
{
    [self.delegate signalTappedBegin];
}
- (void)doubleTapAction:(UITapGestureRecognizer *)doubleTap
{
    if (self.scrollView.minimumZoomScale <= self.scrollView.zoomScale && self.scrollView.maximumZoomScale > self.scrollView.zoomScale)
    {
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    }else
    {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }

}

- (void) loadImage:(UIImage *)image
{
    self.scrollView.scrollEnabled = YES;

    [self updateImage:image];
}

- (void) imageWithUrl:(NSString *)imgUrl
{
    self.scrollView.scrollEnabled = NO;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"loadFailed"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self updateImage:image];
    }];
}
- (void)updateImage:(UIImage *)image
{
    if (![self.imgView.image isEqual:image]) {
        
        self.imgSize = image.size;
        self.imgView.image = image;
    }
    
    CGSize imgSize = [self updateImageSize:image];
    [self updateComponentsRect:imgSize];

    self.scrollView.zoomScale = minScale;
}
- (CGSize)updateImageSize:(UIImage *)image
{
    CGSize imgSize = self.imgSize;
    CGSize showSize = self.bounds.size;

    if (!image || imgSize.width <= 0 || imgSize.height <= 0) {
        
        return CGSizeZero;
    }
    
    CGSize aspectSize = CGSizeZero;
    if (imgSize.width > showSize.width) {
        
        CGFloat getWidth = showSize.width;
        CGFloat getHeight = imgSize.height * getWidth / imgSize.width;
        aspectSize = CGSizeMake(getWidth, getHeight);
    } else if (imgSize.height > showSize.height) {
        
        CGFloat getHeight = showSize.height;
        CGFloat getWidth = imgSize.width * getHeight / imgSize.height;
        aspectSize = CGSizeMake(getWidth, getHeight);
    } else {
        
        aspectSize = CGSizeMake(imgSize.width, imgSize.height);
    }
    
    return aspectSize;
}
- (void)updateComponentsRect:(CGSize)size
{
    if (size.width < self.bounds.size.width) {
     
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, size.height);
    } else if (size.height < self.bounds.size.height)
    {
        self.scrollView.contentSize = CGSizeMake(size.width, self.bounds.size.height);
    } else {
    
        self.scrollView.contentSize = size;
    }
    self.scrollView.contentOffset = CGPointZero;

    self.imgView.frame = CGRectMake(0, 0, size.width, size.height);
    self.conView.bounds = self.imgView.bounds;

    [self scrollViewDidZoom:self.scrollView];

}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
   
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = self.conView.frame.size.width;
    CGFloat H = self.conView.frame.size.height;
    
    CGRect rct = self.conView.frame;
    rct.origin.x = MAX((Ws-W)*0.5, 0);
    rct.origin.y = MAX((Hs-H)*0.5, 0);
    self.conView.frame = rct;
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.conView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);

    self.imgView.frame = self.bounds;
    self.conView.frame = self.bounds;
    
    if (self.imgView.image) {
        
        [self updateImage:self.imgView.image];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UIDeviceOrientation orien = [[UIDevice currentDevice] orientation];
    UIInterfaceOrientationMask orintation = (UIInterfaceOrientationMask)orien;
    if (orintation == UIInterfaceOrientationPortrait) {
        
        CGFloat pathY = self.scrollView.contentOffset.y;
        
        if (pathY < -100) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(shouldDismissView:)])
            {
                
                [self.delegate shouldDismissView:self];
            }
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    UIDeviceOrientation orien = [[UIDevice currentDevice] orientation];
    UIInterfaceOrientationMask orintation = (UIInterfaceOrientationMask)orien;
    if (orintation == UIInterfaceOrientationPortrait) {
        
        CGFloat pathY = self.scrollView.contentOffset.y;
        if (pathY < -100) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(shouldDismissView:)])
            {
                [self.delegate shouldDismissView:self];
            }
        }
    }
}
/*
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint startP = [touch locationInView:touch.view];
    
    self.beginPoint = startP;
    self.movePoint = startP;
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint endP = [touch locationInView:touch.view];

    self.movePoint = endP;
    
    UIDeviceOrientation orien = [[UIDevice currentDevice] orientation];
    UIInterfaceOrientationMask orintation = (UIInterfaceOrientationMask)orien;
    if (orintation == UIInterfaceOrientationPortrait) {
        
        CGFloat pathY = self.movePoint.y - self.beginPoint.y;
        if (pathY > 100) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(shouldDismissView:)]) {
                
                [self.delegate shouldDismissView:self];
            }
        }
    }
}
*/

@end
