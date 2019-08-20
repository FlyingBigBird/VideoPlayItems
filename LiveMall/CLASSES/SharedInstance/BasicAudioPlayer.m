//
//  BasicAudioPlayer.m
//  FotileCSS
//
//  Created by Minimalism C on 2018/11/27.
//  Copyright © 2018 BaoBao. All rights reserved.
//

#import "BasicAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

/**
 * 播放语音block
 */
typedef void(^PlayVoiceBlock)(void);

@interface BasicAudioPlayer ()<AVAudioPlayerDelegate>

//音乐播放器
@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, copy) PlayVoiceBlock finshBlock;

@end

@implementation BasicAudioPlayer

static BasicAudioPlayer *manager = nil;

+ (BasicAudioPlayer *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BasicAudioPlayer alloc] init];
    });
    return manager;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.player.delegate = self;
        [self setupNotifications];
    }
    return self;
}

/**
 * 配置音频会话相关
 */
- (void)configurationAVAudioSession {
    
    //创建音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    
    /**
     * AVAudioSession Category: 格式如下:
     
     是否允许音频播放/录音、是否打断其他不支持混音APP、是否会被静音键或锁屏键静音
     
     AVAudioSessionCategoryAmbient
     只支持播放
     否
     是
     
     AVAudioSessionCategoryAudioProcessing
     不支持播放，不支持录制
     是
     否
     
     AVAudioSessionCategoryMultiRoute
     支持播放，支持录制
     是
     否
     
     AVAudioSessionCategoryPlayAndRecord
     支持播放，支持录制
     默认YES，可以重写为NO
     否
     
     AVAudioSessionCategoryPlayback
     只支持播放
     默认YES，可以重写为NO
     否
     
     AVAudioSessionCategoryRecord
     只支持录制
     是
     否（锁屏下仍可录制）
     
     AVAudioSessionCategorySoloAmbient
     只支持播放
     是
     是
     
     * AVAudioSession Options:
     AVAudioSessionCategoryOptionAllowBluetooth: 允许蓝牙外接设备。兼容的Category: AVAudioSessionCategoryRecord、AVAudioSessionCategoryPlayAndRecord。
     AVAudioSessionCategoryOptionMixWithOthers: 支持和其他APP音频 mix。兼容的Category: AVAudioSessionCategoryPlayAndRecord、AVAudioSessionCategoryPlayback、AVAudioSessionCategoryMultiRoute。
     AVAudioSessionCategoryOptionDuckOthers: 系统智能调低其他APP音频音量。兼容的Category: AVAudioSessionCategoryPlayAndRecord、AVAudioSessionCategoryPlayback、AVAudioSessionCategoryMultiRoute。
     AVAudioSessionCategoryOptionDefaultToSpeaker: 设置默认输出音频到扬声器。兼容的Category: AVAudioSessionCategoryPlayAndRecord。
     */
    [session setCategory:AVAudioSessionCategoryPlayAndRecord
             withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionDuckOthers | AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    /**
     * 激活当前音频会话
     * 注意: AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation, 激活当前会话，播放当前应用的音频时，中断其他应用的音频播放.结束自己的应用音频后，若想恢复其他应用的音频，那就需要在关闭音频会话的时候设置AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation选项：
     * [session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation  error:NULL];
     */
    [session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    
    if (error) {
        
        NSLog(@"AVAudioSessionInterruptionOptionShouldResume失败:%@", [error localizedDescription]);
    }
}

/**
 播放的通知处理
 */
- (void)setupNotifications {
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    //添加意外中断音频播放的通知
    [notificationCenter addObserver:self
                           selector:@selector(handleInterruption:)
                               name:AVAudioSessionInterruptionNotification
                             object:[AVAudioSession sharedInstance]];
    
    //添加线路变化通知：耳机监听
    
    [notificationCenter addObserver:self
                           selector:@selector(hanldeRouteChange:)
                               name:AVAudioSessionRouteChangeNotification
                             object:[AVAudioSession sharedInstance]];
}

#pragma mark - 创建AVAudioPlayer与播放状态控制
/**
 创建音乐播放器
 
 @param fileName 文件名
 @param fileExtension 文件扩展名
 @return 播放器实例
 */
- (AVAudioPlayer *)createPlayForFile:(NSString *)fileName
                       withExtension:(NSString *)fileExtension {
    
    NSString *voicePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
    NSURL *url = [NSURL fileURLWithPath:voicePath];
    NSError *error = nil;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (audioPlayer) {
        
        //声道
        audioPlayer.pan = 0;
        
        //声音
        audioPlayer.volume = 1.0;
        
        //播放速率
        audioPlayer.rate = 1.0;
        
        //循环次数，-1无限循环
        audioPlayer.numberOfLoops = 0;
        
        //启动倍速控制
        audioPlayer.enableRate = YES;
    } else {
        NSLog(@"Error creating player: %@", [error localizedDescription]);
    }
    return audioPlayer;
}

- (AVAudioPlayer *)player {
    
    if (!_player) {
        
        self.player = [self createPlayForFile:@"WorkOrderReminder" withExtension:@"aac"];
    }
    return _player;
}

- (void)playVoiceBlock:(void (^)(void))block {
    
    if (block) {
        self.finshBlock = block;
    }
    
    [self addOperation];
}

//排队播放
- (void)addOperation {
    
    [[NSOperationQueue mainQueue] addOperation:[self customOperation]];
}

- (NSOperation *)customOperation {
    
    __weak __typeof__ (self) weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        [weakSelf play];
    }];
    return operation;
}

//播放
- (void)play {
    
    if (self.player == nil) { return; }
    
    if (!self.player.isPlaying) {
        
        if ([self.player prepareToPlay]) {
            
            [self.player play];
        }
    }
}

/**
 * 终止播放
 */
- (void)stop {
    
    if (self.player == nil) { return; }
    
    if (self.player.isPlaying) {
        
        [self.player stop];
        self.player.currentTime = 0.0f;
    }
}

/**
 * 暂停播放
 */
- (void)pause {
    
    if (self.player == nil) { return; }
    
    if (self.player.isPlaying) {
        
        [self.player pause];
    }
}

/**
 * 音频意外打断处理
 
 @param notification 通知信息
 */
- (void)handleInterruption:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    
    //处理会话中断
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    
    if (type == AVAudioSessionInterruptionTypeBegan) { // 音频会话中断开始, 处理音频中断
        
        //暂停播放
        [self pause];
    } else if (type == AVAudioSessionInterruptionTypeEnded) { // 音频会话中断结束, 处理重新播放音频
        
        //AVAudioSessionInterruptionOptions: 表明音频会话是否已经重新激活以及是否可以再次播放
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
        
        //配置音频会话
        [self configurationAVAudioSession];
        
        if (options == AVAudioSessionInterruptionOptionShouldResume) { //可重新激活会话，继续音频播放
            [self play];
        } else {
            [self play];
        }
    }
}

/**
 * 耳机监听事件处理
 
 @param notification 通知信息
 */
- (void)hanldeRouteChange:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    
    /**
     * 当耳机插入的时候，AVAudioSessionRouteChangeReason等于AVAudioSessionRouteChangeReasonNewDeviceAvailable，代表一个新外接设备可用，但是插入耳机，我们不需要处理。所以不做判断。
     
     * 当耳机拔出的时候 AVAudioSessionRouteChangeReason等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable，代表一个之前的外接设备不可用了，此时我们需要处理，让他播放器静音。
     
     * AVAudioSessionRouteChangePreviousRouteKey：当之前的线路改变的时候，获取到线路的描述对象：AVAudioSessionRouteDescription，然后获取到输出设备，判断输出设备的类型是否是耳机, 如果是就暂停播放
     */
    AVAudioSessionRouteChangeReason reason = [info[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    
    //老设备不可用
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        
        AVAudioSessionRouteDescription *previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *previousOutput = previousRoute.outputs[0];
        NSString *portType = previousOutput.portType;
        
        if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
            
            [self stop];
        }
    }
}

#pragma mark - AVAudioPlayerDelegate

//播放完成
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    if (self.finshBlock) {
        
        self.finshBlock();
    }
    NSLog(@"播放成功");
    
    [self configurationAVAudioSession];
}

//播放失败
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    
    NSLog(@"播放失败");
    [self configurationAVAudioSession];
}

//处理中断的代码
- (void)audioPlayerBeginInteruption:(AVAudioPlayer *)player {
    
}

//处理中断结束的代码
- (void)audioPlayerEndInteruption:(AVAudioPlayer *)player {
    
}

- (void)dealloc {
    
    if (self.player) { self.player = nil; }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
