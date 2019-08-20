//
//  ZCMediaPlayer.h
//  ZCAVPlayer
//
//  Created by BaoBaoDaRen on 17/3/23.
//  Copyright © 2017年 康振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreImage/CoreImage.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import <AVFoundation/AVFoundation.h>


@interface ZCMediaPlayer : UIView

/**
 播放器...
 */
@property(nonatomic,strong) AVPlayer *player;

/**
 播放目录
 */
@property(nonatomic,strong) AVPlayerItem *playerItme;

/**
  播放地址
 */
@property (nonatomic, strong) NSURL   *videoURL;

// 返回...
@property (nonatomic, strong) UIButton * backBtn;

// 倍速按钮...
@property (nonatomic, strong) UIButton * speedBtn;

@property (nonatomic, strong) UIButton * gifBtn;

/**
 界面滚动播放

 @param shouldPlay 是否播放...
 */
- (void)playerScrollToPlay:(BOOL)shouldPlay;

// 返回...
typedef void (^VideoBackBlock)(void);
@property (nonatomic, copy) VideoBackBlock backBlock;

// 截取视频...
typedef void (^InterceptVideoBlock)(NSError *error, NSURL *outPutUrl);
@property (nonatomic, copy) InterceptVideoBlock InterceptBlock;

// 制作gif
typedef void (^InterceptCompleteBlock) (NSError *error, NSURL *outPutUrl);
@property (nonatomic, copy) InterceptCompleteBlock completeBlock;

@end



