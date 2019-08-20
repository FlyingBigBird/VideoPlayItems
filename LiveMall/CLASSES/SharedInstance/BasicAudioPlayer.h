//
//  BasicAudioPlayer.h
//  FotileCSS
//
//  Created by Minimalism C on 2018/11/27.
//  Copyright © 2018 BaoBao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BasicAudioPlayer : NSObject

/**
 * 语音播放单列
 */
+ (BasicAudioPlayer *)sharedInstance;

/**
 * 配置音频会话相关
 */
- (void)configurationAVAudioSession;

/**
 * 开始播放本地语音
 */
- (void)playVoiceBlock:(void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
