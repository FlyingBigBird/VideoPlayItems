//
//  UIImage+Compression.h
//  FotileCSS
//
//  Created by baobao on 16/08/31.
//  Copyright (c) 2016年 baobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compression)
/**
 *  图片压缩
 *
 *  @param sourceImage   被压缩的图片
 *  @param defineWidth 被压缩的尺寸(宽)
 *
 *  @return 被压缩的图片
 */
+ (UIImage *)imageCompressed:(UIImage *)sourceImage withdefineWidth:(CGFloat)defineWidth;

- (UIImage *)drawRoundedRectImage:(CGFloat)cornerRadius width:(CGFloat)width height:(CGFloat)height;

- (UIImage *)drawCircleImage;

@end
