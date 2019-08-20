//
//  BasicAlertStyleView.m
//  FotileCSS
//
//  Created by BaoBaoDaRen on 2018/10/17.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import "BasicAlertStyleView.h"

@interface BasicAlertStyleView ()

@property (nonatomic, strong) UILabel * moneyNumLab;
@property (nonatomic, strong) UILabel * moneyFootLab;
@property (nonatomic, strong) UILabel * moneyUnitLab;

@end

@implementation BasicAlertStyleView

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andAmount:(NSString *)amount andSelectedType:(BOOL)isSelected
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self setBasicAlertStyleViewSubs:frame withTitle:title andAmount:amount isSelectd:isSelected];
    }
    return self;
}

- (void)setBasicAlertStyleViewSubs:(CGRect)supframe withTitle:(NSString *)title andAmount:(NSString *)amount isSelectd:(BOOL)isSelected
{
    self.inputBgShadowV = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.inputBgShadowV];
    self.inputBgShadowV.alpha = 0.7;
    self.inputBgShadowV.backgroundColor = [UIColor blackColor];
    
    self.inputInfoBgV = [[UIView alloc] initWithFrame:CGRectMake(25, self.frame.size.height / 2 - (SCREEN_HEIGHT / 2) / 2, self.frame.size.width - 50, SCREEN_HEIGHT / 5 * 2)];
    [self addSubview:self.inputInfoBgV];
    self.inputInfoBgV.backgroundColor = [UIColor whiteColor];
    self.inputInfoBgV.layer.masksToBounds = YES;
    self.inputInfoBgV.layer.cornerRadius = 4;
    
    // inputInfoBgV
    self.inputTitLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, self.inputInfoBgV.frame.size.width - 60, 20)];
    [self.inputInfoBgV addSubview:self.inputTitLab];
    [self.inputTitLab resetLabelCornerRadius:0 withTitleColor:[UIColor colorWithHexString:@"#333333"] withBgColor:[UIColor clearColor] withTitleFont:18 withNumberLine:1];
    self.inputTitLab.textAlignment = NSTextAlignmentCenter;
    
    self.lineImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.inputInfoBgV.frame.size.width, 1)];
    [self.inputInfoBgV addSubview:self.lineImgV];
    self.lineImgV.image = [UIImage imageNamed:@"curveCellLine"];
    
    self.remindLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.inputInfoBgV.frame.size.width, 50)];
    self.remindLab.textAlignment = NSTextAlignmentCenter;
    [self.inputInfoBgV addSubview:self.remindLab];
    self.remindLab.text = @"提交后不能修改，请核实工单内容！";
    [self.remindLab resetLabelCornerRadius:0 withTitleColor:[UIColor colorWithHexString:@"#FF3737"] withBgColor:GClearColor withTitleFont:14 withNumberLine:1];

    self.bgV = [[UIView alloc] initWithFrame:CGRectMake(30, self.inputInfoBgV.frame.size.height / 2 - 20, self.inputInfoBgV.frame.size.width - 60, 60)];
    [self.inputInfoBgV addSubview:self.bgV];
    
    self.desCancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, self.inputInfoBgV.frame.size.height - 15 - 50, 100, 40)];
    [self.inputInfoBgV addSubview:self.desCancelBtn];
    [self.desCancelBtn resetWithButton:self.desCancelBtn withCornerRadius:2 withTitleColor:[UIColor whiteColor] withBackColor:[UIColor colorWithHexString:@"#bababa"] withTitleFont:16];
    
    self.desEnsureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.inputInfoBgV.frame.size.width - 30 - 100, self.inputInfoBgV.frame.size.height - 15 - 50, 100, 40)];
    [self.inputInfoBgV addSubview:self.desEnsureBtn];
    [self.desEnsureBtn resetWithButton:self.desEnsureBtn withCornerRadius:2 withTitleColor:[UIColor whiteColor] withBackColor:[UIColor colorWithHexString:BackBlackColor] withTitleFont:16];
    
    self.inputTitLab.text = title;
    
    [self.desCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.desEnsureBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    [self.desCancelBtn addTarget:self action:@selector(textInputViewEndEdtingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.desEnsureBtn addTarget:self action:@selector(textInputViewEndEdtingAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat moneyNumW = 100;
    self.moneyNumLab = [[UILabel alloc] init];
    [self.bgV addSubview:self.moneyNumLab];
    
    self.moneyNumLab.textAlignment = NSTextAlignmentCenter;
    self.moneyNumLab.adjustsFontSizeToFitWidth = YES;
    [self.moneyNumLab resetLabelCornerRadius:0 withTitleColor:GBlackColor withBgColor:GClearColor withTitleFont:32 withNumberLine:1];
    [self.moneyNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.bgV.mas_bottom).offset(-15);
        make.centerX.mas_equalTo(self.bgV.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(moneyNumW, 25));
    }];
    self.moneyFootLab = [[UILabel alloc] init];
    [self.bgV addSubview:self.moneyFootLab];
    [self.moneyFootLab resetLabelCornerRadius:0 withTitleColor:[UIColor colorWithHexString:@"#979797"] withBgColor:GClearColor withTitleFont:15 withNumberLine:1];
    [self.moneyFootLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.bgV.mas_bottom).offset(-15);
        make.left.mas_equalTo(self.moneyNumLab.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(30, 15));
        
    }];
    self.moneyUnitLab = [[UILabel alloc] init];
    [self.bgV addSubview:self.moneyUnitLab];
    [self.moneyUnitLab resetLabelCornerRadius:0 withTitleColor:GBlackColor withBgColor:GClearColor withTitleFont:25 withNumberLine:1];
    [self.moneyUnitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.bgV.mas_bottom).offset(-15);
        make.right.mas_equalTo(self.moneyNumLab.mas_left).offset(5);
        
        make.size.mas_equalTo(CGSizeMake(30, 15));
    }];
    
    self.moneyUnitLab.text = @"￥";
    self.moneyFootLab.text = @"元";
    if (IsStrEmpty(amount)) {
        
        self.moneyNumLab.text = @"0.00";
    } else {
        
        self.moneyNumLab.text = LEmpty(amount);
    }
}

- (void)chargeMoneyAmount:(NSString *)amount
{
    self.moneyNumLab.text = amount;
}

- (void)textInputViewEndEdtingAction:(UIButton *)sender
{
    if ([sender isEqual:self.desCancelBtn]) {
        
        // 取消...
        if (self.alertBlock) {
        
            self.alertBlock(NO);
        }
    } else {
      
        // 确认...
        if (self.alertBlock) {
            
            self.alertBlock(YES);
        }
    }
    
    [self removeFromSuperview];
}

@end
