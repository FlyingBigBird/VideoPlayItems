//
//  TabBarView.m
//  CommentSample
//
//  Created by BaoBaoDaRen on 2017/8/15.
//  Copyright © 2017年 康振超. All rights reserved.
//

#import "TabBarView.h"

@interface TabBarView ()

@property (nonatomic, strong) UIView        * tabBgView;
@property (nonatomic, assign) BOOL          isImageLarge;

@property (nonatomic, strong) NSArray       * selectedImageArray;
@property (nonatomic, strong) NSArray       * UnselectedImageArray;

@property (nonatomic, strong) UIColor       * selectedColor;
@property (nonatomic, strong) UIColor       * UnselectedColor;

@property (nonatomic, assign) NSInteger     selectedIndex;// 当前选中图标...
@property (nonatomic, assign) NSUInteger    itemNum;

@end

@implementation TabBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.selectedImageArray = [NSArray array];
        self.UnselectedImageArray = [NSArray array];
        self.selectedColor = [UIColor whiteColor];
        self.UnselectedColor = [UIColor whiteColor];
        self.selectedIndex = 0;
        self.isImageLarge = NO;
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, - 0.25, self.frame.size.width, 0.5)];
        [self addSubview:lineView];
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.alpha = 0.5;
    }
    return self;
}

- (void)customTabBarItemNumber:(NSInteger)itemNum
               withCenterLarge:(BOOL)isCenterLarge
                withTitleArray:(NSArray *)titleArray
        withSelectedImageArray:(NSArray *)selectedImageArray
      withUnSelectedImageArray:(NSArray *)UnSelectedImageArray
               withCenterImage:(UIImage *)centerImage
           withBackGroundColor:(UIColor *)backColor
          withTitleSelectColor:(UIColor *)titleSelectColor
        withTitleUnSelectColor:(UIColor *)titleUnSelectColor
{
    self.isImageLarge = isCenterLarge;
    self.itemNum = itemNum;
    self.backgroundColor = backColor;
    self.selectedColor = titleSelectColor;
    self.UnselectedColor = titleUnSelectColor;
    self.selectedImageArray = selectedImageArray;
    self.UnselectedImageArray = UnSelectedImageArray;
    
    self.tabBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 49)];
    [self addSubview:self.tabBgView];
    
    
    CGFloat Equal_Width = self.frame.size.width / itemNum;
    CGFloat Equal_Height = 49;
    CGFloat Center_Width = Equal_Width;
    CGFloat Center_Height = Equal_Height;
    
    if (isCenterLarge == YES)
    {
        if (itemNum % 2 != 0)
        {
            Center_Width = Equal_Height + 15;
            Center_Height = Center_Width;
            Equal_Width = (self.frame.size.width - Center_Width) / (itemNum - 1);
            Equal_Height = self.frame.size.height;
        }
    }
    
    CGFloat Tit_ImgWH = 25;
    CGFloat TitLab_Font = 10;
    CGFloat top_Margin = 2;
    CGFloat bottom_Margin = 0;
    CGFloat titleLab_Height = 20;
    
    
    for (int i = 0; i < itemNum; i++)
    {
        if (isCenterLarge == YES)
        {
            if (itemNum % 2 != 0)
            {
                if (i == (itemNum / 2))
                {
                    UIButton * tabBarItem = [[UIButton alloc] initWithFrame:CGRectMake(Equal_Width * i, self.frame.size.height - Center_Height, Center_Width, Center_Height)];
                    tabBarItem.tag = i;
                    [self.tabBgView addSubview:tabBarItem];
                    UIImageView * btnImageView = [[UIImageView alloc] initWithFrame:tabBarItem.bounds];
                    [tabBarItem addSubview:btnImageView];
                    btnImageView.tag = i;
                    tabBarItem.backgroundColor = [UIColor whiteColor];
                    btnImageView.image = centerImage;
                    tabBarItem.alpha = 1.0;
                    tabBarItem.layer.masksToBounds = YES;
                    tabBarItem.layer.cornerRadius = Center_Height / 2;
                    
                    UIImageView * title_Image = [[UIImageView alloc] initWithFrame:CGRectMake(tabBarItem.frame.size.width / 2 - Tit_ImgWH / 2, (tabBarItem.frame.size.height - bottom_Margin - titleLab_Height) / 2 - Tit_ImgWH / 2 + top_Margin, Tit_ImgWH, Tit_ImgWH)];
                    title_Image.tag = i;
                    [tabBarItem addSubview:title_Image];
                    
                    UILabel * title_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, tabBarItem.frame.size.height - bottom_Margin - titleLab_Height, tabBarItem.frame.size.width, titleLab_Height)];
                    title_Label.tag = i;
                    [tabBarItem addSubview:title_Label];
                    title_Label.font = [UIFont systemFontOfSize:TitLab_Font];
                    title_Label.textAlignment = NSTextAlignmentCenter;
                    title_Label.text = @"";
                    
                    if (self.selectedIndex == i)
                    {
                        title_Image.image = [UIImage imageNamed:@""];
                        title_Label.textColor = titleSelectColor;
                    } else
                    {
                        title_Image.image = [UIImage imageNamed:@""];
                        title_Label.textColor = titleUnSelectColor;
                    }
                    
                    [tabBarItem addTarget:self action:@selector(TabBarItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];

                } else
                {
                    CGFloat Btn_Margin = 0;
                    if (i <= (itemNum / 2))
                    {
                        Btn_Margin = Equal_Width * i;
                    } else
                    {
                        Btn_Margin = Equal_Width * (i - 1) + Center_Width;
                    }
                    UIButton * tabBarItem = [[UIButton alloc] initWithFrame:CGRectMake(Btn_Margin, 0, Equal_Width, Equal_Height)];
                    [self.tabBgView addSubview:tabBarItem];
                    tabBarItem.tag = i;
                    
                    UIImageView * title_Image = [[UIImageView alloc] initWithFrame:CGRectMake(tabBarItem.frame.size.width / 2 - Tit_ImgWH / 2, (tabBarItem.frame.size.height - bottom_Margin - titleLab_Height) / 2 - Tit_ImgWH / 2 + top_Margin, Tit_ImgWH, Tit_ImgWH)];
                    title_Image.tag = i;
                    [tabBarItem addSubview:title_Image];
                    
                    UILabel * title_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, tabBarItem.frame.size.height - bottom_Margin - titleLab_Height, tabBarItem.frame.size.width, titleLab_Height)];
                    title_Label.tag = i;
                    [tabBarItem addSubview:title_Label];
                    title_Label.font = [UIFont systemFontOfSize:TitLab_Font];
                    title_Label.textAlignment = NSTextAlignmentCenter;
                    title_Label.text = titleArray[i];
                    
                    if (self.selectedIndex == i)
                    {
                        title_Image.image = selectedImageArray[i];
                        title_Label.textColor = titleSelectColor;
                    } else
                    {
                        title_Image.image = UnSelectedImageArray[i];
                        title_Label.textColor = titleUnSelectColor;
                    }
                    
                    [tabBarItem addTarget:self action:@selector(TabBarItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
                }
            } else
            {
                UIButton * tabBarItem = [[UIButton alloc] initWithFrame:CGRectMake(Equal_Width * i, 0, Equal_Width, Equal_Height)];
                [self.tabBgView addSubview:tabBarItem];
                tabBarItem.tag = i;
                
                UIImageView * title_Image = [[UIImageView alloc] initWithFrame:CGRectMake(tabBarItem.frame.size.width / 2 - Tit_ImgWH / 2, (tabBarItem.frame.size.height - bottom_Margin - titleLab_Height) / 2 - Tit_ImgWH / 2 + top_Margin, Tit_ImgWH, Tit_ImgWH)];
                title_Image.tag = i;
                [tabBarItem addSubview:title_Image];
                
                UILabel * title_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, tabBarItem.frame.size.height - bottom_Margin - titleLab_Height, tabBarItem.frame.size.width, titleLab_Height)];
                title_Label.tag = i;
                [tabBarItem addSubview:title_Label];
                title_Label.font = [UIFont systemFontOfSize:TitLab_Font];
                title_Label.textAlignment = NSTextAlignmentCenter;
                title_Label.text = titleArray[i];
                
                if (self.selectedIndex == i)
                {
                    title_Image.image = selectedImageArray[i];
                    title_Label.textColor = titleSelectColor;
                } else
                {
                    title_Image.image = UnSelectedImageArray[i];
                    title_Label.textColor = titleUnSelectColor;
                }
                
                [tabBarItem addTarget:self action:@selector(TabBarItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        } else
        {
            UIButton * tabBarItem = [[UIButton alloc] initWithFrame:CGRectMake(Equal_Width * i, 0, Equal_Width, Equal_Height)];
            [self.tabBgView addSubview:tabBarItem];
            tabBarItem.tag = i;
            
            UIImageView * title_Image = [[UIImageView alloc] initWithFrame:CGRectMake(tabBarItem.frame.size.width / 2 - Tit_ImgWH / 2, (tabBarItem.frame.size.height - bottom_Margin - titleLab_Height) / 2 - Tit_ImgWH / 2 + top_Margin, Tit_ImgWH, Tit_ImgWH)];

            title_Image.tag = i;
            [tabBarItem addSubview:title_Image];
            
            UILabel * title_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, tabBarItem.frame.size.height - bottom_Margin - titleLab_Height, tabBarItem.frame.size.width, titleLab_Height)];
            title_Label.tag = i;
            [tabBarItem addSubview:title_Label];
            title_Label.font = [UIFont systemFontOfSize:TitLab_Font];
            title_Label.textAlignment = NSTextAlignmentCenter;
            title_Label.text = titleArray[i];
            
            if (self.selectedIndex == i)
            {
                title_Image.image = selectedImageArray[i];
                title_Label.textColor = titleSelectColor;
            } else
            {
                title_Image.image = UnSelectedImageArray[i];
                title_Label.textColor = titleUnSelectColor;
            }
            
            [tabBarItem addTarget:self action:@selector(TabBarItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - 添加点击事件...
- (void)TabBarItemDidClicked:(UIButton *)sender
{
    // 首次遍历最底层父类视图,在遍历子类视图上的子类视图,获取到对应的孙控件...
    for (id viewSubs in [self.tabBgView subviews])
    {
        if ([viewSubs isKindOfClass:[UIButton class]])
        {
            UIButton * button = (UIButton *)viewSubs;
            
            // 逐个获取button
            if (button.tag == sender.tag) // 点击的button为当前button...
            {
                // 选中的按钮...
                if (self.isImageLarge == YES)
                {
                    if (_itemNum % 2 != 0)
                    {
                        if (sender.tag == (_itemNum / 2))
                        {
                           
                        } else
                        {
                            for (id btnSubs in [button subviews])
                            {
                                if ([btnSubs isKindOfClass:[UIImageView class]])
                                {
                                    UIImageView * imageView = (UIImageView *)btnSubs;
                                    imageView.image = _selectedImageArray[sender.tag];
                                }
                                if ([btnSubs isKindOfClass:[UILabel class]])
                                {
                                    UILabel * label = (UILabel *)btnSubs;
                                    label.textColor = _selectedColor;
                                }
                            }
                        }
                    } else
                    {
                        
                        for (id btnSubs in [button subviews])
                        {
                            if ([btnSubs isKindOfClass:[UIImageView class]])
                            {
                                UIImageView * imageView = (UIImageView *)btnSubs;
                                imageView.image = _selectedImageArray[sender.tag];
                            }
                            if ([btnSubs isKindOfClass:[UILabel class]])
                            {
                                UILabel * label = (UILabel *)btnSubs;
                                label.textColor = _selectedColor;
                            }
                        }
                    }
                } else
                {
                    for (id btnSubs in [button subviews])
                    {
                        if ([btnSubs isKindOfClass:[UIImageView class]])
                        {
                            UIImageView * imageView = (UIImageView *)btnSubs;
                            imageView.image = _selectedImageArray[sender.tag];
                        }
                        if ([btnSubs isKindOfClass:[UILabel class]])
                        {
                            UILabel * label = (UILabel *)btnSubs;
                            label.textColor = _selectedColor;
                        }
                    }
                }
            } else
            {
                // 非选中的按钮...
                if (self.isImageLarge == YES)
                {
                    if (_itemNum % 2 != 0)
                    {
                        // 当中间按钮增大时找到中间按钮...
                        if (sender.tag == (_itemNum / 2))
                        {
                            for (id btnSubs in [button subviews])
                            {
                                if ([btnSubs isKindOfClass:[UIImageView class]])
                                {
                                    UIImageView * backImgView = (UIImageView *)btnSubs;
                                    if (backImgView.tag == _itemNum / 2)
                                    {
                                    } else
                                    {
                                        UIImageView * imageView = (UIImageView *)btnSubs;
                                        imageView.image = _UnselectedImageArray[backImgView.tag];
                                    }
                                }
                                if ([btnSubs isKindOfClass:[UILabel class]])
                                {
                                    UILabel * label = (UILabel *)btnSubs;
                                    if (label.tag == _itemNum / 2)
                                    {
                                    } else
                                    {
                                        label.textColor = _UnselectedColor;
                                    }
                                }
                            }
                        } else
                        {
                            for (id btnSubs in [button subviews])
                            {
                                if ([btnSubs isKindOfClass:[UIImageView class]])
                                {
                                    UIImageView * backImgView = (UIImageView *)btnSubs;
                                    if (backImgView.tag == _itemNum / 2)
                                    {
                                    } else
                                    {
                                        UIImageView * imageView = (UIImageView *)btnSubs;
                                        imageView.image = _UnselectedImageArray[backImgView.tag];
                                    }
                                }
                                if ([btnSubs isKindOfClass:[UILabel class]])
                                {
                                    UILabel * label = (UILabel *)btnSubs;
                                    if (label.tag == _itemNum / 2)
                                    {
                                    } else
                                    {
                                        label.textColor = _UnselectedColor;
                                    }
                                }
                            }
                        }
                    } else
                    {
                        for (id btnSubs in [button subviews])
                        {
                            if ([btnSubs isKindOfClass:[UIImageView class]])
                            {
                                UIImageView * backImgView = (UIImageView *)btnSubs;
                                UIImageView * imageView = (UIImageView *)btnSubs;
                                imageView.image = _UnselectedImageArray[backImgView.tag];
                            }
                            if ([btnSubs isKindOfClass:[UILabel class]])
                            {
                                UILabel * label = (UILabel *)btnSubs;
                                label.textColor = _UnselectedColor;
                            }
                        }
                    }
                } else
                {
                    for (id btnSubs in [button subviews])
                    {
                        if ([btnSubs isKindOfClass:[UIImageView class]])
                        {
                            UIImageView * backImgView = (UIImageView *)btnSubs;
                            UIImageView * imageView = (UIImageView *)btnSubs;
                            imageView.image = _UnselectedImageArray[backImgView.tag];
                        }
                        if ([btnSubs isKindOfClass:[UILabel class]])
                        {
                            UILabel * label = (UILabel *)btnSubs;
                            label.textColor = _UnselectedColor;
                        }
                    }
                }
            }
        }
    }
    
    [self.delegate tabBarItemDidSelectAtIndex:sender.tag];
}

#pragma mark - 设置选中索引...
- (void)setCustomTabBarSelectedIndex:(NSInteger)selectedIndex
{
    for (id viewSubs in [self.tabBgView subviews])
    {
        if ([viewSubs isKindOfClass:[UIButton class]])
        {
            UIButton * button = (UIButton *)viewSubs;
            if (button.tag == selectedIndex)
            {
                [self TabBarItemDidClicked:button];
            }
        }
    }
}

@end
