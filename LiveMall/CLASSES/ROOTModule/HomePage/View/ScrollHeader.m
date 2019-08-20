//
//  ScrollHeader.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/21.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "ScrollHeader.h"

@interface ScrollHeader ()

@property (nonatomic, strong) UIScrollView *itemScrlV;
@property (nonatomic, assign, readonly) NSInteger numCount;
@property (nonatomic, strong) NSArray   *dataArr;

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) UIButton *selectBtn;
@property (nonatomic, strong) UIImageView *pointImgV;

@end

@implementation ScrollHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _itemArr = [NSArray array];
        self.selectIndex = 0;
    }
    return self;
}
- (NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}
-(void)setItemArr:(NSArray *)itemArr
{
    _numCount = itemArr.count;
    self.dataArr = itemArr;
    if (_numCount <= 0) {
        
        for (id subV in self.subviews) {
            
            [subV removeFromSuperview];
        }
        self.selectIndex = 0;
    } else {
     
        [self headerUiShow];
    }
}
- (void)headerUiShow
{
    if (_itemScrlV) {
        [_itemScrlV removeFromSuperview];
    }

    _itemScrlV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
    [self addSubview:_itemScrlV];
    _itemScrlV.showsHorizontalScrollIndicator = NO;
    _itemScrlV.pagingEnabled = NO;
    _itemScrlV.scrollEnabled = YES;
    
    CGFloat leftM = 15;
    CGFloat itemM = 15;
    CGFloat itemH = self.frame.size.height;
    __block CGFloat contentWidth = leftM;
    __block CGFloat getLeftEdge = 5;
    
    self.pointImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, itemH)];
    self.pointImgV.image = [UIImage imageNamed:@"huxian"];
    [_itemScrlV addSubview:self.pointImgV];


    WeakSelf(self);
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        
        NSString *getTit = FORMAT(@"%@",self.dataArr[idx]);
        CGFloat getFont = 16;

        CGFloat getW = [NSString labelHeightWithText:getTit fondSize:getFont height:itemH].width + 10;
        contentWidth = contentWidth + getW + itemM;
        weakself.itemScrlV.contentSize = CGSizeMake(contentWidth + 65, itemH);
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(getLeftEdge, 0, getW, itemH)];
        getLeftEdge = getLeftEdge + getW + itemM;
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.tag = idx;
        [btn addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];

        [btn resetWithButton:btn withCornerRadius:0 withTitleColor:GBlackColor withBackColor:GClearColor withTitleFont:14];
        [btn setTitle:getTit forState:UIControlStateNormal];
        [weakself.itemScrlV addSubview:btn];
        
        if (idx == 0) {
            
            weakself.selectBtn = btn;
            btn.titleLabel.font = CUFont(getFont);
            
            weakself.pointImgV.center = btn.center;
        }
    }];
}
- (void)buttonClickedAction:(UIButton *)sender
{
    [self selectItemAtIndex:sender.tag];
}
- (void)selectItemAtIndex:(NSInteger)index
{
    _selectIndex = index;
    _selectBtn.titleLabel.font = Font(14);
    
    if (_itemClick) {
        _itemClick(self.selectIndex);
    }
    
    for (id subV in self.itemScrlV.subviews) {
        
        if ([subV isKindOfClass:UIButton.class]) {
            
            UIButton *btn = subV;
            if (btn.tag == _selectIndex) {
                
                _selectBtn = btn;
                _selectBtn.titleLabel.font = CUFont(16);
                [UIView transitionWithView:self.pointImgV duration:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
                    self.pointImgV.center = self.selectBtn.center;
                    
                    CGFloat contentSize = self.itemScrlV.contentSize.width;
                    CGFloat MAXOffsetX = 256.5;// 动态可变
                    CGFloat MINIndex = 3;// 动态可变
                    if (contentSize > SCREEN_WIDTH) {
                        
                        CGFloat getW = (contentSize - 60 - SCREEN_WIDTH) / 3 * (index - 2);
                        if (index >= MINIndex) {
                            
                            if (getW <= MAXOffsetX) {
                             
                                self.itemScrlV.contentOffset = CGPointMake(getW, 0);
                            } else {
                                self.itemScrlV.contentOffset = CGPointMake(MAXOffsetX, 0);
                            }
                        } else if (index < MINIndex)
                        {
                            self.itemScrlV.contentOffset = CGPointMake(0, 0);
                        } else {
 
                        }
                    }
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
    }
}

@end


