//
//  PreviewList.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/7/15.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "PreviewList.h"

@interface PreviewList () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UIPanGestureRecognizer *panGes;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

static NSString * headerRes = @"preHeaderStr";
static NSString * footerRes = @"preFooterStr";
static NSString * cellRes = @"preCellStr";


@implementation PreviewList

- (instancetype)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.currentIndex = 0;
        self.backgroundColor = GClearColor;
        [self uiShow];
    }
    return self;
}

- (NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}
- (void)uiShow
{
    self.colView.backgroundColor = GBlackColor;
}

// TODO: 数据源...
- (void)setSourceData:(NSArray *)sourceData
{
    if (sourceData && self.currentIndex < sourceData.count) {
        
        self.dataArr = sourceData;
    }
    [self.colView reloadData];
}
- (void)refreshImages:(NSArray * _Nullable)images atIndex:(NSInteger)index
{
    self.dataArr = images;
    [self.colView reloadData];

    if (images && index < images.count) {
        
        self.currentIndex = index;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.currentIndex];
        [self.colView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}

- (UICollectionView *)colView
{
    if (!_colView) {
        
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.layout.minimumLineSpacing = 0;
        self.layout.minimumInteritemSpacing = 0;
        self.layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        self.layout.footerReferenceSize = CGSizeMake(0, 0);
        self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _colView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:self.layout];
        _colView.dataSource = self;
        _colView.delegate = self;
        [self addSubview:_colView];
        
        [_colView registerClass:[PreviewItem class] forCellWithReuseIdentifier:cellRes];
        _colView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _colView.scrollEnabled = YES;
        _colView.bounces = YES;
//        _colView.pagingEnabled = YES;// 千万千万别加这个，坑死我了，或者=NO也可以....
        _colView.pagingEnabled = NO;
        _colView.showsHorizontalScrollIndicator = NO;
        
    }
    return _colView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArr.count > 0 ? self.dataArr.count : 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PreviewItem *preItem = [collectionView dequeueReusableCellWithReuseIdentifier:cellRes forIndexPath:indexPath];
    
    if (self.dataArr.count && indexPath.section < self.dataArr.count) {
        
        [preItem localImage:self.dataArr[indexPath.section]];
    }
    
    return preItem;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isKindOfClass:[UICollectionElementKindSectionHeader class]]) {
        
        [collectionView registerClass:[colHeader class] forSupplementaryViewOfKind:kind withReuseIdentifier:headerRes];
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerRes forIndexPath:indexPath];

        view.backgroundColor = GBlackColor;
        return view;

    } else {
        
        [collectionView registerClass:[colFooter class] forSupplementaryViewOfKind:kind withReuseIdentifier:footerRes];

        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerRes forIndexPath:indexPath];
        
        view.backgroundColor = GBlackColor;
        return view;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return CGSizeMake(0, 0);
    } else {
        return CGSizeMake(20, self.frame.size.height);
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

// TODO: UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![scrollView isEqual:self.colView]) {
            
            // 不响应...
        } else {
            
            self.colView.panGestureRecognizer.enabled = NO;
            CGFloat translateX = [self.colView.panGestureRecognizer translationInView:self.colView].x;
            if (translateX > 65 && self.currentIndex > 0) {
                
                self.currentIndex --;
            } else if (translateX < - 65 && self.currentIndex < (self.dataArr.count - 1))
            {
                self.currentIndex ++;
            } else {
                
            }
            NSLog(@"currentIndex:%ld   =====    translateX:%f",(long)self.currentIndex, translateX);
            
            [UIView transitionWithView:self.colView duration:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.currentIndex];
                [self.colView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                                
            } completion:^(BOOL finished) {
                self.colView.panGestureRecognizer.enabled = YES;
            }];
        }
    });
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layout.minimumLineSpacing = 0;
    self.layout.minimumInteritemSpacing = 0;
    self.layout.footerReferenceSize = CGSizeMake(0, 0);
    self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //    CGFloat WIDTH = ([UIScreen mainScreen].bounds.size.width-self.layout.sectionInset.left-self.layout.sectionInset.right-self.layout.minimumInteritemSpacing)/1;
    //    CGFloat HEIGHT = ([UIScreen mainScreen].bounds.size.height-self.layout.sectionInset.top-self.layout.sectionInset.bottom-self.layout.minimumLineSpacing)/1;
    
    
    self.layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    //    [self.colView.collectionViewLayout layoutAttributesForElementsInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.colView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    self.colView.collectionViewLayout = self.layout;
    [self.layout prepareLayout];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.currentIndex];
    [self.colView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
}

@end




// TODO: header : footer
@implementation colHeader

@end

@implementation colFooter

@end

