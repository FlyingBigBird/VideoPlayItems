//
//  ZCMediaPlayerMaskView.m
//  ZCAVPlayer
//
//  Created by BaoBaoDaRen on 17/3/23.
//  Copyright © 2017年 康振超. All rights reserved.
//

#import "ZCMediaPlayerMaskView.h"
#import <AVFoundation/AVFoundation.h>

@interface ZCMediaPlayerMaskView ()

// bottom渐变层
@property (nonatomic, strong) CAGradientLayer *bottomGradientLayer;
// top渐变层
@property (nonatomic, strong) CAGradientLayer *topGradientLayer;
// bottomView
@property (strong, nonatomic)  UIImageView     *bottomImageView;
// topView
@property (strong, nonatomic)  UIImageView     *topImageView;


@end

@implementation ZCMediaPlayerMaskView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                        
        self.topImageView = [[UIImageView alloc]init];
        self.bottomImageView = [[UIImageView alloc]init];
        self.bottomImageView.userInteractionEnabled = YES;
        
        self.startBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,50,50)];
        self.startBtn.imageEdgeInsets = UIEdgeInsetsMake(15,20,15,10);

        UIImage *unselectImg = [UIImage imageNamed:@"tableactivation"];
        [self.startBtn setImage:unselectImg forState:UIControlStateNormal];
        
        UIImage *selectImg = [UIImage imageNamed:@"tablesuspend"];
        [self.startBtn setImage:selectImg forState:UIControlStateSelected];
        self.fullScreenBtn = [[UIButton alloc]init];
        
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"quanping"] forState:UIControlStateNormal];
        self.fullScreenBtn.imageEdgeInsets = UIEdgeInsetsMake(15,10,15,20);

        self.currentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10,60, 30)];
        self.currentTimeLabel.text = @"00:00";
        self.currentTimeLabel.textColor = [UIColor whiteColor];
        self.currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.currentTimeLabel.font = [UIFont systemFontOfSize:15];
        self.totalTimeLabel = [[UILabel alloc]init];
        self.totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.totalTimeLabel.font = [UIFont systemFontOfSize:15];
        self.totalTimeLabel.textColor = [UIColor whiteColor];
        self.totalTimeLabel.text = @"00:00";
        
    
        self.progressView = [[UIProgressView alloc]init];
        self.progressView.progressTintColor    = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        self.progressView.trackTintColor       = [UIColor clearColor];
        
        self.volumeProgress = [[UIProgressView alloc]init];
        self.volumeProgress.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.volumeProgress.progressTintColor    = [self colorWithHexString:@"#1296db"];
        self.volumeProgress.trackTintColor       = [UIColor whiteColor];
        

        // 设置slider
        self.videoSlider = [[UISlider alloc]init];
        [self.videoSlider setThumbImage:[UIImage imageNamed:@"yuandianxiao"] forState:UIControlStateNormal];
        self.videoSlider.minimumTrackTintColor = [self colorWithHexString:@"#1296db"];
        self.videoSlider.maximumTrackTintColor = [UIColor whiteColor];
        
        
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomImageView];
        // 初始化渐变层
        [self initCAGradientLayer];

        
        self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        [self.bottomImageView addSubview:self.startBtn];
        [self.bottomImageView addSubview:self.fullScreenBtn];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        [self.bottomImageView addSubview:self.progressView];
        [self.bottomImageView addSubview:self.videoSlider];
        [self addSubview:self.volumeProgress];
        
        [self addSubview:self.activity];

        NSError *error;
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        
        // add event handler, for this example, it is `volumeChange:` method
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];

    }
    return self;
}


#define DEFAULT_VOID_COLOR [UIColor whiteColor]
- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
    {
        return DEFAULT_VOID_COLOR;
    }
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return DEFAULT_VOID_COLOR;
    }
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (void)volumeChanged:(NSNotification *)notification
{
    // service logic here.
    NSLog(@"%@",notification.userInfo);
    NSString *valueStr = notification.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"];
    self.volumeProgress.progress = [valueStr floatValue];
    
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.topImageView.frame = CGRectMake(0, 0,width, 50);
    self.bottomImageView.frame = CGRectMake(0,height-50, width, 50);
    self.bottomGradientLayer.frame = self.bottomImageView.bounds;
    self.topGradientLayer.frame    = self.topImageView.bounds;
    
    self.fullScreenBtn.frame = CGRectMake(width-50,0,50,50);
    
    CGFloat progressWidth = width-2*(self.startBtn.frame.size.width+self.currentTimeLabel.frame.size.width);
    
    self.progressView.frame = CGRectMake(0,0,progressWidth,20);
    self.progressView.center = CGPointMake(width/2, 25);
    self.totalTimeLabel.frame = CGRectMake(width-110,10,60,30);
    self.videoSlider.frame = self.progressView.frame;
    self.activity.center = CGPointMake(width/2, height/2);
    self.volumeProgress.bounds = CGRectMake(0, 0,100,30);
    self.volumeProgress.center = CGPointMake(40,height/2);
        
}

- (void)initCAGradientLayer
{
    //初始化Bottom渐变层
    self.bottomGradientLayer            = [CAGradientLayer layer];
    [self.bottomImageView.layer addSublayer:self.bottomGradientLayer];
    //设置渐变颜色方向
    self.bottomGradientLayer.startPoint = CGPointMake(0, 0);
    self.bottomGradientLayer.endPoint   = CGPointMake(0, 1);
    //设定颜色组
    self.bottomGradientLayer.colors     = @[(__bridge id)[UIColor clearColor].CGColor,
                                            (__bridge id)[UIColor blackColor].CGColor];
    //设定颜色分割点
    self.bottomGradientLayer.locations  = @[@(0.0f) ,@(1.0f)];
    
    
    //初始Top化渐变层
    self.topGradientLayer               = [CAGradientLayer layer];
    [self.topImageView.layer addSublayer:self.topGradientLayer];
    //设置渐变颜色方向
    self.topGradientLayer.startPoint    = CGPointMake(1, 0);
    self.topGradientLayer.endPoint      = CGPointMake(1, 1);
    //设定颜色组
    self.topGradientLayer.colors        = @[ (__bridge id)[UIColor blackColor].CGColor,
                                             (__bridge id)[UIColor clearColor].CGColor];
    //设定颜色分割点
    self.topGradientLayer.locations     = @[@(0.0f) ,@(1.0f)];
    
}


-(void)dealloc
{
    NSLog(@"%s",__func__);
    
[[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    

}

@end
