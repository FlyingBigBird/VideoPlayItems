//
//  MyInfoCenterController.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/20.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "MyInfoCenterController.h"
#import "MyInfoView.h"

@interface MyInfoCenterController () <BasicNavigationBarViewDelegate>

@property (nonatomic, strong) MyInfoView *infoV;

@end

@implementation MyInfoCenterController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self showComponet];

    [self showNav];
}
- (void)showComponet
{
    self.infoV = [[MyInfoView alloc] initWithFrame:CGRectMake(0, NavBar_H + StatusBar_H, SCREEN_WIDTH, SCREEN_HEIGHT - NavBar_H - StatusBar_H - TabBar_H)];
    [self.view addSubview:self.infoV];
}
- (void)showNav
{
    if (@available(iOS 11.0, *)) {
        self.infoV.infoTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    BasicNavigationBarView * customNavBar = [[BasicNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavBar_H + StatusBar_H)];
    customNavBar.delegate = self;
    [customNavBar setNavigationBarWith:@"我的" andBGColor:GClearColor andTitleColor:GBlackColor andImage:@"football" andHidLine:NO];
    
    [self.view addSubview:customNavBar];
}
- (void)customNavgationBarDidClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
