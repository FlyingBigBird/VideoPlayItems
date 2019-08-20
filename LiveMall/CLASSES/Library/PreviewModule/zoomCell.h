//
//  zoomCell.h
//  zoomScale_Sample
//
//  Created by BaoBaoDaRen on 16/9/29.
//  Copyright © 2016年 康振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreViewImageZoomView.h"

@interface zoomCell : UITableViewCell
{
    PreViewImageZoomView *imageView;
}

@property (nonatomic, retain)NSString *imgName;
@property (nonatomic, assign)CGSize size;

- (void)setLocalImage:(UIImage *)image;

@end
