//
//  BasicNavigationBarView.m
//  FotileCSS
//
//  Created by BaoBaoDaRen on 2018/6/22.
//  Copyright © 2018年 康振超. All rights reserved.
//

#import "BasicNavigationBarView.h"

@interface BasicNavigationBarView ()

@property (nonatomic, strong) UIButton      * navLeftBtn;
@property (nonatomic, strong) UIImageView   * navLeftBtnImageView;
@property (nonatomic, strong) UILabel       * navTitleLab;
@property (nonatomic, strong) UIView        * navBOLine;
@property (nonatomic, strong) UIButton      * navRightBtn;
@property (nonatomic, strong) UIImageView   * navRightBtnImageView;
@property (nonatomic, strong) UIImageView   * navBgImageView;
@property (nonatomic, assign) CGFloat navImgWH;

@end

@implementation BasicNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.navImgWH = 22;
        [self setNavigationViewSubs];
        
    }
    return self;
}

- (void)setNavigationViewSubs
{
    self.navBgImageView = [[UIImageView alloc] init];
    [self addSubview:self.navBgImageView];
    self.navBgImageView.hidden = NO;
    
    self.navLeftBtn = [[UIButton alloc] init];
    [self addSubview:self.navLeftBtn];
    
    self.navLeftBtnImageView = [[UIImageView alloc] init];
    [self.navLeftBtn addSubview:self.navLeftBtnImageView];
    
    self.navTitleLab = [[UILabel alloc] init];
    [self addSubview:self.navTitleLab];
    self.navTitleLab.textAlignment = NSTextAlignmentCenter;
    
    self.navBOLine = [[UIView alloc] init];
    self.navBOLine.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    [self addSubview:self.navBOLine];
    
    [self.navLeftBtn addTarget:self action:@selector(NavgationBarLeftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.navRightBtn = [[UIButton alloc] init];
    [self addSubview:self.navRightBtn];
    
    self.navRightBtnImageView = [[UIImageView alloc] init];
    [self.navRightBtn addSubview:self.navRightBtnImageView];
    [self.navRightBtn addTarget:self action:@selector(navgationRightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navRightBtn.hidden = YES;
}

- (void)setCustomNavBarRightImage:(UIImage *)image
{
    self.navRightBtnImageView.image = image;
}

- (void)setCustomNavBarRightButtonHidden:(BOOL)hidden withImage:(UIImage *)image
{
    self.navRightBtn.hidden = hidden;
    self.navRightBtnImageView.hidden = hidden;
    self.navRightBtnImageView.image = image;
}

- (void)navgationRightBarButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customNavgationRightBarButtonClicked)]) {
        
        [self.delegate customNavgationRightBarButtonClicked];
    }
}

- (void)NavgationBarLeftButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customNavgationBarDidClicked)]) {
        
        [self.delegate customNavgationBarDidClicked];
    }
}

- (void)setCustomNavBarRightButtonTitle:(NSString *)rightTitle andTitleColor:(UIColor *)titleColor
{
    self.navRightBtn.hidden = NO;
    self.navRightBtnImageView.hidden = YES;
    self.navRightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.navRightBtn setTitle:rightTitle forState:UIControlStateNormal];
    [self.navRightBtn resetWithButton:self.navRightBtn withCornerRadius:0 withTitleColor:titleColor withBackColor:[UIColor clearColor] withTitleFont:16];
}

- (void)setNavigationBarWith:(NSString *)title andBGColor:(UIColor *)backGroundColor andTitleColor:(UIColor *)titleColor andImage:(NSString *)imgString andHidLine:(BOOL)hidLine
{
    self.backgroundColor = backGroundColor;
    
    [self.navTitleLab resetLabelCornerRadius:0 withTitleColor:titleColor withBgColor:[UIColor clearColor] withTitleFont:18 withNumberLine:1];
    
    self.navTitleLab.text = title;
    self.navLeftBtnImageView.image = [UIImage imageNamed:imgString];
    
    self.navBOLine.hidden = hidLine;
}

- (void)setCustomBarBgImage:(UIImage *)image
{
    self.navBgImageView.hidden = NO;
    self.navBgImageView.image = image;
}

- (void)setCustomBarTitle:(NSString *)title
{
    self.navTitleLab.text = title;
}
- (void)setCustomBarTitleColor:(UIColor *)titleColor
{
    self.navTitleLab.textColor = titleColor;
}

- (void)setCustomBarTitleFont:(CGFloat)titleFont
{
    self.navTitleLab.font = [UIFont systemFontOfSize:titleFont];
}

- (void)setCustomBarBoLineHidden:(BOOL)isHidden
{
    self.navBOLine.hidden = isHidden;
}

- (void)setCustomBarBackImageWidthHeight:(CGFloat)WH
{
    self.navImgWH = WH;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat leftMargint                = 0;
    CGFloat topMargin                  = StatusBar_H;
    CGFloat btnLabW                   = 55;
    CGFloat btnLabH                   = NavBar_H;
    
    CGFloat labW                       = self.frame.size.width;
    CGFloat imgWH                     = self.navImgWH;

    self.navBgImageView.frame        = self.bounds;
    self.navLeftBtn.frame              = CGRectMake(0, topMargin, btnLabW, btnLabH);
    self.navRightBtn.frame             = CGRectMake(self.frame.size.width - btnLabW, topMargin, btnLabW, btnLabH);
    
    self.navLeftBtnImageView.frame       = CGRectMake((self.navRightBtn.frame.size.width - imgWH) / 2, (btnLabH - imgWH) / 2, imgWH, imgWH);
    self.navRightBtnImageView.frame    = CGRectMake((self.navRightBtn.frame.size.width - imgWH) / 2, (btnLabH - imgWH) / 2, imgWH, imgWH);
    
    self.navTitleLab.frame             = CGRectMake(leftMargint + btnLabW, topMargin, labW - (leftMargint + btnLabW) * 2, btnLabH);
    
    self.navBOLine.frame               = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
}

@end
