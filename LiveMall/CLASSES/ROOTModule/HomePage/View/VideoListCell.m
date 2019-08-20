//
//  VideoListCell.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/25.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "VideoListCell.h"
#import "CommentsPopView.h"
#import "SharePopView.h"

static const NSInteger kAwemeListLikeCommentTag = 0x01;
static const NSInteger kAwemeListLikeShareTag   = 0x02;

@interface VideoListCell () <SendTextDelegate, HoverTextViewDelegate, AVPlayerUpdateDelegate,SharePopViewDelegate>

@property (nonatomic, strong) UIView                   *container;
@property (nonatomic ,strong) CAGradientLayer          *gradientLayer;
@property (nonatomic ,strong) UIImageView              *pauseIcon;
@property (nonatomic, strong) UIView                   *playerStatusBar;
@property (nonatomic ,strong) UIImageView              *musicIcon;
@property (nonatomic, strong) UITapGestureRecognizer   *singleTapGesture;
@property (nonatomic, assign) NSTimeInterval           lastTapTime;
@property (nonatomic, assign) CGPoint                  lastTapPoint;

@end

@implementation VideoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = RGBA(0.0, 0.0, 0.0, 0.01);
        _lastTapTime = 0;
        _lastTapPoint = CGPointZero;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    //init player view;
    _playerView = [AVPlayerView new];
    _playerView.delegate = self;
    [self.contentView addSubview:_playerView];
    
    //init hover on player view container
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [_container addGestureRecognizer:_singleTapGesture];
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.colors = @[(__bridge id)GClearColor.CGColor, (__bridge id)RGBA(0.0, 0.0, 0.0, 0.2).CGColor, (__bridge id)RGBA(0.0, 0.0, 0.0, 0.4).CGColor];
    _gradientLayer.locations = @[@0.3, @0.6, @1.0];
    _gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    _gradientLayer.endPoint = CGPointMake(0.0f, 1.0f);
    [_container.layer addSublayer:_gradientLayer];
    
    _pauseIcon = [[UIImageView alloc] init];
    _pauseIcon.image = [UIImage imageNamed:@"pause"];
    _pauseIcon.contentMode = UIViewContentModeCenter;
    _pauseIcon.layer.zPosition = 3;
    _pauseIcon.hidden = YES;
    [_container addSubview:_pauseIcon];
    
    //init hoverTextView
    _hoverTextView = [HoverTextView new];
    _hoverTextView.delegate = self;
    _hoverTextView.hoverDelegate = self;
    [self addSubview:_hoverTextView];
    
    //init player status bar
    _playerStatusBar = [[UIView alloc]init];
    _playerStatusBar.backgroundColor = GWhiteColor;
    [_playerStatusBar setHidden:YES];
    [_container addSubview:_playerStatusBar];
    
    //init aweme message
    _musicIcon = [[UIImageView alloc]init];
    _musicIcon.contentMode = UIViewContentModeCenter;
    _musicIcon.image = [UIImage imageNamed:@"douyin"];
    [_container addSubview:_musicIcon];
    
    _musicName = [[CircleTextView alloc]init];
    _musicName.textColor = GWhiteColor;
    _musicName.font = Font(14);
    [_container addSubview:_musicName];
    
    
    _desc = [[UILabel alloc]init];
    _desc.numberOfLines = 0;
    _desc.textColor = RGBA(255.0, 255.0, 255.0, 0.8);
    _desc.font = Font(14);
    [_container addSubview:_desc];
    
    
    _nickName = [[UILabel alloc]init];
    _nickName.textColor = GWhiteColor;
    _nickName.font = Font(16);
    [_container addSubview:_nickName];
    
    
    //init music alum view
    _musicAlum = [MusicAlbumView new];
    [_container addSubview:_musicAlum];
    
    //init share、comment、like action view
    _share = [[UIImageView alloc]init];
    _share.contentMode = UIViewContentModeCenter;
    _share.image = [UIImage imageNamed:@"share"];
    _share.userInteractionEnabled = YES;
    _share.tag = kAwemeListLikeShareTag;
    [_share addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [_container addSubview:_share];
    
    _shareNum = [[UILabel alloc]init];
    _shareNum.text = @"0";
    _shareNum.textColor = GWhiteColor;
    _shareNum.font = Font(12);
    [_container addSubview:_shareNum];
    
    _comment = [[UIImageView alloc]init];
    _comment.contentMode = UIViewContentModeCenter;
    _comment.image = [UIImage imageNamed:@"comment"];
    _comment.userInteractionEnabled = YES;
    _comment.tag = kAwemeListLikeCommentTag;
    [_comment addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [_container addSubview:_comment];
    
    _commentNum = [[UILabel alloc]init];
    _commentNum.text = @"0";
    _commentNum.textColor = GWhiteColor;
    _commentNum.font = Font(12);
    [_container addSubview:_commentNum];
    
    _favorite = [FavoriteView new];
    [_container addSubview:_favorite];
    
    _favoriteNum = [[UILabel alloc]init];
    _favoriteNum.text = @"0";
    _favoriteNum.textColor = GWhiteColor;
    _favoriteNum.font = Font(12);
    [_container addSubview:_favoriteNum];
    
    //init avatar
    CGFloat avatarRadius = 25;
    _avatar = [[UIImageView alloc] init];
    _avatar.image = [UIImage imageNamed:@"douyin"];
    _avatar.layer.cornerRadius = avatarRadius;
    _avatar.layer.borderColor = RGBA(255.0, 255.0, 255.0, 0.8).CGColor;
    _avatar.layer.borderWidth = 1;
    [_container addSubview:_avatar];
    
    //init focus action
    _focus = [FocusView new];
    [_container addSubview:_focus];
    
    [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_pauseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(100);
    }];
    
    //make constraintes
    [_playerStatusBar mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-49.5f - SafeAreaBottomHeight);
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_musicIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self).offset(-60 - SafeAreaBottomHeight);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(25);
    }];
    
    [_musicName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.musicIcon.mas_right);
        make.centerY.equalTo(self.musicIcon);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(24);
    }];
    [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self.musicIcon.mas_top);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH/5*3);
    }];
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self.desc.mas_top).offset(-5);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH/4*3 + 30);
    }];
    
    [_musicAlum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.musicName);
        make.right.equalTo(self).offset(-10);
        make.width.height.mas_equalTo(50);
    }];
    [_share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.musicAlum.mas_top).offset(-50);
        make.right.equalTo(self).offset(-10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    [_shareNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.share.mas_bottom);
        make.centerX.equalTo(self.share);
    }];
    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.share.mas_top).offset(-25);
        make.right.equalTo(self).offset(-10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    [_commentNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.comment.mas_bottom);
        make.centerX.equalTo(self.comment);
    }];
    [_favorite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.comment.mas_top).offset(-25);
        make.right.equalTo(self).offset(-10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    
    [_favoriteNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favorite.mas_bottom);
        make.centerX.equalTo(self.favorite);
    }];
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.favorite.mas_top).offset(-35);
        make.right.equalTo(self).offset(-10);
        make.width.height.mas_equalTo(avatarRadius*2);
    }];
    [_focus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatar);
        make.centerY.equalTo(self.avatar.mas_bottom);
        make.width.height.mas_equalTo(24);
    }];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    
    _isPlayerReady = NO;
    [_playerView cancelLoading];
    [_pauseIcon setHidden:YES];
    
    [_hoverTextView.textView setText:@""];
    [_avatar setImage:[UIImage imageNamed:@"douyin"]];
    
    [_musicAlum resetView];
    [_favorite resetView];
    [_focus resetView];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _gradientLayer.frame = CGRectMake(0, self.frame.size.height - 500, self.frame.size.width, 500);
    [CATransaction commit];
}

//SendTextDelegate delegate
- (void)onSendText:(NSString *)text {
    

}

//HoverTextViewDelegate delegate
-(void)hoverTextViewStateChange:(BOOL)isHover {
    _container.alpha = isHover ? 0.0f : 1.0f;
}

//gesture
- (void)handleGesture:(UITapGestureRecognizer *)sender {
    switch (sender.view.tag) {
        case kAwemeListLikeCommentTag: {

            break;
        }
        case kAwemeListLikeShareTag: {
            SharePopView *popView = [[SharePopView alloc] init];
            popView.delegate = self;
            [popView show];
            break;
        }
        default: {
            //获取点击坐标，用于设置爱心显示位置
            CGPoint point = [sender locationInView:_container];
            //获取当前时间
            NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
            //判断当前点击时间与上次点击时间的时间间隔
            if(time - _lastTapTime > 0.25f) {
                //推迟0.25秒执行单击方法
                [self performSelector:@selector(singleTapAction) withObject:nil afterDelay:0.25f];
            }else {
                //取消执行单击方法
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction) object: nil];
                //执行连击显示爱心的方法
                [self showLikeViewAnim:point oldPoint:_lastTapPoint];
            }
            //更新上一次点击位置
            _lastTapPoint = point;
            //更新上一次点击时间
            _lastTapTime =  time;
            break;
        }
    }
    
}

- (void)singleTapAction {
    if([_hoverTextView isFirstResponder]) {
        [_hoverTextView resignFirstResponder];
    }else {
        [self showPauseViewAnim:[_playerView rate]];
        [_playerView updatePlayerState];
    }
}

//暂停播放动画
- (void)showPauseViewAnim:(CGFloat)rate {
   
    if(rate == 0) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             self.pauseIcon.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             [self.pauseIcon setHidden:YES];
                         }];
    }else {
        [_pauseIcon setHidden:NO];
        _pauseIcon.transform = CGAffineTransformMakeScale(1.8f, 1.8f);
        _pauseIcon.alpha = 1.0f;
        [UIView animateWithDuration:0.25f delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.pauseIcon.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                            } completion:^(BOOL finished) {
                            }];
    }
}

//连击爱心动画
- (void)showLikeViewAnim:(CGPoint)newPoint oldPoint:(CGPoint)oldPoint {
    UIImageView *likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favAfter"]];
    CGFloat k = ((oldPoint.y - newPoint.y)/(oldPoint.x - newPoint.x));
    k = fabs(k) < 0.5 ? k : (k > 0 ? 0.5f : -0.5f);
    CGFloat angle = M_PI_4 * -k;
    likeImageView.frame = CGRectMake(newPoint.x, newPoint.y, 80, 80);
    likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 0.8f, 1.8f);
    [_container addSubview:likeImageView];
    [UIView animateWithDuration:0.2f
                          delay:0.0f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 1.0f, 1.0f);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5f
                                               delay:0.5f
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 3.0f, 3.0f);
                                              likeImageView.alpha = 0.0f;
                                          }
                                          completion:^(BOOL finished) {
                                              [likeImageView removeFromSuperview];
                                          }];
                     }];
}

//加载动画
-(void)startLoadingPlayItemAnim:(BOOL)isStart {
    if (isStart) {
        _playerStatusBar.backgroundColor = GWhiteColor;
        [_playerStatusBar setHidden:NO];
        [_playerStatusBar.layer removeAllAnimations];
        
        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.duration = 0.5;
        animationGroup.beginTime = CACurrentMediaTime() + 0.5;
        animationGroup.repeatCount = MAXFLOAT;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animation];
        scaleAnimation.keyPath = @"transform.scale.x";
        scaleAnimation.fromValue = @(1.0f);
        scaleAnimation.toValue = @(1.0f * SCREEN_WIDTH);
        
        CABasicAnimation * alphaAnimation = [CABasicAnimation animation];
        alphaAnimation.keyPath = @"opacity";
        alphaAnimation.fromValue = @(1.0f);
        alphaAnimation.toValue = @(0.5f);
        [animationGroup setAnimations:@[scaleAnimation, alphaAnimation]];
        [self.playerStatusBar.layer addAnimation:animationGroup forKey:nil];
    } else {
        [self.playerStatusBar.layer removeAllAnimations];
        [self.playerStatusBar setHidden:YES];
    }
    
}

// AVPlayerUpdateDelegate
-(void)onProgressUpdate:(CGFloat)current total:(CGFloat)total {
    //播放进度更新
    
    if (current == total) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.playerView replay];
        });
    }
    
    NSLog(@"已播放百分之:【 %.0f%@ 】  总时长：【%02d:%02d:%02d】",current / total * 100,@"%", (int)total/60/60,(int)total/60,(int)total%60);
}

-(void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status {
    switch (status) {
        case AVPlayerItemStatusUnknown:
            [self startLoadingPlayItemAnim:YES];
            break;
        case AVPlayerItemStatusReadyToPlay:
            [self startLoadingPlayItemAnim:NO];
            
            _isPlayerReady = YES;
            [_musicAlum startAnimation:0];
            
            if(_onPlayerReady) {
                _onPlayerReady();
            }
            break;
        case AVPlayerItemStatusFailed:
            [self startLoadingPlayItemAnim:NO];
            [UIWindow showTips:@"加载失败"];
            break;
        default:
            break;
    }
}

// update method
- (void)initData:(NSString *)dataStr {
   
    self.urlString = dataStr;
    _nickName.text = @"@包包";
    [_desc setText:@"啊哈哈"];
    [_musicName setText:@"天下无双"];
    
    [_favoriteNum setText:[NSString formatCount:100]];
    [_commentNum setText:[NSString formatCount:36]];
    [_shareNum setText:[NSString formatCount:25]];
    
    UIImage *image = [UIImage imageNamed:@"douyin"];
    _musicAlum.album.image = [UIImage imageNamed:@"picBg"];;
    self.avatar.image = [image drawCircleImage];
}

- (void)play {
    [_playerView play];
    [_pauseIcon setHidden:YES];
}

- (void)pause {
    [_playerView pause];
    [_pauseIcon setHidden:NO];
}

- (void)replay {
    [_playerView replay];
    [_pauseIcon setHidden:YES];
}

- (void)startDownloadBackgroundTask {
    NSString *playUrl = self.urlString;
    [_playerView setPlayerWithUrl:playUrl];
}

- (void)startDownloadHighPriorityTask {
    NSString *playUrl = self.urlString;
    [_playerView startDownloadTask:[[NSURL alloc] initWithString:playUrl] isBackground:NO];
}

#pragma mark - SharePopViewDelegate
- (void)actionClickedAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            // 举报
            
            break;
        }case 1:
        {
            // 保存至相册...
            [self saveVideo];

            break;
        }case 2:
        {
            // 复制链接...
            [UIAlertView showCustomEnsureAlert:@"复制成功"];
            UIPasteboard *paste = [UIPasteboard generalPasteboard];
            paste.string = self.urlString;
            break;
        }case 3:
        {
            // 不感兴趣
            
            break;
        }
        default:
            break;
    }
}

- (void)saveVideo
{
    [self.playerView saveVideoWithUrl:self.urlString];
}

@end
