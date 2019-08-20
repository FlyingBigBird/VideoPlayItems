//
//  PlayItemController.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/25.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "PlayItemController.h"
#import "VideoListCell.h"
#import "PlayItemModel.h"
NSString * const kVideoListCell  = @"VideoListCell";

@interface PlayItemController () <BasicNavigationBarViewDelegate, UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) BOOL                              isCurPlayerPause;
@property (nonatomic, assign) NSInteger                         pageIndex;
@property (nonatomic, assign) NSInteger                         pageSize;
@property (nonatomic, assign) AwemeType                         awemeType;
@property (nonatomic, copy) NSString                            *uid;
@property (nonatomic, strong) LoadMoreControl                   *loadMore;

@property (nonatomic, strong) NSMutableArray                    *streamData;

//@property (nonatomic, strong) NSMutableArray<Aweme *>           *data;
//@property (nonatomic, strong) NSMutableArray<Aweme *>           *awemes;

@end

@implementation PlayItemController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = GWhiteColor;
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_tableView.layer removeAllAnimations];
    NSArray<VideoListCell *> *cells = [_tableView visibleCells];
    for(VideoListCell *cell in cells) {
        
        [cell.playerView cancelLoading];
    }
    [[AVPlayerManager shareManager] removeAllPlayers];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"currentIndex"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBackgroundImage:@"img_video_loading"];

    [self showNavBar];
}

-(instancetype)initWithVideoData:(NSMutableArray *)data currentIndex:(NSInteger)currentIndex pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize awemeType:(AwemeType)type uid:(NSString *)uid {
    self = [super init];
    if(self) {
        
        _isCurPlayerPause = NO;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
        _awemeType = type;
        _uid = uid;
        
        if (currentIndex >= self.streamData.count) {
            
            _currentIndex = self.streamData.count - 1;
        } else {
            _currentIndex = currentIndex;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTouchBegin) name:@"StatusBarTouchBeginNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}


- (void)showNavBar
{
    [self showItemUI];

}
- (void)initNavUI
{
    BasicNavigationBarView * customNavBar = [[BasicNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavBar_H + StatusBar_H)];
    customNavBar.delegate = self;
    [customNavBar setNavigationBarWith:@"" andBGColor:GClearColor andTitleColor:GBlackColor andImage:@"football" andHidLine:YES];
    
    [self.view addSubview:customNavBar];
}
- (void)showItemUI
{
    self.view.layer.masksToBounds = YES;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * 3)];
    _tableView.contentInset = UIEdgeInsetsMake(SCREEN_HEIGHT, 0, SCREEN_HEIGHT * 1, 0);
    _tableView.scrollsToTop = NO;
    _tableView.backgroundColor = GClearColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.tableView registerClass:VideoListCell.class forCellReuseIdentifier:kVideoListCell];
    
    _loadMore = [[LoadMoreControl alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 50) surplusCount:3];
    __weak __typeof(self) wself = self;
    [_loadMore setOnLoad:^{
        [wself loadData:wself.pageIndex pageSize:wself.pageSize];
    }];
    [_tableView addSubview:_loadMore];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view addSubview:self.tableView];
        [self.tableView reloadData];
        
        [self initNavUI];
        
        NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        [self.tableView scrollToRowAtIndexPath:curIndexPath atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:NO];
        [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    });

}
- (void)customNavgationBarDidClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) setBackgroundImage:(NSString *)imageName {
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    background.clipsToBounds = YES;
    background.contentMode = UIViewContentModeScaleAspectFill;
    background.image = [UIImage imageNamed:imageName];
    [self.view addSubview:background];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.streamData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //填充视频数据
    VideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:kVideoListCell forIndexPath:indexPath];
    [cell initData:self.streamData[indexPath.row]];
    [cell startDownloadBackgroundTask];
    return cell;
}

#pragma ScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        //UITableView禁止响应其他滑动手势
        scrollView.panGestureRecognizer.enabled = NO;
        
        if(translatedPoint.y < -50 && self.currentIndex < (self.streamData.count - 1)) {
            self.currentIndex ++;   //向下滑动索引递增
        }
        if(translatedPoint.y > 50 && self.currentIndex > 0) {
            self.currentIndex --;   //向上滑动索引递减
        }
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                //UITableView滑动到指定cell
                                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                            } completion:^(BOOL finished) {
                                //UITableView可以响应其他滑动手势
                                scrollView.panGestureRecognizer.enabled = YES;
                            }];
    });
}

#pragma KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //观察currentIndex变化
    if ([keyPath isEqualToString:@"currentIndex"]) {
        //设置用于标记当前视频是否播放的BOOL值为NO
        _isCurPlayerPause = NO;
        //获取当前显示的cell
        VideoListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        [cell startDownloadHighPriorityTask];
        __weak typeof (cell) wcell = cell;
        __weak typeof (self) wself = self;
        //判断当前cell的视频源是否已经准备播放
        if(cell.isPlayerReady) {
            //播放视频
            [cell replay];
        }else {
            [[AVPlayerManager shareManager] pauseAll];
            //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等待视频准备好后通知播放
            cell.onPlayerReady = ^{
                NSIndexPath *indexPath = [wself.tableView indexPathForCell:wcell];
                if(!wself.isCurPlayerPause && indexPath && indexPath.row == wself.currentIndex) {
                    [wcell play];
                }
            };
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)statusBarTouchBegin {
    _currentIndex = 0;
}

- (void)applicationBecomeActive {
    VideoListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    if(!_isCurPlayerPause) {
        [cell.playerView play];
    }
}

- (void)applicationEnterBackground {
    VideoListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    _isCurPlayerPause = ![cell.playerView rate];
    [cell.playerView pause];
}

#pragma load data
- (void)loadData:(NSInteger)pageIndex pageSize:(NSInteger)pageSize {
  
    
}

- (NSMutableArray *)streamData
{
    if (!_streamData) {
        
        _streamData = [NSMutableArray array];
        PlayItemModel *model = [[PlayItemModel alloc] init];
        _streamData = [[model addVideoData] copy];
    }
    return _streamData;
}

- (void)dealloc {
    NSLog(@"======== dealloc =======");
}

@end
