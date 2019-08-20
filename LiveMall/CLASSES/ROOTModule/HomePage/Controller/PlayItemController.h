//
//  PlayItemController.h
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/25.
//  Copyright © 2019 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayItemController : UIViewController

@property (nonatomic, strong) UITableView                       *tableView;
@property (nonatomic, assign) NSInteger                         currentIndex;

-(instancetype)initWithVideoData:(NSMutableArray *)data currentIndex:(NSInteger)currentIndex pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize awemeType:(AwemeType)type uid:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
