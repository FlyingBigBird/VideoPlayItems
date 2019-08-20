//
//  zoomCellView.h
//  zoomScale_Sample
//
//  Created by BaoBaoDaRen on 16/9/29.
//  Copyright © 2016年 康振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zoomCellView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain)NSArray *imgs;
@property (nonatomic, assign) NSInteger selectIndex;

- (instancetype)initWithFrame:(CGRect)frame imageSize:(CGSize)size;
- (void)updateImageDate:(NSArray *)imageArr selectIndex:(NSInteger)index;

@end
