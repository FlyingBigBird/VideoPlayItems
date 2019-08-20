//
//  PreviewController.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/7/15.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "PreviewController.h"
#import "PreviewList.h"
#import "AppDelegate.h"

@interface PreviewController () <BasicNavigationBarViewDelegate,PreviewPageDelegate>

@property (nonatomic, strong) PreviewList *imgList;
@property (nonatomic, strong) BasicNavigationBarView * customNavBar;

@end

@implementation PreviewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    AppDelegate *delegate = APP_Delegate;
    delegate.orientation = ClientOrientationMaskAll;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *delegate = APP_Delegate;
    delegate.orientation = ClientOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
     // 添加监听函数
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    self.orienSize = self.view.bounds.size;
    self.imgList = [[PreviewList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    NSArray *imgArr = @[[UIImage imageNamed:@"longimgpic"],[UIImage imageNamed:@"picBg"],[UIImage imageNamed:@"headImg"],[UIImage imageNamed:@"goodPic"],[UIImage imageNamed:@"longimgpic"]];
    [self.imgList refreshImages:imgArr atIndex:0];
    [self.view addSubview:self.imgList];
    
    if (@available(iOS 11.0, *)) {
        self.imgList.colView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    
    self.customNavBar = [[BasicNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavBar_H + StatusBar_H)];
    self.customNavBar.delegate = self;
    [self.customNavBar setNavigationBarWith:@"预览" andBGColor:GBlackColor andTitleColor:GWhiteColor andImage:@"back-2" andHidLine:YES];
    [self.view addSubview:self.customNavBar];
    
    
}

- (void)deviceOrientationDidChange:(NSNotification *)notify
{
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    NSLog(@"orientation:%ld",(long)interfaceOrientation);
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        self.customNavBar.frame = CGRectMake(0, 0, self.orienSize.height, NavBar_H + StatusBar_H);
        self.imgList.frame = CGRectMake(0, 0, self.orienSize.height, self.orienSize.width);
    } else if (interfaceOrientation == UIInterfaceOrientationPortrait){
        
        self.customNavBar.frame = CGRectMake(0, 0, self.orienSize.width, NavBar_H + StatusBar_H);
        self.imgList.frame = CGRectMake(0, 0, self.orienSize.width, self.orienSize.height);
    } else {
        return;
    }
}

- (void)customNavgationBarDidClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)signalTappedBegin
{
    if ([self respondsToSelector:@selector(signalTappedBegin)]) {
        
        [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            self.customNavBar.hidden = !self.customNavBar.hidden;
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (void)shouldDismissView:(UIView *)view
{
    [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        view.transform = CGAffineTransformMakeScale(200 / SCREEN_WIDTH, 200 / SCREEN_HEIGHT);
        view.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT + 200);
    } completion:^(BOOL finished) {
        
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

@end 
