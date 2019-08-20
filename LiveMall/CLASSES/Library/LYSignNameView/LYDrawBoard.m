//
//  LYPointVIew.m
//  SignName
//
//  Created by Misaya on 16/5/18.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "LYDrawBoard.h"

//给定默认宽度
#define kDefaultWidth 2

//给定默认颜色
#define kDefaultColor [UIColor blackColor]

@interface LYDrawBoard ()

@end

@implementation LYDrawBoard

//MARK: - lazy

- (NSMutableArray *)points
{
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}

//MARK: - default

- (CGFloat)lineWidth {
    
    if (!_lineWidth) {
        _lineWidth = kDefaultWidth;
    }
    return _lineWidth;
}

- (UIColor *)color {
    
    if (!_color) {
        _color = kDefaultColor;
    }
    return _color;
}

//MARK: -

- (void)clear
{
    [self.points removeAllObjects];
    [self setNeedsDisplay];
}

- (void)back
{
    [self.points removeLastObject];
    [self setNeedsDisplay];
}

/**
 *  确定起点
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint startPos = [touch locationInView:touch.view];
    
    //添加路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //设置路径的起始点为圆点
    path.lineCapStyle = kCGLineCapRound;
   
    //设置路径的结束点为圆点
    path.lineJoinStyle = kCGLineJoinRound;

    //路径的起始点用 moveToPoint：
    [path moveToPoint:startPos];
    [self.points addObject:path];
    
    //刷新帧
    [self setNeedsDisplay];
}

/**
 *  连线
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPos = [touch locationInView:touch.view];
    
    UIBezierPath *currentPath = self.points.lastObject;
    [currentPath addLineToPoint:currentPos];
    
    //刷新帧
    [self setNeedsDisplay];
}

/**
 *  结束时也调用touchesMoved来将终点连线
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

/**
 *  重绘
 */
- (void)drawRect:(CGRect)rect
{
    //先设置颜色
    [self.color set];
    //遍历所有path，设置宽度，并分别调用stroke
    for (UIBezierPath *path in self.points) {
        path.lineWidth = self.lineWidth;
        [path stroke];
    }

}

@end
