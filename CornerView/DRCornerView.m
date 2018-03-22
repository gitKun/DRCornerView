//
//  DRCornerView.m
//  DRCornerView
//
//  Created by DR_Kun on 2018/3/19.
//  Copyright © 2018年 DR_Kun. All rights reserved.
//

/*
 思路:
    1. 使用UIVew的子类DRCornerView添加到需要实现圆角化的view上
    2. DRCornerView的layer层使用CAShapLayer进行呈现
 */

#import "DRCornerView.h"

@interface DRCornerView ()

@property (nonatomic, assign) BOOL hasCorner;

@end


@implementation DRCornerView

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [self.shapeLayer ];
    [self setupCornerLayer];
}

- (void)setupCornerLayer {
    self.backgroundColor = [UIColor clearColor];
    CGRect rect = self.bounds;
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    UIBezierPath * path= [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, width, height)];
    CAShapeLayer *shapeLayer = self.shapeLayer;
    UIRectCorner sysCorner = UIRectCornerAllCorners;
    CGFloat radius = self.radius ? : 0;
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:sysCorner cornerRadii:CGSizeMake(radius, radius)];
    [path  appendPath:cornerPath];
        //[path setUsesEvenOddFillRule:YES];
    shapeLayer.path = path.CGPath;
    /*
     字面意思是“奇偶”。按该规则，要判断一个点是否在图形内，从该点作任意方向的一条射线，然后检测射线与图形路径的交点的数量。如果结果是奇数则认为点在内部，是偶数则认为点在外部
     */
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    UIColor *fillColor = self.cornerColor ? : [UIColor clearColor];
    shapeLayer.fillColor = fillColor.CGColor;
}

@end
