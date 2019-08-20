//
//  MoviePlayerViewController.m
//  ZCAVPlayer
//
//  Created by BaoBaoDaRen on 17/3/23.
//  Copyright © 2017年 康振超. All rights reserved.
//

#import "MoviePlayerViewController.h"
#import "ZCMediaPlayer.h"

@interface MoviePlayerViewController ()

@property (nonatomic, strong) ZCMediaPlayer *player;
@property (nonatomic, strong) UIButton * videoRightBtn;

@end

@implementation MoviePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMoviePlayerSubs];
    
}

- (void)setMoviePlayerSubs
{
    self.videoRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 20, 40, 40)];
    [self.videoRightBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [self.videoRightBtn addTarget:self action:@selector(shutCurrentViewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.videoRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.videoRightBtn];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _player = [[ZCMediaPlayer alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 300)];
    
    _player.videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.videoPath]];
    [self.view addSubview:_player];
    
    __weak typeof(self) weakSelf = self;
    [_player setBackBlock:^{
        
        [weakSelf shutCurrentViewAction];
    }];
}

- (void)shutCurrentViewAction
{
    [[NSUserDefaults standardUserDefaults] setObject:@"Portart" forKey:@"AppOrientation"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterForeground" object:nil];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor blackColor];
        self.videoRightBtn.hidden = NO;
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.view.backgroundColor = [UIColor blackColor];
        self.videoRightBtn.hidden = YES;
    }
}
// 哪些页面支持自动转屏
- (BOOL)shouldAutorotate{
    
    return YES;
}

// viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    // MoviePlayerViewController这个页面支持转屏方向
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(void)dealloc
{
    NSLog(@"%s",__func__);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
