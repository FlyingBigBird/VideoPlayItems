//
//  SharedInstance.h
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/20.
//  Copyright © 2019 Boris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SharedEntity : NSObject

+ (SharedEntity *)SharedInstance;

// 只能主页面单层调用...
- (void) doPush:(UIViewController *)controller animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
