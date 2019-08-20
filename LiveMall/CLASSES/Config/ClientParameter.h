//
//  ClientParameter.h
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/20.
//  Copyright © 2019 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef ClientParameter_h
#define ClientParameter_h

typedef NS_ENUM(NSInteger, ImageDisplayType) {
    
    LoadImagesOnline,               //在线加载图片，只显示，不允许添加
    LoadImagesLocallyAllowsAdd,    //本地加载图片, 允许添加图片
    LoadImagesLocallyNotAllowsAdd, //本地加载图片, 不允许添加
};

typedef NS_ENUM(NSUInteger, AwemeType) {
  
    AwemeWork        = 0,
    AwemeFavorite    = 1
};

typedef NS_ENUM(NSUInteger, ClientOrientationMask) {

    ClientOrientationMaskPortrait,
    ClientOrientationMaskLandscapeLeft,
    ClientOrientationMaskLandscapeRight,
    ClientOrientationMaskPortraitUpsideDown,
    ClientOrientationMaskAll,
};

#endif /* ClientParameter_h */
