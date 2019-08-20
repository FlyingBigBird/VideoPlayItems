//
//  DropdownListView.m
//  FotileCSS
//
//  Created by Minimalism C on 2018/11/30.
//  Copyright © 2018 BaoBao. All rights reserved.
//

#import "DropdownListView.h"

@implementation DropdownListItem

- (instancetype)initWithItem:(NSString *)itemId itemName:(NSString *)itemName {
    
    self = [super init];
    if (self) {
        
        _itemId = itemId;
        _itemName = itemName;
    }
    return self;
}

- (instancetype)init {
    
    return [self initWithItem:@"" itemName:@""];
}

@end

@interface DropdownListView()<UITableViewDelegate, UITableViewDataSource>

// 数据源
@property (nonatomic, strong) NSArray *dataSource;

/**
 * 是否删除第一个数据源
 */
@property (nonatomic, assign) BOOL isRemove;

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *arrowImg;
@property (nonatomic, strong) UITableView *tbView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, copy) DropdownListViewSelectedBlock selectedBlock;

@end

static CGFloat const kArrowImgHeight = 10;
static CGFloat const kArrowImgWidth = 15;
static CGFloat const kTextLabelX = 5;
static CGFloat const kItemCellHeight = 40;

@implementation DropdownListView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupView];
        [self setupProperty];
    }
    return self;
}

- (instancetype)initWithDataSource:(NSArray *)dataSource {
    
    _dataSource = dataSource;
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self setupFrame];
}

#pragma mark - Setup
- (void)setupProperty {
    
    _textColor = [UIColor blackColor];
    _font = [UIFont systemFontOfSize:14];
    _selectedIndex = 0;
    _textLabel.font = _font;
    _textLabel.textColor = _textColor;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    
    UITapGestureRecognizer *tapLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewExpand:)];
    [_textLabel addGestureRecognizer:tapLabel];
    
    UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewExpand:)];
    [_arrowImg addGestureRecognizer:tapImg];
}

- (void)setupView {
    
    [self addSubview:self.textLabel];
    [self addSubview:self.arrowImg];
}

- (void)setupFrame {
    
    CGFloat viewWidth = CGRectGetWidth(self.bounds),
    viewHeight = CGRectGetHeight(self.bounds);
    
    _textLabel.frame = CGRectMake(kTextLabelX, 0, viewWidth - kTextLabelX - kArrowImgWidth , viewHeight);
    _arrowImg.frame = CGRectMake(CGRectGetWidth(_textLabel.frame), viewHeight / 2 - kArrowImgHeight / 2, kArrowImgWidth, kArrowImgHeight);
}

#pragma mark - Events
- (void)tapViewExpand:(UITapGestureRecognizer *)sender {
    
    [self rotateArrowImage];
    
    CGFloat tableHeight = _dataSource.count * kItemCellHeight + 20;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backgroundView];
    [window addSubview:self.tbView];
    
    // 获取按钮在屏幕中的位置
    CGRect frame = [self convertRect:self.bounds toView:window];
    CGFloat tableViewY = frame.origin.y + frame.size.height;
    
    if (tableHeight > 400) {
        
        //防止数据过多，origin.y在屏幕外
        tableHeight = 400;
    }
    
    CGRect tableViewFrame;
    tableViewFrame.size.width = frame.size.width;
    tableViewFrame.size.height = tableHeight;
    tableViewFrame.origin.x = frame.origin.x;
    
    if (tableViewY + tableHeight < CGRectGetHeight([UIScreen mainScreen].bounds)) {
        
        //默认向下弹出
        tableViewFrame.origin.y = tableViewY + 2.5;
    } else {
        
        if (frame.origin.y > tableHeight) {
            
            //按钮靠底部，向下弹出
            tableViewFrame.origin.y = frame.origin.y - tableHeight - 2.5;
        } else {
            
            //向下弹出
            tableViewFrame.origin.y = tableViewY + 2.5;
        }
    }
    self.tbView.frame = tableViewFrame;
    
    UITapGestureRecognizer *tagBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewDismiss:)];
    [self.backgroundView addGestureRecognizer:tagBackground];
}

- (void)tapViewDismiss:(UITapGestureRecognizer *)sender {
    
    [self removeBackgroundView];
}

#pragma mark - Methods
- (void)setDataSource:(NSArray *)dataSource andRemoveFirstData:(BOOL)isRemove {
    
    _dataSource = dataSource;
    self.isRemove = isRemove;
    
    if (dataSource.count > 0) {
        
        [self selectedItemAtIndex:_selectedIndex];
    }
}

- (void)setViewBorder:(CGFloat)width borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius {
    
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = width;
}

- (void)setDropdownListViewSelectedBlock:(DropdownListViewSelectedBlock)block {
    
    _selectedBlock = block;
}

- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle)style {
    
    self.tbView.separatorStyle = style;
}

- (void)rotateArrowImage {
    
    // 旋转箭头图片
    _arrowImg.transform = CGAffineTransformRotate(_arrowImg.transform, M_PI);
}

- (void)removeBackgroundView {
    
    [self.backgroundView removeFromSuperview];
    [self.tbView removeFromSuperview];
    [self rotateArrowImage];
}

- (void)selectedItemAtIndex:(NSInteger)index {
    
    _selectedIndex = index;
    
    if (index < _dataSource.count) {
        
        DropdownListItem *item = _dataSource[index];
        _selectedItem = item;
        _textLabel.text = item.itemName;
        
        if (self.isRemove) {
            
            //防止反复移除
            self.isRemove = NO;
            
            // 如果数据源中含有请选择等数据源，需要移除就移除
            NSMutableArray *dataArr = [NSMutableArray arrayWithArray:_dataSource];
            [dataArr removeObjectAtIndex:0];
            _dataSource = dataArr;
        }
    }
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = _font;
    cell.textLabel.textColor = _textColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    DropdownListItem *item = _dataSource[indexPath.row];
    cell.textLabel.text = item.itemName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self selectedItemAtIndex:indexPath.row];
    [self removeBackgroundView];
    
    if (_selectedBlock) {
        
        _selectedBlock(self);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

#pragma mark - Setter
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    
    [self selectedItemAtIndex:selectedIndex];
}

- (void)setFont:(UIFont *)font {
    
    _font = font;
    _textLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    
    _textColor = textColor;
    _textLabel.textColor = textColor;
}

#pragma mark - Getter
- (UILabel *)textLabel {
    
    if (!_textLabel) {
        
        _textLabel = [UILabel new];
        _textLabel.userInteractionEnabled = YES;
    }
    return _textLabel;
}

- (UIImageView *)arrowImg {
    
    if (!_arrowImg) {
        
        _arrowImg = [UIImageView new];
        _arrowImg.image = [UIImage imageNamed:@"dropdownFlag"];
        _arrowImg.userInteractionEnabled = YES;
    }
    return _arrowImg;
}

- (UITableView *)tbView {
    
    if (!_tbView) {
        
        self.tbView = [UITableView new];
        _tbView.dataSource = self;
        _tbView.delegate = self;
        
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 10)];
        tableHeaderView.backgroundColor = [UIColor clearColor];
        
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 10)];
        tableFooterView.backgroundColor = [UIColor clearColor];
        
        _tbView.tableHeaderView = tableHeaderView;
        _tbView.tableFooterView = tableFooterView;
        _tbView.layer.borderWidth = 5;
        _tbView.layer.borderColor = [GTableBGColor CGColor];
        _tbView.layer.cornerRadius = 2.5;
        _tbView.rowHeight = kItemCellHeight;
    }
    return _tbView;
}

- (UIView *)backgroundView {
    
    if (!_backgroundView) {
        
        self.backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.4;
    }
    return _backgroundView;
}

- (void)dealloc {
    
}

@end
