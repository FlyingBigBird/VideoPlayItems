//
//  BasicAlertStyleView.h
//  FotileCSS
//
//  Created by BaoBaoDaRen on 2018/10/17.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicAlertStyleView : UIView

@property (nonatomic, strong) UIView * inputBgShadowV;
@property (nonatomic, strong) UIView * inputInfoBgV;
@property (nonatomic, strong) UIImageView  * lineImgV;
@property (nonatomic, strong) UILabel      * remindLab;
@property (nonatomic, strong) UILabel * inputTitLab;
@property (nonatomic, strong) UIView  * bgV;
@property (nonatomic, strong) UIButton * desCancelBtn;
@property (nonatomic, strong) UIButton * desEnsureBtn;

typedef void (^AlertClickBlock)(BOOL isSelected);
@property (nonatomic, copy) AlertClickBlock alertBlock;

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andAmount:(NSString *)amount andSelectedType:(BOOL)isSelected;
- (void)chargeMoneyAmount:(NSString *)amount;

@end
