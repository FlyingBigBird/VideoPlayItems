//
//  HomePageView.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/20.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "HomePageView.h"

@interface HomePageView () <BasicNavigationBarViewDelegate>

// 推荐
@property (nonatomic, strong) UIButton *recommandBtn;
// 北京
@property (nonatomic, strong) UIButton *nearBtn;
// 中线
@property (nonatomic, strong) UIView *centerlineV;
// 底部线
@property (nonatomic, strong) UIImageView *lineImgV;

@end

@implementation HomePageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setHomePageViewSubs];
    }
    return self;
}

- (void)setHomePageViewSubs
{
    BasicNavigationBarView * customNavBar = [[BasicNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavBar_H + StatusBar_H)];
    customNavBar.delegate =  self;
    [customNavBar setNavigationBarWith:@"" andBGColor:GClearColor andTitleColor:GClearColor andImage:@"sousuo-copy" andHidLine:YES];
    [self addSubview:customNavBar];

    self.centerlineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 15)];
    [customNavBar addSubview:self.centerlineV];
    self.centerlineV.center = CGPointMake(SCREEN_WIDTH / 2, StatusBar_H + NavBar_H / 2);
    self.centerlineV.backgroundColor = GGrayColor;
    
    CGFloat btnW = 80;
    CGFloat btnH = 50;
    self.recommandBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - btnW, StatusBar_H + NavBar_H / 2 - btnH / 2, btnW, btnH)];
    [customNavBar addSubview:self.recommandBtn];
    [self.recommandBtn resetWithButton:self.recommandBtn withCornerRadius:0 withTitleColor:GBlackColor withBackColor:GClearColor withTitleFont:18];
    [self.recommandBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.recommandBtn setTitle:@"推荐" forState:UIControlStateNormal];
    self.recommandBtn.titleLabel.font = CUFont(18);
    
    self.nearBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, StatusBar_H + NavBar_H / 2 - btnH / 2, btnW, btnH)];
    [customNavBar addSubview:self.nearBtn];
    [self.nearBtn resetWithButton:self.nearBtn withCornerRadius:0 withTitleColor:GGrayColor withBackColor:GClearColor withTitleFont:16];
    [self.nearBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.nearBtn setTitle:@"北京" forState:UIControlStateNormal];
    
    self.lineImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btnH - 10, btnH - 15)];
    [customNavBar addSubview:self.lineImgV];
    self.lineImgV.image = [UIImage imageNamed:@"huxian"];
    self.lineImgV.center = CGPointMake(self.recommandBtn.center.x, self.recommandBtn.center.y + 15 / 2);
    
    [self.recommandBtn addTarget:self action:@selector(topBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.nearBtn addTarget:self action:@selector(topBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.homeScrolV.backgroundColor = [UIColor whiteColor];
    
}
- (void)topBtnClickedAction:(UIButton *)sender
{
    if ([sender isEqual:self.recommandBtn]) {
        
        [self.recommandBtn resetWithButton:self.recommandBtn withCornerRadius:0 withTitleColor:GBlackColor withBackColor:GClearColor withTitleFont:18];
        [self.nearBtn resetWithButton:self.nearBtn withCornerRadius:0 withTitleColor:GGrayColor withBackColor:GClearColor withTitleFont:16];
        self.recommandBtn.titleLabel.font = CUFont(18);
        self.lineImgV.center = CGPointMake(self.recommandBtn.center.x, self.recommandBtn.center.y + 15 / 2);
        self.homeScrolV.contentOffset = CGPointMake(0, 0);
    } else {
        [self.recommandBtn resetWithButton:self.recommandBtn withCornerRadius:0 withTitleColor:GGrayColor withBackColor:GClearColor withTitleFont:16];
        [self.nearBtn resetWithButton:self.nearBtn withCornerRadius:0 withTitleColor:GBlackColor withBackColor:GClearColor withTitleFont:18];
        self.nearBtn.titleLabel.font = CUFont(18);
        self.lineImgV.center = CGPointMake(self.nearBtn.center.x, self.nearBtn.center.y + 15 / 2);
        self.homeScrolV.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }
}

- (UIScrollView *)homeScrolV
{
    if (!_homeScrolV) {

        CGFloat scrolH = SCREEN_HEIGHT - NavBar_H - StatusBar_H - TabBar_H;
        _homeScrolV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavBar_H + StatusBar_H, SCREEN_WIDTH, scrolH)];
        _homeScrolV.scrollEnabled = NO;
        _homeScrolV.showsHorizontalScrollIndicator = NO;
        _homeScrolV.contentSize = CGSizeMake(SCREEN_WIDTH * 2, scrolH);
        [self addSubview:_homeScrolV];
        
        self.sellV = [[HomeSellView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, scrolH)];
        [_homeScrolV addSubview:self.sellV];
        [self.sellV setItemCount:50];
        
        self.nearV = [[HomeNearView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, scrolH)];
        [_homeScrolV addSubview:self.nearV];
        
    }
    return _homeScrolV;
}

- (void)customNavgationBarDidClicked
{
    // 标签搜索...
    if (self.searchBlock) {
        self.searchBlock();
    }
}

@end
