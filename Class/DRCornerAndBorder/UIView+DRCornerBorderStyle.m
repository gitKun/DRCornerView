//
//  UIView+DRCornerBorderStyle.m
//  DRCornerAndBorderDemo
//
//  Created by DR_Kun on 2018/12/31.
//  Copyright © 2018 DR_Kun. All rights reserved.
//

#import "UIView+DRCornerBorderStyle.h"
#import <objc/runtime.h>
#import "DRCornerBorderStyle+Private.h"

static NSString *DR_CornerLayerName         = @"DR_CornerLayer";
static NSString *DR_CornerBorderLayerName   = @"DR_CornerBorderLayer";
static NSString *DR_BorderLayerName         = @"DR_BorderLayer";
static NSString *DR_CornerBorderStyleName   = @"DR_CornerBorderStyle";


@implementation UIView (DRCornerBorderStyle)

#pragma mark === Public

- (void)dr_makeCornerBorder:(void(^)(DRCornerBorderStyle *style))style {
    [[self dr_style] cleanCache];
    style([self dr_style]);
    [self registCornerLayer];
    [self setNeedsLayout];
}

- (void)dr_autoCorner:(void(^)(DRCornerBorderStyle *style))style {
    [[self dr_style] cleanCache];
    style([self dr_style]);
    [[self dr_style] autoCorner];
    [self registCornerLayer];
    [self setNeedsLayout];
}

- (BOOL)dr_hasMakeCornerBorderStyle {
    return [self dr_hasBorderStyle] || [self dr_hasCornerStyle] || [self dr_hasCornerBorderStyle];
}

- (BOOL)dr_hasCornerStyle {
    return self.dr_cornerLayer != nil;
}

- (BOOL)dr_hasCornerBorderStyle {
    return self.dr_cornerBorderLayer != nil;
}

- (BOOL)dr_hasBorderStyle {
    return self.dr_borderLayer != nil;
}

- (void)dr_removeCornerStyle {
    [[self dr_cornerLayer] removeFromSuperlayer];
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DR_CornerLayerName), nil, OBJC_ASSOCIATION_RETAIN);
}

- (void)dr_removeCornerBorderStyle {
    [[self dr_cornerBorderLayer] removeFromSuperlayer];
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DR_CornerBorderLayerName), nil, OBJC_ASSOCIATION_RETAIN);
}

- (void)dr_removeBorederStyle {
    [[self dr_borderLayer] removeFromSuperlayer];
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DR_BorderLayerName), nil, OBJC_ASSOCIATION_RETAIN);
}

- (void)dr_removeAllStyle {
    [self dr_removeCornerStyle];
    [self dr_removeCornerBorderStyle];
    [self dr_removeBorederStyle];
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DR_CornerBorderStyleName), nil, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark === 交换方法

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalLayoutSublayersOfLayerMethod = class_getInstanceMethod(self, @selector(layoutSublayersOfLayer:));
        Method exchangeLayoutSublayersOfLayer = class_getInstanceMethod(self, @selector(dr_cornerBorderSublayersOfLayer:));
        method_exchangeImplementations(originalLayoutSublayersOfLayerMethod, exchangeLayoutSublayersOfLayer);
    });
}

- (void)dr_cornerBorderSublayersOfLayer:(CALayer *)layer {
    [self dr_cornerBorderSublayersOfLayer:layer];
    if (self.dr_hasMakeCornerBorderStyle) {
        [self dr_refreshCornerBorderStyle];
    }
}

#pragma mark === 实现绘制方法

- (void)dr_refreshCornerBorderStyle {
    if (CGRectEqualToRect(self.bounds, CGRectZero)) {
        return;
    }
    CGRect viewBounds = self.bounds;
    DRCornerBorderStyle *style = [self dr_style];
    UIColor *fillColor = style.dr_coverBGColor;
    if (!fillColor) {
        if (self.superview && self.superview.backgroundColor != nil) {
            fillColor = self.superview.backgroundColor;
        }else {
            fillColor = [UIColor clearColor];
        }
    }
    CGRect cornerRect = viewBounds;
    UIColor *offsetLineColor = style.dr_cornerBorderColor ? : [UIColor clearColor];
    CGFloat offsetLineWidth = style.dr_cornerLineWidth >= 0.5 ? style.dr_cornerLineWidth : 0;
    // 因为 iOS 线的宽度是从 0 往两边均匀分配的，所以有边框时要计算实际的圆角的边框
    cornerRect = CGRectMake(CGRectGetMinX(cornerRect) + offsetLineWidth * 0.5, CGRectGetMinY(cornerRect) + offsetLineWidth * 0.5, CGRectGetWidth(cornerRect) - offsetLineWidth * 0.5, CGRectGetHeight(cornerRect) - offsetLineWidth * 0.5);
    // 路径
    UIBezierPath *cornerPath = [self coverLayerPathWihtRect:cornerRect];
    UIBezierPath *fillPath = [UIBezierPath bezierPathWithRect:viewBounds];
    [fillPath appendPath:cornerPath];
    // 设置覆盖的layer
    [self registCornerLayer];
    CAShapeLayer *cornerLayer = [self dr_cornerLayer];
    cornerLayer.path = fillPath.CGPath;
    cornerLayer.fillRule = kCAFillRuleEvenOdd;
    cornerLayer.fillColor = fillColor.CGColor;
    // 设置覆盖的边框
    if (offsetLineWidth) {
        [self registCornerBorderLayer];
        CAShapeLayer *borderLayer = [self dr_cornerBorderLayer];
        borderLayer.path = cornerPath.CGPath;
        borderLayer.fillColor = UIColor.clearColor.CGColor;
        borderLayer.lineWidth = offsetLineWidth;
        borderLayer.strokeColor = offsetLineColor.CGColor;
    }else {
        [self dr_removeCornerBorderStyle];
    }
    // 绘制边框
    [self showBorderStyle];
}

#pragma mark === 覆盖后显示的路径

- (UIBezierPath *)coverLayerPathWihtRect:(CGRect)cornerRect {
    CGFloat width = CGRectGetWidth(cornerRect);
    CGFloat height = CGRectGetHeight(cornerRect);
    CGFloat x = CGRectGetMinX(cornerRect);
    CGFloat y = CGRectGetMinY(cornerRect);
    CGFloat maxRadius = MIN(width, height) * 0.5;
    DRCornerBorderStyle *style = [self dr_style];
    CGFloat topLeftRadius     = style.dr_topLeftRadius;
    CGFloat topRightRadius    = style.dr_topRightRadius;
    CGFloat bottomRightRadius = style.dr_bottomRightRadius;
    CGFloat bottomLeftRadius  =  style.dr_bottomLeftRadius;
    // 使用自动圆角
    if (style.dr_useAutoCorner) {
        topLeftRadius = topRightRadius = bottomRightRadius = bottomLeftRadius =  maxRadius;
    }else {
        topLeftRadius = topLeftRadius < maxRadius ? topLeftRadius : maxRadius;
        topRightRadius = topLeftRadius < maxRadius ? topRightRadius : maxRadius;
        bottomRightRadius = bottomRightRadius < maxRadius ? bottomRightRadius : maxRadius;
        bottomLeftRadius = bottomLeftRadius < maxRadius ? bottomLeftRadius : maxRadius;
    }

    // 声明各个点 topLeft -> A & B, topRight -> C & D, bottomRight -> E & F, bottomLeft -> G & H;
    CGPoint topLeftPoint     = CGPointMake(x, y);
    CGPoint topRightPoint    = CGPointMake(width, y);
    CGPoint bottonRightPoint = CGPointMake(width, height);
    CGPoint bottonLeftPoint  = CGPointMake(x, height);
    CGPoint aPoint = topLeftPoint, bPoint = topLeftPoint, cPoint = topRightPoint, dPoint = topRightPoint, ePoint = bottonRightPoint, fPoint = bottonRightPoint, gPoint = bottonLeftPoint, hPoint = bottonLeftPoint;

    // 声明控制点(有控制点则为圆角处理---实际是根据定点对应的两坐标点是否一致来进行控制的,否则为非圆角处理)
    CGPoint nullControlPoint = CGPointMake(-100, -100);// 为了逻辑严谨，这个点应该修改为 NaN 这样的形式
    CGPoint aControlPoint = nullControlPoint, bControlPoint = nullControlPoint, cControlPoint = nullControlPoint, dControlPoint = nullControlPoint, eControlPoint = nullControlPoint, fControlPoint = nullControlPoint, gControlPoint = nullControlPoint, hControlPoint = nullControlPoint;
    // 定义圆角常量
    CGFloat controlPointOffsetRatio = 0.552;
    if (topLeftRadius > 1) {
        CGFloat offset = controlPointOffsetRatio * topLeftRadius;
        aPoint = CGPointMake(aPoint.x, aPoint.y + topLeftRadius);
        bPoint = CGPointMake(bPoint.x + topLeftRadius, bPoint.y);
        aControlPoint = CGPointMake(aPoint.x          , aPoint.y - offset);
        bControlPoint = CGPointMake(bPoint.x - offset , bPoint.y         );
    }
    if (topRightRadius > 1) {
        CGFloat offset = controlPointOffsetRatio * topRightRadius;
        cPoint = CGPointMake(cPoint.x - topRightRadius, cPoint.y);
        dPoint = CGPointMake(dPoint.x, dPoint.y + topRightRadius);
        cControlPoint = CGPointMake(cPoint.x + offset , cPoint.y         );
        dControlPoint = CGPointMake(dPoint.x          , dPoint.y - offset);
    }
    if (bottomRightRadius > 1) {
        CGFloat offset = controlPointOffsetRatio * bottomRightRadius;
        ePoint = CGPointMake(ePoint.x, ePoint.y - bottomRightRadius);
        fPoint = CGPointMake(fPoint.x - bottomRightRadius, fPoint.y);
        eControlPoint = CGPointMake(ePoint.x          , ePoint.y + offset);
        fControlPoint = CGPointMake(fPoint.x + offset , fPoint.y         );
    }
    if (bottomLeftRadius > 1) {
        CGFloat offset = controlPointOffsetRatio * bottomLeftRadius;
        gPoint = CGPointMake(gPoint.x + bottomLeftRadius, gPoint.y);
        hPoint = CGPointMake(hPoint.x, hPoint.y - bottomLeftRadius);
        gControlPoint = CGPointMake(gPoint.x - offset , gPoint.y);
        hControlPoint = CGPointMake(hPoint.x, hPoint.y + offset);
    }
    // 划线顺序: B -> C -> D -> E -> F -> G -> H -> A -> B(ClosePath);
    UIBezierPath *cornerPath = [UIBezierPath bezierPath];
    [cornerPath moveToPoint:bPoint];
    [cornerPath addLineToPoint:cPoint];
    if (!CGPointEqualToPoint(cPoint, dPoint)) {
        [cornerPath addCurveToPoint:dPoint controlPoint1:cControlPoint controlPoint2:dControlPoint];
    }
    [cornerPath addLineToPoint:ePoint];
    if (!CGPointEqualToPoint(ePoint, fPoint)) {
        [cornerPath addCurveToPoint:fPoint controlPoint1:eControlPoint controlPoint2:fControlPoint];
    }

    [cornerPath addLineToPoint:gPoint];
    if (!CGPointEqualToPoint(gPoint, hPoint)) {
        [cornerPath addCurveToPoint:hPoint controlPoint1:gControlPoint controlPoint2:hControlPoint];
    }
    [cornerPath addLineToPoint:aPoint];
    if (!CGPointEqualToPoint(aPoint, bPoint)) {
        [cornerPath addCurveToPoint:bPoint controlPoint1:aControlPoint controlPoint2:bControlPoint];
    }
    [cornerPath closePath];
    return cornerPath;
}

#pragma mark === 绘制四条边框
- (void)showBorderStyle {
    DRCornerBorderStyle *style = [self dr_style];
//    if (!style) {
//        [self dr_removeBorederStyle];
//        return;
//    }
    CGFloat lineWith = style.dr_borderLineWidth > 0.5 ? style.dr_borderLineWidth : 0;
    if (!lineWith) {
        [self dr_removeBorederStyle];
        return;
    }
    UIColor *lineColor = style.dr_borderColor;
    if (!lineColor || lineColor == [UIColor clearColor]) {
        [self dr_removeBorederStyle];
        return;
    }
    if (!style.dr_hasTopBorder && !style.dr_hasRightBorder && !style.dr_hasBottomBorder && !style.dr_hasLeftBorder) {
        [self dr_removeBorederStyle];
        return;
    }
    [self registBorderLayer];
    CGRect viewBouns = self.bounds;
    CGFloat x = 0;//CGRectGetMinX(viewBouns);
    CGFloat y = 0;//CGRectGetMinY(viewBouns);
    CGFloat width = CGRectGetWidth(viewBouns);
    CGFloat height = CGRectGetHeight(viewBouns);
    CGFloat offsetLineWidth = lineWith * 0.5;
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (style.dr_hasTopBorder) {
        UIEdgeInsets edg = style.dr_topBorderEdg;
        CGFloat offsetX = MAX(0, MIN(width, edg.left));
        CGFloat offsetY = MAX(offsetLineWidth, MIN(height - offsetLineWidth, edg.top + offsetLineWidth)) ;
        CGPoint start = CGPointMake(x + offsetX, y + offsetY);
        offsetX = MAX(0, MIN(width, edg.right));
        CGPoint end = CGPointMake(width - offsetX, y + offsetY);
        [path moveToPoint:start];
        [path addLineToPoint:end];
    }
    if (style.dr_hasBottomBorder) {
        UIEdgeInsets edg = style.dr_bottomBorderEdg;
        CGFloat offsetX = MAX(0, MIN(width, edg.left));
        CGFloat offsetY = MAX(offsetLineWidth, MIN(height - offsetLineWidth, edg.bottom + offsetLineWidth)) ;
        CGPoint start = CGPointMake(x + offsetX, height - offsetY);
        offsetX = MIN(width, edg.right);
        CGPoint end = CGPointMake(width - offsetX, height - offsetY);
        [path moveToPoint:start];
        [path addLineToPoint:end];
    }
    if (style.dr_hasLeftBorder) {
        UIEdgeInsets edg = style.dr_leftBorderEdg;
        CGFloat offsetX = MAX(0, MIN(width - offsetLineWidth, edg.left + offsetLineWidth));
        CGFloat offsetY = MAX(0, MIN(height, edg.top));
        CGPoint start = CGPointMake(x + offsetX, y + offsetY);
        offsetY = MAX(0, MIN(height, edg.bottom));
        CGPoint end = CGPointMake(x + offsetX, height - offsetY);
        [path moveToPoint:start];
        [path addLineToPoint:end];
    }
    if (style.dr_hasRightBorder) {
        UIEdgeInsets edg = style.dr_rightBorderEdg;
        CGFloat offsetX = MAX(0, MIN(width - offsetLineWidth, edg.right + offsetLineWidth));
        CGFloat offsetY = MAX(0, MIN(height, edg.top));
        CGPoint start = CGPointMake(width - offsetX, y + offsetY);
        offsetY = MAX(0, MIN(height, edg.bottom));
        CGPoint end = CGPointMake(width - offsetX, height - offsetY);
        [path moveToPoint:start];
        [path addLineToPoint:end];
    }
    CAShapeLayer *layer = [self dr_borderLayer];
    layer.path = path.CGPath;
    layer.lineWidth = lineWith;
    layer.strokeColor = lineColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
}

#pragma mark === getter

- (CAShapeLayer *)dr_borderLayer {
    CAShapeLayer *shapLayer = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(DR_BorderLayerName));
    return shapLayer;
}

- (CAShapeLayer *)dr_cornerLayer {
    CAShapeLayer *shapLayer = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(DR_CornerLayerName));
    return shapLayer;
}

- (CAShapeLayer *)dr_cornerBorderLayer {
    CAShapeLayer *shapLayer = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(DR_CornerBorderLayerName));
    return shapLayer;
}

- (DRCornerBorderStyle *)dr_style {
    DRCornerBorderStyle *style = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(DR_CornerBorderStyleName));
    if (!style) {
        style = [[DRCornerBorderStyle alloc] init];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DR_CornerBorderStyleName), style, OBJC_ASSOCIATION_RETAIN);
    }
    return style;
}

#pragma makk === 注册 shapelayer

- (void)registBorderLayer {
    if (!self.dr_borderLayer) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DR_BorderLayerName), shapeLayer, OBJC_ASSOCIATION_RETAIN);
        [self.layer insertSublayer:shapeLayer atIndex:MAXFLOAT - 1];
    }
}

- (void)registCornerLayer {
    if (!self.dr_cornerLayer) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DR_CornerLayerName), shapeLayer, OBJC_ASSOCIATION_RETAIN);
        [self.layer insertSublayer:shapeLayer atIndex:MAXFLOAT - 3];
    }
}

- (void)registCornerBorderLayer {
    if (!self.dr_cornerBorderLayer) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DR_CornerBorderLayerName), shapeLayer, OBJC_ASSOCIATION_RETAIN);
        [self.layer insertSublayer:shapeLayer atIndex:MAXFLOAT - 2];
    }
}

#pragma mark === 删除


@end
