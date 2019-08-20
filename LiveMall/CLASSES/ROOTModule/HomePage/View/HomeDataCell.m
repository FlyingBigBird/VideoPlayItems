//
//  HomeDataCell.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/21.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "HomeDataCell.h"

#define bottomH 85.0f

@implementation HomeDataCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setHomeDataCellSubs];
    }
    return self;
}
- (void)setHomeDataCellSubs
{
    self.bgV = [[UIView alloc] init];
    self.bgV.backgroundColor = [UIColor whiteColor];
    self.bgV.layer.masksToBounds = YES;
    self.bgV.layer.cornerRadius = 10;
    [self.contentView addSubview:self.bgV];
    self.bgV.layer.shadowColor = GGrayColor.CGColor;
    // 阴影偏移，默认(0, -3)
    self.bgV.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    self.bgV.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    self.bgV.layer.shadowRadius = 10;

 
    self.bgPic = [[UIImageView alloc] init];
    [self.bgV addSubview:self.bgPic];
    self.bgPic.image = [UIImage imageNamed:@"picBg"];
    [UIImageView setCurrentImageViewContentMode:self.bgPic];

    self.goodPic = [[UIImageView alloc] init];
    [self.bgV addSubview:self.goodPic];
    self.goodPic.image = [UIImage imageNamed:@"goodPic"];
    [UIImageView setCurrentImageViewContentMode:self.goodPic];
    self.goodPic.layer.masksToBounds = YES;
    self.goodPic.layer.cornerRadius = 5;
    
    self.goodsTit = [[UILabel alloc] init];
    [self.bgV addSubview:self.goodsTit];
    self.goodsTit.text = @"韩国dermafirm德妃紫苏水乳套装女舒缓肌肤保湿补水控油镇定正品";
    [self.goodsTit resetLabelCornerRadius:0 withTitleColor:GWhiteColor withBgColor:GClearColor withTitleFont:12 withNumberLine:0];

    self.detailLab = [[UILabel alloc] init];
    [self.bgV addSubview:self.detailLab];
    self.detailLab.text = @"#人类的四大本质 中国妈妈对宠物的态度";
    [self.detailLab resetLabelCornerRadius:0 withTitleColor:GBlackColor withBgColor:GClearColor withTitleFont:12 withNumberLine:0];
    
    
    self.headPic = [[UIImageView alloc] init];
    [self.bgV addSubview:self.headPic];
    self.headPic.image = [UIImage imageNamed:@"headImg"];
    [UIImageView setCurrentImageViewContentMode:self.goodPic];
    self.headPic.layer.masksToBounds = YES;
    
    self.nameLab = [[UILabel alloc] init];
    [self.bgV addSubview:self.nameLab];
    self.nameLab.text = @"129****0297";
    [self.nameLab resetLabelCornerRadius:0 withTitleColor:GGrayColor withBgColor:GClearColor withTitleFont:9 withNumberLine:1];
    
    self.heartImgV = [[UIImageView alloc] init];
    [self.bgV addSubview:self.heartImgV];
    self.heartImgV.image = [UIImage imageNamed:@"xin"];

    self.favNumLab = [[UILabel alloc] init];
    [self.bgV addSubview:self.favNumLab];
    self.favNumLab.text = @"81";
    self.favNumLab.adjustsFontSizeToFitWidth = YES;
    self.favNumLab.textAlignment = NSTextAlignmentCenter;
    [self.favNumLab resetLabelCornerRadius:0 withTitleColor:GDeepGrayColor withBgColor:GClearColor withTitleFont:9 withNumberLine:1];
    
}
- (void) cellData:(NSArray *)dataArr cellAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = dataArr[indexPath.row];
    if (image) {
        
        self.bgPic.image = image;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat saleWH = 50;
    CGFloat headWH = 20;
    CGFloat leftM = 10;
    CGFloat itemW = self.contentView.frame.size.width;
    CGFloat itemH = self.contentView.frame.size.height;
    
    self.bgV.frame = CGRectMake(0, 0, itemW, itemH);
    
    if (self.itemIndexPath.row % 3 == 0 && self.itemIndexPath.row != 0) {
        
        self.bgPic.frame = CGRectMake(0, 0, itemW, itemH - bottomH);
        self.goodPic.frame = CGRectMake(leftM, itemH - bottomH - saleWH + 15, saleWH, saleWH);
        self.goodsTit.frame = CGRectMake(leftM*2 + saleWH, itemH - bottomH - saleWH + 15, itemW - leftM * 3 - saleWH, saleWH - 15);
        self.detailLab.frame = CGRectMake(leftM, itemH - bottomH + 15 + 5, itemW - leftM * 2, 30);
        self.headPic.frame = CGRectMake(leftM, itemH - headWH - 15, headWH, headWH);
        self.headPic.layer.cornerRadius = self.headPic.frame.size.height / 2;
        self.nameLab.frame = CGRectMake(leftM * 2 + headWH, itemH - headWH - 15, itemW - leftM * 4 - 60, headWH);
        self.heartImgV.frame = CGRectMake(itemW - 10 - 20 - 15, itemH - headWH - 15 + 2.5, 15, 15);
        self.favNumLab.frame = CGRectMake(itemW - 10 - 20, itemH - headWH - 15, 20, headWH);

        self.goodPic.hidden = NO;
        self.goodsTit.hidden = NO;
        self.detailLab.hidden = NO;
        self.headPic.hidden = NO;
        self.nameLab.hidden = NO;
        self.heartImgV.hidden = NO;
        self.favNumLab.hidden = NO;
    } else {
        self.bgPic.frame = CGRectMake(0, 0, itemW, itemH);
        self.goodPic.hidden = YES;
        self.goodsTit.hidden = YES;
        self.detailLab.hidden = YES;
        self.headPic.hidden = YES;
        self.nameLab.hidden = YES;
        self.heartImgV.hidden = YES;
        self.favNumLab.hidden = YES;

    }

    
}

@end
