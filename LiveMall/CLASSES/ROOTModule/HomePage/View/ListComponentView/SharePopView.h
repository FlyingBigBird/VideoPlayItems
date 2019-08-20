//
//  SharePopView.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SharePopViewDelegate <NSObject>

@optional
- (void)actionClickedAtIndex:(NSInteger)index;// 保存/举报
@optional
- (void)itemClickedAtIndex:(NSInteger)index;// 微信/朋友圈

@end

@interface SharePopView:UIView

@property (nonatomic, strong) UIView           *container;
@property (nonatomic, strong) UIButton         *cancel;

@property (nonatomic, weak) id <SharePopViewDelegate> delegate;


- (void)show;
- (void)dismiss;

@end


@interface ShareItem:UIView

@property (nonatomic, strong) UIImageView      *icon;
@property (nonatomic, strong) UILabel          *label;

-(void)startAnimation:(NSTimeInterval)delayTime;

@end
