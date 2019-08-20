//
//  PreviewClubPictureViewController.h
//  The_Month_Club
//
//  Created by BaoBaoDaRen on 16/10/4.
//  Copyright © 2016年 康振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewClubPictureViewController : UIViewController
{
    BOOL showNavBar;
}

/**
 *  底部编辑视图...
 */
@property (nonatomic, strong) UIView * previewEditView;

/**
 *  是否显示底部编辑视图...
 */
@property (nonatomic, assign) BOOL hidEditView;

/**
 *  传入一个iamgeUrl加载以预览图片...
 */
@property (nonatomic, strong) NSMutableArray * imageArray;

/**
 *  照片描述文字label
 */
@property (nonatomic, strong) UILabel * desLabel;

/**
 *  上传时添加的描述...
 */
@property (nonatomic, strong) NSMutableArray * descriptionArray;

/**
 *  照片的编号...
 */
@property (nonatomic, strong) NSMutableArray * dataCodeArray;

/**
 *  从某张图片开始轮播...
 */
@property (nonatomic, assign) NSInteger beginIndex;

/**
 *  底部控制视图...
 */
@property (nonatomic, strong) UIView * bottomControlView;

/**
 照片处理类型
 */
@property (nonatomic, copy) NSString * preDataModel;

@end
