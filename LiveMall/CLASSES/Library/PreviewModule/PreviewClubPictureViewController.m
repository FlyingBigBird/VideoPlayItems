//
//  PreviewClubPictureViewController.m
//  The_Month_Club
//
//  Created by BaoBaoDaRen on 16/10/4.
//  Copyright © 2016年 康振超. All rights reserved.
//

#import "PreviewClubPictureViewController.h"
#import "zoomCellView.h"

@interface PreviewClubPictureViewController ()<UIAlertViewDelegate, UIActionSheetDelegate, BasicNavigationBarViewDelegate>

@property (nonatomic, strong) UIButton * sharePicBtn;
@property (nonatomic, strong) UIButton * collectPicBtn;
@property (nonatomic, strong) UIButton * deletePicBtn;
@property (nonatomic, strong) zoomCellView * zooView;
@property (nonatomic, strong) UIAlertView * deletePicAlert;

@end

@implementation PreviewClubPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    self.title = NSLocalizedString(@"预览", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    showNavBar = NO;
    
    // zoomCellView上添加的一个旋转了-90度的tableView，需要添加按钮或者控制直接在zoomCellView上添加...
    self.zooView = [[zoomCellView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) imageSize:CGSizeZero];
    [self.view addSubview:self.zooView];

    [self.zooView updateImageDate:self.imageArray selectIndex:self.beginIndex];

    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
    
    BasicNavigationBarView * customNavBar = [[BasicNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavBar_H + StatusBar_H)];
    customNavBar.delegate = self;
    [customNavBar setNavigationBarWith:@"预览" andBGColor:[UIColor whiteColor] andTitleColor:GBlackColor andImage:@"nav_left_back" andHidLine:YES];
    
    [self.view addSubview:customNavBar];

}

#pragma mark - BasicNavigationBarViewDelegate
- (void)customNavgationBarDidClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 将图片保存到相册
- (void)saveSickDocImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if (error != NULL) {
        msg = NSLocalizedString(@"保存图片失败", nil);
    } else {
        msg = NSLocalizedString(@"保存图片成功", nil);
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
    [alert show];
}

- (void)doubleTapped
{
    
}

- (void)preViewViewDidTapped
{
    if (!showNavBar)
    {
        showNavBar = YES;
        self.navigationController.navigationBar.hidden = NO;
        
        if (!_hidEditView)
        {
            self.previewEditView.hidden = NO;
        } else
        {
            self.previewEditView.hidden = YES;
        }
    } else
    {
        showNavBar = NO;
        self.navigationController.navigationBar.hidden = YES;
        if (!_hidEditView)
        {
            self.previewEditView.hidden = YES;
        } else
        {
            self.previewEditView.hidden = YES;
        }
    }
}

- (void)leftButtonDidClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
