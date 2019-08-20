//
//  ZCMediaPlayerMaskView.h
//  ZCAVPlayer
//
//  Created by BaoBaoDaRen on 17/3/23.
//  Copyright © 2017年 康振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCMediaPlayerMaskView : UIView


// 开始播放按钮
@property (strong, nonatomic)  UIButton       *startBtn;
// 当前播放时长
@property (strong, nonatomic)  UILabel        *currentTimeLabel;
// 视频总时长
@property (strong, nonatomic)  UILabel        *totalTimeLabel;
// 进度条
@property (strong, nonatomic)  UIProgressView *progressView;
// 滑东条
@property (strong, nonatomic)  UISlider       *videoSlider;
// 全屏按钮
@property (strong, nonatomic)  UIButton       *fullScreenBtn;
@property (strong, nonatomic)  UIButton       *lockBtn;
// 音量进度
@property (nonatomic,strong) UIProgressView   *volumeProgress;

// 系统菊花
@property (nonatomic,strong)UIActivityIndicatorView *activity;


@end
