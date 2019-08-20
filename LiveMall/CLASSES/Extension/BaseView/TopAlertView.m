//
//  TopAlertView.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/24.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "TopAlertView.h"

@interface TopAlertView ()

@property (nonatomic, strong) UIImageView *bgImgV;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titLab;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIImageView *rightImgV;
@property (nonatomic, strong) NSTimer *getTimer;

@end
@implementation TopAlertView

- (instancetype)initWithImage:(UIImage * _Nullable )image title:(NSString * _Nullable)title superView:(UIView * _Nullable)supView
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavBar_H + StatusBar_H)];
    if (self) {
        
        self.frame = CGRectMake(0, - NavBar_H - StatusBar_H * 2, SCREEN_WIDTH, NavBar_H + StatusBar_H);
        if ([supView isKindOfClass:[NSNull class]] || supView == nil) {
            
            [[UIApplication sharedApplication].delegate.window addSubview:self];
        } else {
            [supView addSubview:self];
        }
        self.backgroundColor = [UIColor redColor];
        [self setTopAlertImage:image title:title];
    }
    return self;
}
- (void)setTopAlertImage:(UIImage *)image title:(NSString * _Nullable)title
{
    self.bgImgV = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.bgImgV];
    CGFloat imgWH = 15;
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, StatusBar_H + NavBar_H / 2 - imgWH / 2, imgWH, imgWH)];
    [self addSubview:self.imageV];
    self.imageV.image = image;
    
    self.titLab = [[UILabel alloc] init];
    [self addSubview:self.titLab];
    self.titLab.text = title;
    [self.titLab resetLabelCornerRadius:0 withTitleColor:GWhiteColor withBgColor:GClearColor withTitleFont:12 withNumberLine:2];
    if ([image isKindOfClass:[NSNull class]] || image == nil) {
        
        self.imageV.hidden = YES;
        CGFloat labH = 40;
        self.titLab.frame = CGRectMake(15, StatusBar_H + NavBar_H / 2 - labH / 2, SCREEN_WIDTH - 15 - 50, labH);
    } else {
        self.imageV.hidden = NO;
        CGFloat labH = 40;
        self.titLab.frame = CGRectMake(15*2+imgWH, StatusBar_H + NavBar_H / 2 - labH / 2, SCREEN_WIDTH - 15*2 - imgWH - 50, labH);
    }
    CGFloat btnWH = NavBar_H;
    CGFloat rightImgWH = 20;
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - NavBar_H, StatusBar_H + NavBar_H / 2 - btnWH / 2, btnWH, btnWH)];
    [self addSubview:self.rightBtn];
    self.rightImgV = [[UIImageView alloc] initWithFrame:CGRectMake(btnWH - rightImgWH, btnWH / 2 - rightImgWH / 2, rightImgWH, rightImgWH)];
    [self.rightBtn addSubview:self.rightImgV];
    self.rightImgV.hidden = YES;
    
}
- (void)rightItemClickedItem
{
    if (self.showBlock) {
        self.showBlock();
    }
}
- (void)changeBackgroundColor:(UIColor *)backColor
{
    self.backgroundColor = backColor;
}
- (void)rightBarItemImage:(UIImage *)image finished:(ShowDetailBlock)complete
{
    self.showBlock = complete;
    
    [self.rightBtn addTarget:self action:@selector(rightItemClickedItem) forControlEvents:UIControlEventTouchUpInside];

    self.rightImgV.hidden = NO;
    self.rightImgV.image = image;
}
- (void)changeBackgroundImage:(UIImage *)backImage
{
    self.bgImgV.image = backImage;
}
-(void)showWithAnimation:(BOOL)isAnimate
{
    if (isAnimate == YES) {
        
        WeakSelf(self);
        [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, NavBar_H + StatusBar_H);
        } completion:^(BOOL finished) {
            
            NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(shouldHidAlert:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            weakself.getTimer = timer;
        }];
    } else {
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, NavBar_H + StatusBar_H);
    }
}
- (void)shouldHidAlert :(NSTimer *)timer
{
    [timer invalidate];
    timer = nil;
    
    [UIView transitionWithView:self duration:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.frame = CGRectMake(0, - NavBar_H - StatusBar_H * 2, SCREEN_WIDTH, NavBar_H + StatusBar_H);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}
- (void)dealloc
{
    if (self.getTimer) {
        
        [self.getTimer invalidate];
        self.getTimer = nil;
    }
}

@end
