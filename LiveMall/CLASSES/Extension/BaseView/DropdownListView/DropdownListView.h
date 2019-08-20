//
//  DropdownListView.h
//  FotileCSS
//
//  Created by Minimalism C on 2018/11/30.
//  Copyright © 2018 BaoBao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 下拉框view
 */
NS_ASSUME_NONNULL_BEGIN

@interface DropdownListItem : NSObject

@property (nonatomic, copy, readonly) NSString *itemId;
@property (nonatomic, copy, readonly) NSString *itemName;

- (instancetype)initWithItem:(NSString *)itemId itemName:(NSString *)itemName NS_DESIGNATED_INITIALIZER;

@end

@class DropdownListView;

typedef void (^DropdownListViewSelectedBlock)(DropdownListView *dropdownListView);

@interface DropdownListView : UIView

// 字体颜色，默认 blackColor
@property (nonatomic, strong) UIColor *textColor;

// 字体默认14
@property (nonatomic, strong) UIFont *font;

// 默认选中第一个
@property (nonatomic, assign) NSUInteger selectedIndex;

// 当前选中的DropdownListItem
@property (nonatomic, strong, readonly) DropdownListItem *selectedItem;

- (instancetype)initWithDataSource:(NSArray *)dataSource;

/**
 设置数据源，默认显示第一个，下拉的时候，如果数据源中含有请选择等数据源，需要移除就移除

 @param dataSource 数据源
 @param isRemove 是否移除
 */
- (void)setDataSource:(NSArray *)dataSource andRemoveFirstData:(BOOL)isRemove;

//设置圆角
- (void)setViewBorder:(CGFloat)width borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius;

//点击事件
- (void)setDropdownListViewSelectedBlock:(DropdownListViewSelectedBlock)block;

//设置下拉框分割线
- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle)style;

@end

NS_ASSUME_NONNULL_END
