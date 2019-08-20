//
//  ZCMediaPlayer.m
//  ZCAVPlayer
//
//  Created by BaoBaoDaRen on 17/3/23.
//  Copyright © 2017年 康振超. All rights reserved.
//
#import "ZCMediaPlayer.h"
#import "ZCMediaPlayerMaskView.h"

// 获取沙盒 Document
#define PathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
// 获取沙盒 Cache
#define PathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

const CFStringRef kUTTypeGIF;

typedef NS_ENUM(NSInteger, GIFSize)
{
    GIFSizeVeryLow = 2,
    GIFSizeLow = 3,
    GIFSizeMedium = 5,
    GIFSizeHigh = 7,
    GIFSizeOriginal = 10
};

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, //横向移动
    PanDirectionVerticalMoved    //纵向移动
};

//播放器的几种状态
typedef NS_ENUM(NSInteger, ZFPlayerState) {
   
    ZCPlayerStateBuffering,  //缓冲中
    ZCPlayerStatePlaying,    //播放中
    ZCPlayerStateStopped,    //停止播放
    ZCPlayerStatePause       //暂停播放
};

/*
 The only supported values are 0.50, 0.67, 0.80, 1.0, 1.25, 1.50, and 2.0. All other settings are rounded to nearest value.
 */
// 视频播放倍速
typedef NS_ENUM(NSUInteger, ZCVideoRate) {
   
    VideoRateSpeedCustom,
    VideoRateSpeedLitterFast,
    VideoRateSpeedHigh,
    VideoRateSpeedFull,
};


@interface ZCMediaPlayer ()<UIGestureRecognizerDelegate>
{
    CGRect currentFrame;
}
@property(nonatomic,strong)AVPlayerLayer *playerLayer;

@property(nonatomic,strong)ZCMediaPlayerMaskView *maskView;

@property(nonatomic,assign)CGRect smallFrame;
@property(nonatomic,assign)CGRect bigFrame;

// 定义一个实例变量，保存枚举值
@property (nonatomic, assign) PanDirection panDirection;
@property (nonatomic, assign) ZFPlayerState playState;


@property (nonatomic, assign)BOOL isDragSlider;
// 是否暂停
@property (nonatomic, assign) BOOL    isPauseByUser;

// 滑杆
@property (nonatomic, strong) UISlider  *volumeViewSlider;
@property (assign, nonatomic)  BOOL      isProgressHid;

// 播放速度枚举...
@property (nonatomic, assign) ZCVideoRate rateType;

@property (nonatomic, strong) NSURL *playUrl;


@end


@implementation ZCMediaPlayer

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        currentFrame = frame;
        
        self.isProgressHid = NO;
        self.rateType = VideoRateSpeedCustom;

        self.smallFrame = frame;
        self.bigFrame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        
        self.player = [AVPlayer playerWithURL:[NSURL URLWithString:@""]];
        
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
        //控制内容的填充方式 //代优化
        if([self.playerLayer.videoGravity isEqualToString:AVLayerVideoGravityResizeAspect]){
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        }else{
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        }
        [self.layer insertSublayer:self.playerLayer atIndex:0];
        
        self.maskView = [[ZCMediaPlayerMaskView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.maskView];
        
        [self.maskView.fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        // 播放按钮点击事件
        [self.maskView.startBtn addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // slider开始滑动事件
        [self.maskView.videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [self.maskView.videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [self.maskView.videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        
        // 返回
        self.backBtn = [[UIButton alloc] init];
        [self.backBtn setImage:[UIImage imageNamed:@"icon--fanhui"] forState:UIControlStateNormal];
        [self.backBtn addTarget:self action:@selector(backButtonAction)  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backBtn];
        
        
        // 倍速
        self.speedBtn = [[UIButton alloc] init];
        [self.speedBtn setTintColor:[UIColor whiteColor]];
        self.speedBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.speedBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.speedBtn setTitle:@"倍速x1.0" forState:UIControlStateNormal];
        [self addSubview:self.speedBtn];
        [self.speedBtn addTarget:self action:@selector(speedButtonAction) forControlEvents:UIControlEventTouchUpInside];

        
        self.gifBtn = [[UIButton alloc] init];
        [self addSubview:self.gifBtn];
        [self.gifBtn setTitle:@"gif" forState:UIControlStateNormal];
        self.gifBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.gifBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.gifBtn addTarget:self action:@selector(gifButtonAction) forControlEvents:UIControlEventTouchUpInside];

        
        // app退到后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        // app进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [self listeningRotating];
        [self setTheProgressOfPlayTime];
        [self getVolumeVolue];
        
        // 添加平移手势，用来控制音量、亮度、快进快退
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
        pan.delegate                = self;
        [self addGestureRecognizer:pan];
        
        
        
        //双击
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTapGesture];
        
        //单击
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        [tapGesture setNumberOfTapsRequired:1];
        [self addGestureRecognizer:tapGesture];
        
        //双击失败之后执行单击
        [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
        
        [self timerShow];
    }
    return self;
}
- (void)timerShow
{
    NSTimer *hidTimer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(screenHiddenBegin:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:hidTimer forMode:NSRunLoopCommonModes];
}
- (void)screenHiddenBegin:(NSTimer *)timer
{
    self.isProgressHid = NO;
    [self singleTapAction];
    [timer invalidate];
    timer = nil;
}
- (void)enableVideoTracks:(BOOL)enable inPlayerItem:(AVPlayerItem*)playerItem
{
    for (AVPlayerItemTrack *track in playerItem.tracks)
    {
        if ([track.assetTrack.mediaType isEqual:AVMediaTypeVideo])
        {
            NSLog(@"currentVideoFrameRate:%f",track.currentVideoFrameRate);
            track.enabled = enable;
        }
    }
}
- (void)singleTapAction
{
    self.isProgressHid = !self.isProgressHid;
    
    self.gifBtn.hidden = self.isProgressHid;
    self.speedBtn.hidden = self.isProgressHid;
    self.backBtn.hidden = self.isProgressHid;
    self.maskView.progressView.hidden = self.isProgressHid;
    self.maskView.totalTimeLabel.hidden = self.isProgressHid;
    self.maskView.videoSlider.hidden = self.isProgressHid;
    self.maskView.volumeProgress.hidden = self.isProgressHid;
    self.maskView.startBtn.hidden = self.isProgressHid;
    self.maskView.fullScreenBtn.hidden = self.isProgressHid;
    self.maskView.currentTimeLabel.hidden = self.isProgressHid;
    
    if (self.isProgressHid == NO) {
        
        [self timerShow];
    }
}
- (void)doubleTapAction
{
    [self startAction:self.maskView.startBtn];
}


#pragma mark - Volume 系统音量
-(void)getVolumeVolue
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            
            [self addSubview:_volumeViewSlider];
         break;
        }
    }
    _volumeViewSlider.frame = CGRectMake(-1000, -1000, 100, 100);
    
    
    /* 马上获取不到值 */
    [self performSelector:@selector(afterOneSecond) withObject:nil afterDelay:1];
}

-(void)afterOneSecond
{
    self.maskView.volumeProgress.progress = _volumeViewSlider.value;
}


#pragma mark - slider事件

// slider开始滑动事件
- (void)progressSliderTouchBegan:(UISlider *)slider
{
    self.isDragSlider = YES;
}

// slider滑动中事件
- (void)progressSliderValueChanged:(UISlider *)slider
{
     CGFloat total   = (CGFloat)self.playerItme.duration.value / self.playerItme.duration.timescale;
    
    CGFloat current = total*slider.value;
    //秒数
    NSInteger proSec = (NSInteger)current%60;
    //分钟
    NSInteger proMin = (NSInteger)current/60;
    self.maskView.currentTimeLabel.text    = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
}

// slider结束滑动事件
- (void)progressSliderTouchEnded:(UISlider *)slider
{
    //计算出拖动的当前秒数
    CGFloat total           = (CGFloat)self.playerItme.duration.value / self.playerItme.duration.timescale;
    
    NSInteger dragedSeconds = floorf(total * slider.value);
    
    //转换成CMTime才能给player来控制播放进度
    
    CMTime dragedCMTime     = CMTimeMake(dragedSeconds, 1);

    [self endSlideTheVideo:dragedCMTime];
    
}

// 滑动结束视频跳转
- (void)endSlideTheVideo:(CMTime)dragedCMTime
{
    [self.player pause];
    [self.maskView.activity startAnimating];
    
    [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish){

        // 如果点击了暂停按钮
        [self.maskView.activity stopAnimating];
        if (self.isPauseByUser) {
            //NSLog(@"已暂停");
            self.isDragSlider = NO;
            return ;
        }

        if ((self.maskView.progressView.progress - self.maskView.videoSlider.value) > 0.01) {
        
            [self.maskView.activity stopAnimating];
            
            [self changeCurrentSpeedRate];
            [self.player play];
        }
        else
        {
            [self bufferingSomeSecond];
            
        }
        self.isDragSlider = NO;
    }];

}


// 播放、暂停
- (void)startAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        self.isPauseByUser = NO;
        
        [self changeCurrentSpeedRate];
        [_player play];
        
        self.playState = ZCPlayerStatePlaying;
        
    } else {
        
        [_player pause];
        self.isPauseByUser = YES;
        self.playState = ZCPlayerStatePause;
    }
}
- (void)playerScrollToPlay:(BOOL)shouldPlay
{
    if (shouldPlay == YES) {
        self.isPauseByUser = NO;
        
        [self changeCurrentSpeedRate];
        [_player play];
        
        self.playState = ZCPlayerStatePlaying;
        
    } else {
        
        [_player pause];
        self.isPauseByUser = YES;
        self.playState = ZCPlayerStatePause;
    }
}

//设置播放进度和时间
-(void)setTheProgressOfPlayTime
{
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        
        //如果是拖拽slider中就不执行.
        
        if (weakSelf.isDragSlider) {
            return ;
        }
        
        float current=CMTimeGetSeconds(time);
        float total=CMTimeGetSeconds([weakSelf.playerItme duration]);
        
        if (current) {
            [weakSelf.maskView.videoSlider setValue:(current/total) animated:YES];
        }
        
        //秒数
        NSInteger proSec = (NSInteger)current%60;
        //分钟
        NSInteger proMin = (NSInteger)current/60;
        
        //总秒数和分钟
        NSInteger durSec = (NSInteger)total%60;
        NSInteger durMin = (NSInteger)total/60;
        weakSelf.maskView.currentTimeLabel.text    = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        weakSelf.maskView.totalTimeLabel.text      = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    } ];
}


- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    // arc下
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

-(void)fullScreenBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self interfaceOrientation:(sender.selected==YES)?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait];
}


-(void)setVideoURL:(NSURL *)videoURL
{
    self.playUrl = videoURL;
    self.isProgressHid = NO;
    self.rateType = VideoRateSpeedCustom;

    //将之前的监听时间移除掉。
    [self.playerItme removeObserver:self forKeyPath:@"status"];
    [self.playerItme removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItme removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItme removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    self.playerItme = nil;
    
    self.playerItme = [AVPlayerItem playerItemWithURL:videoURL];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItme];
    
    // AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    
    // 监听播放状态
    [self.playerItme addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监听loadedTimeRanges属性
    [self.playerItme addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    // Will warn you when your buffer is empty
    [self.playerItme addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    // Will warn you when your buffer is good to go again.
    [self.playerItme addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    [self changeCurrentSpeedRate];
    [self.player play];
    
    self.maskView.startBtn.selected = YES;
    self.playState = ZCPlayerStatePlaying;
    [self.maskView.activity startAnimating];
    
}

#pragma mark - 监听设备旋转方向

- (void)listeningRotating{
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
}

- (void)onDeviceOrientationChange{

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    
    [self transformScreenDirection:interfaceOrientation];
    
}


-(void)transformScreenDirection:(UIInterfaceOrientation)direction
{
    
    if (direction == UIInterfaceOrientationPortrait )
    {
        self.frame = self.smallFrame;
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        
    }else if(direction == UIInterfaceOrientationLandscapeRight || direction == UIInterfaceOrientationLandscapeLeft)
    {
        self.frame = self.bigFrame;
        
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

#pragma mark - NSNotification Action
// 播放完了
- (void)moviePlayDidEnd:(NSNotification *)notification
{
    NSLog(@"播放完了");
    
    [_player seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finish){

        [self.maskView.videoSlider setValue:0.0 animated:YES];
        self.maskView.currentTimeLabel.text = @"00:00";
        
        [self.player play];
    }];
    
//    self.playState = ZCPlayerStateStopped;
//    self.maskView.startBtn.selected = NO;
    
}

// 应用退到后台
- (void)appDidEnterBackground
{
    [_player pause];
    self.playState = ZCPlayerStatePause;
}

// 应用进入前台
- (void)appDidEnterPlayGround
{
    [self changeCurrentSpeedRate];

    if (self.playState == ZCPlayerStatePlaying) {
       
        [_player play];
    } else {
       
        [_player pause];
    }
}


#pragma mark - KVO
/**
 AVPlayerItem状态观察
 
 @param keyPath 路径
 @param object AVPlayerItem
 @param change 状态变化...
 @param context nil
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self.playerItme) {
        if ([keyPath isEqualToString:@"status"]) {
            
            if (self.player.status == AVPlayerStatusReadyToPlay) {
                
                self.playState = ZCPlayerStatePlaying;
            } else if (self.player.status == AVPlayerStatusFailed){
                
                [self.maskView.activity startAnimating];
            }
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
           
            NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
            CMTime duration             = self.playerItme.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            [self.maskView.progressView setProgress:timeInterval / totalDuration animated:NO];
            
        }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            
//            NSLog(@"playbackBufferEmpty:%d",self.playerItme.playbackBufferEmpty);
            
            // 当缓冲是空的时候
            if (self.playerItme.playbackBufferEmpty) {
                self.playState = ZCPlayerStateBuffering;
                [self bufferingSomeSecond];
            }
            
        }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            // 当缓冲好的时候
            NSLog(@"playbackLikelyToKeepUp:%d",self.playerItme.playbackLikelyToKeepUp);
            
            if (self.playerItme.playbackLikelyToKeepUp){
                NSLog(@"playbackLikelyToKeepUp");
                self.playState = ZCPlayerStatePlaying;
            }
        } else {
            
        }
    }
}

- (void)bufferingSomeSecond
{
    
    [self.maskView.activity startAnimating];
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    static BOOL isBuffering = NO;
    if (isBuffering) {
        return;
    }
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser) {
            isBuffering = NO;
            return;
        }
       
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        
        //播放缓冲区已满的时候 在播放否则继续缓冲
//         [self.player play];
       
        
        /** 是否缓冲好的标准 （系统默认是1分钟。不建议用 ）*/
        //self.playerItme.isPlaybackLikelyToKeepUp
        
        if ((self.maskView.progressView.progress - self.maskView.videoSlider.value) > 0.01) {
            self.playState = ZCPlayerStatePlaying;
           
            [self changeCurrentSpeedRate];
            [self.player play];
        }
        else
        {
            [self bufferingSomeSecond];
        }
    });
}





- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.playerLayer.frame = self.bounds;
    self.maskView.frame = self.bounds;
    
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    self.backBtn.frame = CGRectMake(10, 44, 40, 40);
    self.speedBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - 50, 44, 50, 40);
    self.gifBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - 50 - self.speedBtn.frame.size.width - 40, 44, 40, 40);

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.playerItme removeObserver:self forKeyPath:@"status"];
    [self.playerItme removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItme removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItme removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    
    NSLog(@"%s",__func__);
    
}


#pragma mark - 平移手势方法

- (void)panDirection:(UIPanGestureRecognizer *)pan
{
//    //根据在view上Pan的位置，确定是调音量还是亮度
//    CGPoint locationPoint = [pan locationInView:self];
//    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                self.panDirection           = PanDirectionHorizontalMoved;
                self.isDragSlider = YES;

            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    [self progressSliderValueChanged:self.maskView.videoSlider];
                    
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self progressSliderTouchEnded:self.maskView.videoSlider];
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}


- (void)verticalMoved:(CGFloat)value
{
        // 更改系统的音量
        self.volumeViewSlider.value      -= value / 10000;// 越小幅度越小

}
-(void)horizontalMoved:(CGFloat)value
{
    self.maskView.videoSlider.value += value/10000;
}

- (void)backButtonAction
{
    if (self.backBlock) {
        
        self.backBlock();
    }
}

#pragma mark - Setter
-(void)setPlayState:(ZFPlayerState)playState
{
    if (playState != ZCPlayerStateBuffering) {
        [self.maskView.activity stopAnimating];
    }
    _playState = playState;
}

- (void)speedButtonAction
{
    [self changePlaySpeedState];
}
- (void)changePlaySpeedState
{
    if (self.rateType == VideoRateSpeedCustom) {
        
        self.rateType = VideoRateSpeedLitterFast;
    } else if(self.rateType == VideoRateSpeedLitterFast) {
        
        self.rateType = VideoRateSpeedHigh;
    } else if(self.rateType == VideoRateSpeedHigh) {
        
        self.rateType = VideoRateSpeedFull;
    } else if(self.rateType == VideoRateSpeedFull) {
        
        self.rateType = VideoRateSpeedCustom;
    } else {
        
        self.rateType = VideoRateSpeedCustom;
    }
    
    [self changeCurrentSpeedRate];
}
- (void)changeCurrentSpeedRate
{
    NSString *speedRate = @"1.0";
    // 修改播放速度...
    if (self.rateType == VideoRateSpeedLitterFast) {
        
        speedRate = @"1.25";
    } else if (self.rateType == VideoRateSpeedHigh) {
        
        speedRate = @"1.5";
    } else if (self.rateType == VideoRateSpeedFull) {
        
        speedRate = @"2.0";
    } else {
        
        speedRate = @"1.0";
    }
    
    [self.speedBtn setTitle:[NSString stringWithFormat:@"倍速x%@",speedRate] forState:UIControlStateNormal];
    self.player.rate = [speedRate floatValue];
    [self enableVideoTracks:YES inPlayerItem:self.playerItme];
}


#pragma mark - 点击gif按钮...
- (void)gifButtonAction
{
    NSString *videoPath = [NSString stringWithFormat:@"%@",PathDocument];
    NSString *gifPath = [NSString stringWithFormat:@"%@/gif",PathDocument];
    [self interceptVideoAndVideoUrl:self.playUrl withOutPath:videoPath outputFileType:AVFileTypeMPEG4 range:NSMakeRange(1, 10) intercept:^(NSError *error, NSURL *outPutUrl) {
        
        // 视频裁剪...
        if (outPutUrl.absoluteString.length <= 0) {
            
            return ;
        } else {
          // 获取路径下文件..,
            
            NSArray *arr = [[NSArray alloc] initWithContentsOfFile:[outPutUrl absoluteString]];
            NSLog(@"arr:%@",arr);
            NSString *getFileStr = arr[0];
            NSURL *getUrl = [NSURL URLWithString:getFileStr];
//            self.playerItme = [AVPlayerItem playerItemWithURL:outPutUrl];
//            [self.player replaceCurrentItemWithPlayerItem:self.playerItme];

            /*
            [self createGIFfromURL:outPutUrl loopCount:1 delayTime:0.25 gifImagePath:gifPath complete:^(NSError *error, NSURL *outPutUrl) {
                
                // gif制作...
                UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2 - 150, SCREEN_WIDTH, 300)];
                [self.superview addSubview:imgV];
                UIImage *img = [UIImage imageWithContentsOfFile:gifPath];
                imgV.image = img;
                UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

                NSLog(@"gifPath:%@    outPutUrl:%@",gifPath,outPutUrl);
                
            }];
             */
        }
    }];
}



#pragma mark -截取视频
/**
 @param videoUrl 视频的URL
 @param outPath 输出路径
 @param outputFileType 输出视频格式
 @param videoRange 截取视频的范围
 @param interceptBlock 视频截取的回调
 */
- (void)interceptVideoAndVideoUrl:(NSURL *)videoUrl withOutPath:(NSString *)outPath outputFileType:(NSString *)outputFileType range:(NSRange)videoRange intercept:(InterceptVideoBlock)interceptBlock {
    
    //不添加背景音乐
    NSURL *audioUrl =nil;
    //AVURLAsset此类主要用于获取媒体信息，包括视频、声音等
    AVURLAsset* audioAsset = [[AVURLAsset alloc] initWithURL:audioUrl options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    
    //创建AVMutableComposition对象来添加视频音频资源的AVMutableCompositionTrack
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    //CMTimeRangeMake(start, duration),start起始时间，duration时长，都是CMTime类型
    //CMTimeMake(int64_t value, int32_t timescale)，返回CMTime，value视频的一个总帧数，timescale是指每秒视频播放的帧数，视频播放速率，（value / timescale）才是视频实际的秒数时长，timescale一般情况下不改变，截取视频长度通过改变value的值
    //CMTimeMakeWithSeconds(Float64 seconds, int32_t preferredTimeScale)，返回CMTime，seconds截取时长（单位秒），preferredTimeScale每秒帧数
    
    //开始位置startTime
    CMTime startTime = CMTimeMakeWithSeconds(videoRange.location, videoAsset.duration.timescale);
    //截取长度videoDuration
    CMTime videoDuration = CMTimeMakeWithSeconds(videoRange.length, videoAsset.duration.timescale);
    
    CMTimeRange videoTimeRange = CMTimeRangeMake(startTime, videoDuration);
    
    //视频采集compositionVideoTrack
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // 避免数组越界 tracksWithMediaType 找不到对应的文件时候返回空数组
    //TimeRange截取的范围长度
    //ofTrack来源
    //atTime插放在视频的时间位置
    [compositionVideoTrack insertTimeRange:videoTimeRange ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeVideo].count>0) ? [videoAsset tracksWithMediaType:AVMediaTypeVideo].firstObject : nil atTime:kCMTimeZero error:nil];
    
    
    //视频声音采集(也可不执行这段代码不采集视频音轨，合并后的视频文件将没有视频原来的声音)
    AVMutableCompositionTrack *compositionVoiceTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [compositionVoiceTrack insertTimeRange:videoTimeRange ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeAudio].count>0)?[videoAsset tracksWithMediaType:AVMediaTypeAudio].firstObject:nil atTime:kCMTimeZero error:nil];
    
    //声音长度截取范围==视频长度
    CMTimeRange audioTimeRange = CMTimeRangeMake(kCMTimeZero, videoDuration);
    
    //音频采集compositionCommentaryTrack
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [compositionAudioTrack insertTimeRange:audioTimeRange ofTrack:([audioAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) ? [audioAsset tracksWithMediaType:AVMediaTypeAudio].firstObject : nil atTime:kCMTimeZero error:nil];
    
    //AVAssetExportSession用于合并文件，导出合并后文件，presetName文件的输出类型
    AVAssetExportSession *assetExportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetPassthrough];
    
    //混合后的视频输出路径
    NSURL *outPutURL = [NSURL fileURLWithPath:outPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outPath error:nil];
    }
    
    //输出视频格式 outputFileType:mov或mp4及其它视频格式
    assetExportSession.outputFileType = outputFileType;
    assetExportSession.outputURL = outPutURL;
    //输出文件是否网络优化
    assetExportSession.shouldOptimizeForNetworkUse = YES;
    
    [assetExportSession exportAsynchronouslyWithCompletionHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            switch (assetExportSession.status) {
                
                case AVAssetExportSessionStatusFailed:
                    
                    if (interceptBlock) {
                        
                        interceptBlock(assetExportSession.error,outPutURL);
                    }
                    
                    break;
                    
                case AVAssetExportSessionStatusCancelled:{
                    
                    NSLog(@"Export Status: Cancell");
                    
                    break;
                }
                case AVAssetExportSessionStatusCompleted: {
                    
                    if (interceptBlock) {
                        
                        interceptBlock(nil,outPutURL);
                    }
                    
                    break;
                }
                case AVAssetExportSessionStatusUnknown: {
                    
                    NSLog(@"Export Status: Unknown");
                }
                case AVAssetExportSessionStatusExporting : {
                    
                    NSLog(@"Export Status: Exporting");
                }
                case AVAssetExportSessionStatusWaiting: {
                    
                    NSLog(@"Export Status: Wating");
                }
            }
        });
    }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString * msg = nil;
    
    if (error == nil) {
        msg = @"保存失败";
    } else {
        msg = @"保存成功";
    }
    NSLog(@"照片【%@】======== error:%@",msg, error);
    
}
#pragma mark--制作GIF
/**
 @param videoURL 视频的路径URL
 @param loopCount 播放次数 0即无限循环
 @param time 每帧的时间间隔 默认0.25s
 @param imagePath 存放GIF图片的文件路径
 @param completeBlock 完成的回调
 */
- (void)createGIFfromURL:(NSURL*)videoURL loopCount:(int)loopCount delayTime:(CGFloat )time gifImagePath:(NSString *)imagePath complete:(InterceptCompleteBlock)completeBlock {
    
    float delayTime = time?:0.25;
    
    // Create properties dictionaries
    NSDictionary *fileProperties = [self filePropertiesWithLoopCount:loopCount];
    NSDictionary *frameProperties = [self framePropertiesWithDelayTime:delayTime];
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoURL];
    
    float videoWidth = SCREEN_WIDTH;
    float videoHeight = 300;
    
    GIFSize optimalSize = GIFSizeMedium;
    if (videoWidth >= 1200 || videoHeight >= 1200)
        optimalSize = GIFSizeVeryLow;
    else if (videoWidth >= 800 || videoHeight >= 800)
        optimalSize = GIFSizeLow;
    else if (videoWidth >= 400 || videoHeight >= 400)
        optimalSize = GIFSizeMedium;
    else if (videoWidth < 400|| videoHeight < 400)
        optimalSize = GIFSizeHigh;
    
    // Get the length of the video in seconds
    float videoLength = (float)asset.duration.value/asset.duration.timescale;
    NSLog(@" value:%f   ====  timescale:%d",(float)asset.duration.value, asset.duration.timescale);
    int framesPerSecond = 4;
    int frameCount = videoLength*framesPerSecond;
    
    // How far along the video track we want to move, in seconds.
    float increment = (float)videoLength/frameCount;
    
    // Add frames to the buffer
    NSMutableArray *timePoints = [NSMutableArray array];
    for (int currentFrame = 0; currentFrame<frameCount; ++currentFrame) {
        float seconds = (float)increment * currentFrame;
        CMTime time = CMTimeMakeWithSeconds(seconds, 600);
        [timePoints addObject:[NSValue valueWithCMTime:time]];
    }
    
    
    //completion block
    NSURL *gifURL = [self createGIFforTimePoints:timePoints fromURL:videoURL fileProperties:fileProperties frameProperties:frameProperties gifImagePath:imagePath frameCount:frameCount gifSize:GIFSizeMedium];
    
    if (completeBlock) {
        // Return GIF URL
        completeBlock(nil,gifURL);
    }
}

#pragma mark - Base methods
- (NSURL *)createGIFforTimePoints:(NSArray *)timePoints fromURL:(NSURL *)url fileProperties:(NSDictionary *)fileProperties  frameProperties:(NSDictionary *)frameProperties gifImagePath:(NSString *)imagePath frameCount:(int)frameCount gifSize:(GIFSize)gifSize{
    
    NSURL *fileURL = [NSURL fileURLWithPath:imagePath];
    if (fileURL == nil)
        return nil;
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF , frameCount, NULL);
    CGImageDestinationSetProperties(destination, (CFDictionaryRef)fileProperties);
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    
    NSError *error = nil;
    CGImageRef previousImageRefCopy = nil;
    for (NSValue *time in timePoints) {
        CGImageRef imageRef;
        
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
        imageRef = (float)gifSize/10 != 1 ? createImageWithScale([generator copyCGImageAtTime:[time CMTimeValue] actualTime:nil error:&error], (float)gifSize/10) : [generator copyCGImageAtTime:[time CMTimeValue] actualTime:nil error:&error];
#elif TARGET_OS_MAC
        imageRef = [generator copyCGImageAtTime:[time CMTimeValue] actualTime:nil error:&error];
#endif
        
        if (error) {
            
            NSLog(@"Error copying image: %@", error);
            return nil;
            
        }
        if (imageRef) {
            CGImageRelease(previousImageRefCopy);
            previousImageRefCopy = CGImageCreateCopy(imageRef);
        } else if (previousImageRefCopy) {
            imageRef = CGImageCreateCopy(previousImageRefCopy);
        } else {
            
            error =[NSError errorWithDomain:NSStringFromClass([self class]) code:0 userInfo:@{NSLocalizedDescriptionKey:@"Error copying image and no previous frames to duplicate"}];
            NSLog(@"Error copying image and no previous frames to duplicate");
            return nil;
        }
        CGImageDestinationAddImage(destination, imageRef, (CFDictionaryRef)frameProperties);
        CGImageRelease(imageRef);
    }
    CGImageRelease(previousImageRefCopy);
    
    // Finalize the GIF
    if (!CGImageDestinationFinalize(destination)) {
        
        error =[NSError errorWithDomain:NSStringFromClass([self class]) code:0 userInfo:@{NSLocalizedDescriptionKey:@"Error copying image and no previous frames to duplicate"}];
        NSLog(@"Failed to finalize GIF destination: %@", error);
        if (destination != nil) {
            CFRelease(destination);
        }
        return nil;
    }
    CFRelease(destination);
    
    return fileURL;
}

#pragma mark - Helpers

CGImageRef createImageWithScale(CGImageRef imageRef, float scale) {
    
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    CGSize newSize = CGSizeMake(CGImageGetWidth(imageRef)*scale, CGImageGetHeight(imageRef)*scale);
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return nil;
    }
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    //Release old image
    CFRelease(imageRef);
    // Get the resized image from the context and a UIImage
    imageRef = CGBitmapContextCreateImage(context);
    
    UIGraphicsEndImageContext();
#endif
    
    return imageRef;
}

#pragma mark - Properties

- (NSDictionary *)filePropertiesWithLoopCount:(int)loopCount {
    return @{(NSString *)kCGImagePropertyGIFDictionary:
                 @{(NSString *)kCGImagePropertyGIFLoopCount: @(loopCount)}
             };
}

- (NSDictionary *)framePropertiesWithDelayTime:(float)delayTime {
    
    return @{(NSString *)kCGImagePropertyGIFDictionary:
                 @{(NSString *)kCGImagePropertyGIFDelayTime: @(delayTime)},
             (NSString *)kCGImagePropertyColorModel:(NSString *)kCGImagePropertyColorModelRGB
             };
}

@end
