//
//  zoomCellView.m
//  zoomScale_Sample
//
//  Created by BaoBaoDaRen on 16/9/29.
//  Copyright © 2016年 康振超. All rights reserved.
//

#import "zoomCellView.h"
#import "zoomCell.h"

@implementation zoomCellView
{
    CGSize v_size;
    UITableView *m_TableView;
    UILabel *progressLabel;
}

- (instancetype)initWithFrame:(CGRect)frame imageSize:(CGSize)size
{
    self = [super initWithFrame:frame];
    if (self) {
        
        v_size = size;
        [self _initView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)updateImageDate:(NSArray *)imageArr selectIndex:(NSInteger)index
{
    self.imgs = imageArr;
    [m_TableView reloadData];
    if (index > 0 && index < self.imgs.count) {
        NSInteger row = MAX(index, 0);
        [m_TableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    self.selectIndex = index;
    progressLabel.text = [NSString stringWithFormat:@"%ld/%lu",(index + 1),(unsigned long)self.imgs.count];
}

- (void)_initView
{
    m_TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width) style:UITableViewStylePlain];
    m_TableView.delegate = self;
    m_TableView.dataSource = self;
    m_TableView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    m_TableView.showsVerticalScrollIndicator = NO;
    m_TableView.transform = CGAffineTransformMakeRotation(- M_PI / 2);
    m_TableView.pagingEnabled = YES;
    m_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_TableView.backgroundView = nil;
    m_TableView.backgroundColor = [UIColor blackColor];
    m_TableView.scrollEnabled = YES;
    m_TableView.bounces = YES;
    [self addSubview:m_TableView];
    
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 20)];
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.font = [UIFont systemFontOfSize:15];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:progressLabel];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _imgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idty = @"imgshowCell";
    zoomCell * cell = [tableView dequeueReusableCellWithIdentifier:idty];
    if (cell == nil)
    {
        cell = [[zoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idty];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    
    cell.size = self.bounds.size;
//    NSString *imgStr = [self.imgs objectAtIndex:indexPath.row];
//    cell.imgName = imgStr;
    UIImage * image = [self.imgs objectAtIndex:indexPath.row];
    [cell setLocalImage:image];

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.width;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSIndexPath *index =  [m_TableView indexPathForRowAtPoint:scrollView.contentOffset];
    
    progressLabel.text = [NSString stringWithFormat:@"%ld/%lu", index.row + 1, (unsigned long)self.imgs.count];
    self.selectIndex = index.row;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"descriptionChanged" object:nil];
}

@end
