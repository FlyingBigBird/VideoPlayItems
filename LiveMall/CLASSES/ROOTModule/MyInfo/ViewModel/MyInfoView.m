//
//  MyInfoView.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/26.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "MyInfoView.h"
#import "MenuPopView.h"

@interface MyInfoView () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = GClearColor;
        self.infoTab.backgroundColor = GTableBGColor;
    }
    return self;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reUseString = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reUseString];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUseString];
    }
    
    cell.textLabel.text = @"清理缓存";
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuPopView *menu = [[MenuPopView alloc] initWithTitles:@[@"清理缓存",@"我在想想"]];
    [menu setOnAction:^(NSInteger index) {
      
        [[WebCacheHelpler sharedWebCache] clearCache:^(NSString *cacheSize) {
            [UIWindow showTips:[NSString stringWithFormat:@"已经清理%@M缓存",cacheSize]];
        }];
    }];
    [menu show];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] init];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableView *)infoTab
{
    if (!_infoTab) {
        
        _infoTab = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)) {
            _infoTab.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;
        }
        _infoTab.dataSource = self;
        _infoTab.delegate = self;
        [self addSubview:_infoTab];
        _infoTab.backgroundColor = GTableBGColor;
        _infoTab.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 0.1)];
        _infoTab.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 0.1)];
        _infoTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _infoTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self addSubview:_infoTab];
    }
    return _infoTab;
}

@end
