//
//  zoomCell.m
//  zoomScale_Sample
//
//  Created by BaoBaoDaRen on 16/9/29.
//  Copyright © 2016年 康振超. All rights reserved.
//

#import "zoomCell.h"

@implementation zoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    imageView = [[PreViewImageZoomView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:imageView];
}

- (void)setImgName:(NSString *)imgName {
    
    if (_imgName != imgName) {
        _imgName = imgName;
    }
    [imageView resetViewFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    // 加载网络数据...
    //    [imageView uddateImageWithUrl:imgName];
    
    // 加载本地数据...
    //    [imageView updateLocalImage:imgName];
}

- (void)setLocalImage:(UIImage *)image
{
    [imageView resetViewFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    // 加载本地数据...
    [imageView updateLocalImage:image];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
