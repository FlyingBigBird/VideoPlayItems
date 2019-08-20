//
//  VideoListCell.h
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/25.
//  Copyright © 2019 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HoverTextView.h"
#import "CircleTextView.h"
#import "FocusView.h"
#import "FavoriteView.h"
#import "MusicAlbumView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnPlayerReady)(void);

@interface VideoListCell : UITableViewCell

//@property (nonatomic, strong) Aweme            *aweme;

@property (nonatomic, strong) AVPlayerView     *playerView;
@property (nonatomic, strong) HoverTextView    *hoverTextView;

@property (nonatomic, strong) CircleTextView   *musicName;
@property (nonatomic, strong) UILabel          *desc;
@property (nonatomic, strong) UILabel          *nickName;

@property (nonatomic, strong) UIImageView      *avatar;
@property (nonatomic, strong) FocusView        *focus;
@property (nonatomic, strong) MusicAlbumView   *musicAlum;

@property (nonatomic, strong) UIImageView      *share;
@property (nonatomic, strong) UIImageView      *comment;

@property (nonatomic, strong) FavoriteView     *favorite;

@property (nonatomic, strong) UILabel          *shareNum;
@property (nonatomic, strong) UILabel          *commentNum;
@property (nonatomic, strong) UILabel          *favoriteNum;
@property (nonatomic, strong) OnPlayerReady    onPlayerReady;
@property (nonatomic, assign) BOOL             isPlayerReady;

@property (nonatomic, strong) NSString *urlString;

- (void)initData:(NSString *)dataStr;
- (void)play;
- (void)pause;
- (void)replay;
- (void)startDownloadBackgroundTask;
- (void)startDownloadHighPriorityTask;

@end

NS_ASSUME_NONNULL_END
