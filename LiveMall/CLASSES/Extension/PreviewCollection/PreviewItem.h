//
//  PreviewItem.h
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/7/15.
//  Copyright © 2019 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreviewItem : UICollectionViewCell

- (void) localImage:(UIImage *)image;

- (void) webImageUrl:(NSString *)imgUrl;

@end

NS_ASSUME_NONNULL_END
