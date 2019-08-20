//
//  CustomFlowLayout.m
//  TextDemo
//
//  Created by BaoBaoDaRen on 2019/6/17.
//  Copyright © 2019 BaoBao. All rights reserved.
//

#import "CustomFlowLayout.h"

@implementation CustomFlowLayout

//数组的相关设置在这个方法中
//布局前的准备会调用这个方法
-(void)prepareLayout{
    
    [super prepareLayout];
    int horizonNum = 2;
    if (_attributeAttay.count > 0) {
        
        [_attributeAttay removeAllObjects];
    }
    _attributeAttay = [[NSMutableArray alloc]init];
    [super prepareLayout];
    //演示方便 我们设置为静态的2列
    //计算每一个item的宽度
    float WIDTH = ([UIScreen mainScreen].bounds.size.width-self.sectionInset.left-self.sectionInset.right-self.minimumInteritemSpacing)/horizonNum;
    //定义数组保存每一列的高度
    CGFloat colheight[2]={self.sectionInset.top, self.sectionInset.bottom};
    //itemCount是外界传进来的item的个数 遍历来设置每一个item的布局
    self.itemCount = self.itemHeightArr.count;
    for (int i=0; i < self.itemCount; i++) {
        //设置每个item的位置等相关属性
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        //创建一个布局属性类，通过indexPath来创建
        UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
//        //随机一个高度 在40——190之间
//        CGFloat height = arc4random()%150+40;

        CGFloat height = 0;
        NSString *getH = FORMAT(@"%@",self.itemHeightArr[i]);
//        height = [getH floatValue];
        height = [self.delegate heightForItemAtIndex:i];

        //哪一列高度小 则放到那一列下面
        //标记最短的列
        int width = 0;

        if (i % 2 == 0) {
            //将新的item高度加入到短的一列
            colheight[0] = colheight[0]+height+self.minimumLineSpacing;
            width=0;

        }else{
            colheight[1] = colheight[1]+height+self.minimumLineSpacing;
            width=1;

        }
        
        //设置item的位置
        attris.frame = CGRectMake(self.sectionInset.left+(self.minimumInteritemSpacing+WIDTH)*width, colheight[width]-height-self.minimumLineSpacing, WIDTH, height);
        [_attributeAttay addObject:attris];
    }
    
    if (colheight[0] > colheight[1]) {
        
        self.itemSize = CGSizeMake(WIDTH, (colheight[0]-self.sectionInset.top)*2/_itemCount-self.minimumLineSpacing);
    } else {
        self.itemSize = CGSizeMake(WIDTH, (colheight[1]-self.sectionInset.top)*2/_itemCount-self.minimumLineSpacing);
    }

//    NSLog(@"COH【0】:%f   ======   COH【1】:%f",colheight[0],colheight[1]);

}
//这个方法中返回我们的布局数组
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
 
    return _attributeAttay;
}


@end
