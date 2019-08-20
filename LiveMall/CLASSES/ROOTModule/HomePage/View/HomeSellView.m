//
//  HomeSellView.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/20.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "HomeSellView.h"
#import "ScrollHeader.h"
#import "CustomFlowLayout.h"
#import "HomeDataCell.h"
#import "HTopItemView.h"

#define headHeight 60.0f

static NSString *const cellIden = @"dataCellId";

@interface HomeSellView () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CustomFlowLayoutDelegate>

@property (nonatomic, strong) ScrollHeader *headV;
@property (nonatomic, assign) NSInteger itemNum;
@property (nonatomic, strong) CustomFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *getHeight;
@property (nonatomic, strong) HTopItemView *topItemV;

@end

@implementation HomeSellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.getHeight = [NSMutableArray array];
//        self.dataArr = [NSMutableArray array];
    }
    return self;
}

- (void)setItemCount:(NSInteger)itemCount
{
    if (itemCount <= 0) {
        
        return;
    } else {
        self.itemNum = itemCount;
        [self doScrolInit];
    }
}
- (void)doScrolInit
{
    self.headV.backgroundColor = [UIColor whiteColor];
    self.colView.backgroundColor = GTableBGColor;
    NSArray *titArr = @[@"纷来热卖",@"食饮",@"家具",@"美妆",@"服饰",@"数码",@"母婴",@"箱包",@"户外",];
    self.headV.itemArr = [titArr copy];
    WeakSelf(self);
    [self.headV setItemClick:^(NSInteger index) {
        
        [weakself loadDataType:index];
    }];
    self.moreItem.backgroundColor = [UIColor whiteColor];
    [self.moreItem addTarget:self action:@selector(showTopView:) forControlEvents:UIControlEventTouchUpInside];

    
    CGFloat shadowH = 15;
    UIView *shadeLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.moreItem.frame.size.height / 2 - shadowH / 2, 0.5, shadowH)];
    shadeLine.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self.moreItem addSubview:shadeLine];
    [UIView addShadowToView:shadeLine withColor:[UIColor lightGrayColor]];
    
    [self reloadDataSource:[NSArray array]];
}
// TODO: 顶部选项卡...
- (void)showTopView:(UIButton *)sender
{
    NSArray *data = @[@"纷来热卖",@"食饮",@"家居",@"美妆",@"服饰",@"数码",@"母婴",@"保健",@"箱包",@"户外"];
    self.topItemV = [[HTopItemView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) typeData:data compelete:^(NSInteger type) {
        
        // 选项卡类型...
        
    }];
    [[UIApplication sharedApplication].delegate.window addSubview:self.topItemV];
    
}
// TODO：加载数据...
- (void)loadDataType:(NSInteger)type
{
    
}


- (void)reloadDataSource:(NSArray *)dataArr
{
    NSMutableArray *dataHeight = [NSMutableArray array];
    for (int i = 0; i < self.itemNum; i++) {
        
        CGFloat sizeH = 230;
        if (i % 3 == 0) {
            
            sizeH = 300;
        }
        [dataHeight addObject:FORMAT(@"%f",sizeH)];
    }
    
    [self.getHeight addObjectsFromArray:dataHeight];

    self.layout.itemHeightArr = [NSMutableArray arrayWithArray:dataHeight];
    self.colView.collectionViewLayout = self.layout;

    [self.colView.collectionViewLayout prepareLayout];
    NSLog(@"COLLECTION_HEIGHT:%f",self.colView.contentSize.height);
    [self.colView reloadData];
    
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (ScrollHeader *)headV
{
    if (!_headV) {
        _headV = [[ScrollHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headHeight)];
        [self addSubview:_headV];
    }
    return _headV;
}

- (UICollectionView *)colView
{
    if (!_colView) {
        
        self.layout = [[CustomFlowLayout alloc] init];
        self.layout.delegate = self;
        self.layout.itemCount = self.itemNum;
        self.layout.minimumLineSpacing = 10;
        self.layout.minimumInteritemSpacing = 10;
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.layout.headerReferenceSize = CGSizeMake(0, 0);
        self.layout.footerReferenceSize = CGSizeMake(0, 0);
        self.layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        self.colView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, headHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavBar_H - StatusBar_H - TabBar_H - headHeight) collectionViewLayout:self.layout];
        self.colView.showsVerticalScrollIndicator = NO;
       
        [self.colView registerClass:[HomeDataCell class] forCellWithReuseIdentifier:cellIden];
        
        self.colView.dataSource = self;
        self.colView.delegate = self;

        [self addSubview:self.colView];
    }
    return _colView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.getHeight.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIden forIndexPath:indexPath];
   
    cell.itemIndexPath = indexPath;
    if (self.dataArr.count > 0) {
        
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isKindOfClass:[UICollectionElementKindSectionHeader class]]) {
        
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        view.frame = CGRectZero;
        return view;
    } else {
        
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        view.frame = CGRectZero;
        return view;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndex = indexPath.row;
    if (self.presentBack) {
        
        self.presentBack(indexPath.row);
    }
}
- (CGFloat)heightForItemAtIndex:(NSInteger)index
{
    if (self.getHeight.count > index) {
        CGFloat getH = [self.getHeight[index] floatValue];
        return getH;
    } else {
        return 200;
    }
}
- (UIButton *)moreItem
{
    if (!_moreItem) {
        
        CGFloat btnW = 60;
        CGFloat imgWH = 15;

        _moreItem = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - btnW, 0, btnW, headHeight)];
        [_moreItem setImage:[UIImage imageNamed:@"zhedie"] forState:UIControlStateNormal];
        [_moreItem setImageEdgeInsets:UIEdgeInsetsMake(headHeight / 2 - imgWH / 2, btnW - 15 - imgWH, headHeight / 2 - imgWH / 2, 15)];
        
        [self addSubview:_moreItem];
    }
    return _moreItem;
}

@end
