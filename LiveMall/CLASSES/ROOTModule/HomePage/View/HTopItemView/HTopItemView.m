//
//  HTopItemView.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/7/1.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "HTopItemView.h"

@interface HTopItemView ()

@property (nonatomic, assign) CGFloat topH;

@end

@implementation HTopItemView

- (instancetype)initWithFrame:(CGRect)frame
                     typeData:(NSArray *)data
                    compelete:(DataTypeCallBack)compelete
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selectType = compelete;
        
        self.topH = 250;
        self.bgImgV = [[UIImageView alloc] initWithFrame:self.bounds];
        self.bgImgV.backgroundColor = [UIColor blackColor];
        self.bgImgV.alpha = 0.5;
        [self addSubview:self.bgImgV];
        
        //单击
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapsAction)];
        [tapGesture setNumberOfTapsRequired:1];
        [self addGestureRecognizer:tapGesture];
        
        
        [self showTypeInfo:data];
    }
    return self;
}
- (void)TapsAction
{
    [UIView transitionWithView:self.topV duration:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.topV.frame = CGRectMake(0, - self.topH - 10, SCREEN_WIDTH, self.topH);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}
- (void)showTypeInfo:(NSArray *)data
{
    if (data.count > 0) {
        
        NSInteger squareNum = data.count;// (photoArr.count)
        
        CGFloat squareTopM = NavBar_H + StatusBar_H;
        CGFloat leftM = 0;
        CGFloat topM = 25;
        CGFloat botM = 25;
        
        NSInteger horizonNum = 5;
        NSInteger verticalNum = 2;
        
        CGFloat horizonM = 0;
        CGFloat verticalM = 20;
        
        CGFloat selectedW = 40;
        CGFloat selectedH = 40;
        
        CGFloat labH = 20;

        UIImage *titImage = [UIImage imageNamed:@"calendar"];
        
        CGFloat sqBtnW = SCREEN_WIDTH / horizonNum;
        CGFloat sqBtnH = 70;
        
        CGFloat topVH = NavBar_H + StatusBar_H + topM + verticalM * (verticalNum-1) + (verticalNum *sqBtnH) + botM;
        self.topH = topVH;
        self.topV = [[UIView alloc] initWithFrame:CGRectMake(0, - topVH - 10, SCREEN_WIDTH, topVH)];
        [self addSubview:self.topV];
        self.topV.backgroundColor = [UIColor whiteColor];
        self.topV.hidden = YES;
        // 给创客背景图添加半圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.topV.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.topV.bounds;
        maskLayer.path = maskPath.CGPath;
        self.topV.layer.mask = maskLayer;

        
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(0, StatusBar_H + 15, SCREEN_WIDTH, NavBar_H)];
        titLab.textAlignment = NSTextAlignmentCenter;
        [self.topV addSubview:titLab];
        [titLab resetLabelCornerRadius:0 withTitleColor:GBlackColor withBgColor:GClearColor withTitleFont:15 withNumberLine:1];
        titLab.font = CUFont(18);
        titLab.text = @"全部分类";

        for (int i = 0; i < squareNum; i++)
        {
            CGFloat getLeftM = leftM + i % horizonNum * sqBtnW + i % horizonNum * horizonM;
            CGFloat getTopM = topM + i / horizonNum * sqBtnH + i / horizonNum * verticalM + squareTopM;
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(getLeftM, getTopM, sqBtnW, sqBtnH)];
            [self.topV addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(itemClickedAtIndex:) forControlEvents:UIControlEventTouchUpInside];

            UIImageView * imagV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, selectedW, selectedH)];
            imagV.center = CGPointMake(sqBtnW / 2, 10 + selectedH / 2);
            [btn addSubview:imagV];
            imagV.image = titImage;
            
            UILabel * titLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 15 + selectedH, sqBtnW, labH)];
            titLab.adjustsFontSizeToFitWidth = YES;
            [btn addSubview:titLab];
            titLab.textAlignment = NSTextAlignmentCenter;
            titLab.text = data[i];
            [titLab resetLabelCornerRadius:0 withTitleColor:GBlackColor withBgColor:GClearColor withTitleFont:13 withNumberLine:1];
        }
    }
    
    [UIView transitionWithView:self.topV duration:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.topV.hidden = NO;
        self.topV.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.topH);
    } completion:nil];
}
- (void)itemClickedAtIndex:(UIButton *)sender
{
    if (self.selectType) {
        self.selectType(sender.tag);
    }
    
    [UIView transitionWithView:self.topV duration:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.topV.frame = CGRectMake(0, - self.topH - 10, SCREEN_WIDTH, self.topH);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}


@end
