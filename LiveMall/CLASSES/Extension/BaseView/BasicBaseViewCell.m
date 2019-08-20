//
//  FotileBaseViewCell.m
//  FotileCSS
//
//  Created by Minimalism C on 2019/1/22.
//  Copyright © 2019 BaoBao. All rights reserved.
//

#import "BasicBaseViewCell.h"

#define Space_Left 10.0
#define TitleLab_W 100.0
#define TitleLab_H 20.0
#define DetailLab_Top 10.0
#define DetailLab_Bottom 10.0
#define DetailLab_Right 10.0
#define BasicCell_H 40.0

const static int orignalCellLabelHeight = 30;

@interface BasicBaseViewCell ()

/**
 * 左边title
 */
@property (nonatomic, strong) UILabel *titleLab;

/**
 * 右边detial
 */
@property (nonatomic, strong) UILabel *detailLab;

@end

@implementation BasicBaseViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupSubViews {
    
    WeakSelf(self)
    
    //下划线
    UIView *line = [UIView new];
    line.backgroundColor = GTableBGColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.offset(0);
        make.height.equalTo(1);
    }];
    
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(Space_Left);
        make.centerY.mas_equalTo(weakself.centerY);
        make.size.mas_equalTo(CGSizeMake(TitleLab_W, TitleLab_H));
    }];
    
    [self.contentView addSubview:self.detailLab];
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(DetailLab_Top);
        make.right.offset(-DetailLab_Right);
        make.bottom.offset(-DetailLab_Bottom);
        make.left.offset(Space_Left * 2 + TitleLab_W);
    }];
}

- (void)configureWithTitle:(NSString *)title {
    
    self.titleLab.text = title;
}

- (void)configureWithDetailInfo:(NSString *)detail {
    
    [self configureWithDetailInfo:detail andDetailLabelAlignment:NSTextAlignmentLeft];
}

- (void)configureWithDetailInfo:(NSString *)detail andDetailLabelAlignment:(NSTextAlignment)alignment {
    
    self.detailLab.text = L(detail);
    self.detailLab.textAlignment = alignment;
}

- (UILabel *)commenCellLabel {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor colorWithRed:46.9991 / 255.0 green:46.9991 / 255.0 blue:46.9991 / 255.0 alpha:1];
    return label;
}

#pragma mark - getter
- (UILabel *)titleLab {
    
    if (!_titleLab) {
        
        self.titleLab = [self commenCellLabel];
    }
    return _titleLab;
}

- (UILabel *)detailLab {
    
    if (!_detailLab) {
        
        self.detailLab = [self commenCellLabel];
        _detailLab.numberOfLines = 0;
    }
    return _detailLab;
}

+ (CGFloat)getCellHeightWithDetail:(NSString *)detail {
    
    CGFloat w = SCREEN_WIDTH - Space_Left * 3 - TitleLab_W;
    CGSize size = [NSString labelWidthWithText:L(detail) fondSize:14 width:w];
    CGFloat labelHeight = MAX(size.height, orignalCellLabelHeight);
    return BasicCell_H + (labelHeight - orignalCellLabelHeight + 10);
}

+ (CGFloat)getCellHeight {
    
    return BasicCell_H;
}

@end
