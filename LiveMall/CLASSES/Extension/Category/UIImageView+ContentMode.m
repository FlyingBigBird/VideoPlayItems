//
//  UIImageView+ContentMode.m
//  TravelWorldSample
//
//  Created by BaoBaoDaRen on 2017/8/1.
//  Copyright © 2017年 康振超. All rights reserved.
//

#import "UIImageView+ContentMode.h"

@implementation UIImageView (ContentMode)

+ (void)setCurrentImageViewContentMode:(UIImageView *)imageView
{
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
}

@end
