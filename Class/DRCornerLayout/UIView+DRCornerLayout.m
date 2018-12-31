//
//  UIView+DRCornerLayout.m
//  Demo
//
//  Created by DR_Kun on 2018/12/28.
//  Copyright © 2018 DR_Kun. All rights reserved.
//

#import "UIView+DRCornerLayout.h"
#import "DRCornerLayout+Private.h"
#import <objc/runtime.h>

static NSString *DRCornerLayoutCornerLayerName = @"DRCornerLayoutCornerLayer";
static NSString *DRCornerLayoytBorderLayerName = @"DRCornerLayoytBorderLayer";
const  NSString *DRCornerLayoutModelName = @"DRCornerLayoutModel";


@implementation UIView (DRCornerLayout)

#pragma mark >>>>>>> 改写 begain

#pragma mark === Public

- (void)dr_makeCorner:(void(^)(DRCornerLayout *layout))layout {
    DRCornerLayout *model = [self dr_layout];
    [model cleanCache];
    layout([self dr_layout]);
    [self registDRLayoutCornenrLayer];
    [self setNeedsLayout];
}

- (void)dr_updateCorner:(void(^)(DRCornerLayout *layout))layout {
    layout([self dr_layout]);
    [self registDRLayoutCornenrLayer];
    [self setNeedsLayout];
}

- (void)dr_autoLayoutCorner:(void(^)(DRCornerLayout *layout))layout {
    DRCornerLayout *model = [self dr_layout];
    [model cleanCache];
    layout(model);
    [model autoLayoutCorner];
    [self registDRLayoutCornenrLayer];
    [self setNeedsLayout];
}

#pragma mark === Layout

- (DRCornerLayout *)dr_layout {
    DRCornerLayout *model = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(DRCornerLayoutModelName));
    if (!model) {
        model = [[DRCornerLayout alloc] init];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DRCornerLayoutModelName), model, OBJC_ASSOCIATION_RETAIN);
    }else {
        // 这里删除 layout 中存储的信息

    }
    return model;
}

#pragma mark === Layer

- (CAShapeLayer *)drLayout_cornerLayer {
    CAShapeLayer *shapLayer = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(DRCornerLayoutCornerLayerName));
    return shapLayer;
}

- (CAShapeLayer *)drLayout_borderLayer {
    CAShapeLayer *shapLayer = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(DRCornerLayoytBorderLayerName));
    return shapLayer;
}

- (void)registDRLayoutCornenrLayer {
    // 先移除不会产生隐式动画
//    if ([self drLayout_cornerLayer]) {
//        [self removeDRLayoutCorner];
//    }
    if (![self drLayout_cornerLayer]) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DRCornerLayoutCornerLayerName), shapeLayer, OBJC_ASSOCIATION_RETAIN);
        [self.layer insertSublayer:shapeLayer atIndex:MAXFLOAT - 3];
    }
}

- (void)registDRLayoutBorderLayer {
    if (![self drLayout_borderLayer]) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DRCornerLayoytBorderLayerName), shapeLayer, OBJC_ASSOCIATION_RETAIN);
        [self.layer insertSublayer:shapeLayer atIndex:MAXFLOAT - 2];
    }
}

- (BOOL)hasDRLayoutCornered {
    return [self drLayout_cornerLayer] != nil;
}

#pragma mark === 交换方法

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalLayoutSublayersOfLayerMethod = class_getInstanceMethod(self, @selector(layoutSublayersOfLayer:));
        Method drLayoutSublayersOfLayer = class_getInstanceMethod(self, @selector(dr_cornerLayoutSublayersOfLayer:));
        method_exchangeImplementations(originalLayoutSublayersOfLayerMethod, drLayoutSublayersOfLayer);
    });
}

- (void)dr_cornerLayoutSublayersOfLayer:(CALayer *)layer {
    [self dr_cornerLayoutSublayersOfLayer:layer];
    if ([self hasDRLayoutCornered] ) {
        [self dr_resetLayoutCornerLayer];
    }
}

// 实际调整圆角的方法
- (void)dr_resetLayoutCornerLayer {
    if (CGRectEqualToRect(self.bounds, CGRectZero)) {
        return;
    }
    CGRect viewBounds = self.bounds;
    DRCornerLayout *model = [self dr_layout];
    CGFloat topLeftRadius     = model.dr_topLeftRadius;
    CGFloat topRightRadius    = model.dr_topRightRadius;
    CGFloat bottomRightRadius = model.dr_bottomRightRadius;
    CGFloat bottomLeftRadius  =  model.dr_bottomLeftRadius;
    if (model.dr_allCornerRadius > 1) {
        topLeftRadius = topRightRadius = bottomRightRadius = bottomLeftRadius = model.dr_allCornerRadius;
    }
    if (model.dr_autoCorner) {
        CGFloat radius = MIN(CGRectGetWidth(viewBounds), CGRectGetHeight(viewBounds)) * 0.5;
        topLeftRadius = topRightRadius = bottomRightRadius = bottomLeftRadius = radius;
    }
    if (topLeftRadius + topRightRadius + bottomRightRadius + bottomLeftRadius < 1) {
        [self removeDRLayoutCorner];
        return;
    }

    if (!model.dr_coverBGColor) {
        if (self.superview && self.superview.backgroundColor != [UIColor clearColor]) {
            model.coverBGColor(self.superview.backgroundColor);
        }else {
            return;
        }
    }
    // 绘制
    // --->>>> 严重声明:所添加的圆角为 Round Corners 非 平滑圆角，(两者区别请咨询 UI 设计) <<<---
    CGRect cornerRect = viewBounds;
    CGFloat lineWidth = 0;
    if (model.dr_borderColor && model.dr_lineWidth > 0.5) {
        lineWidth = model.dr_lineWidth;
        // 因为 iOS 线的宽度是从 0 往两边均匀分配的，所以有边框时要计算实际的圆角的边框
        cornerRect = CGRectMake(CGRectGetMinX(cornerRect) + lineWidth * 0.5, CGRectGetMinY(cornerRect) + lineWidth * 0.5, CGRectGetWidth(cornerRect) - lineWidth * 0.5, CGRectGetHeight(cornerRect) - lineWidth * 0.5);
        // 注册描边的 layer
        [self registDRLayoutBorderLayer];
    }

    CGFloat width = CGRectGetWidth(cornerRect);
    CGFloat height = CGRectGetHeight(cornerRect);
    CGFloat x = CGRectGetMinX(cornerRect);
    CGFloat y = CGRectGetMinY(cornerRect);
    CGFloat maxRadius = MIN(width, height) * 0.5;
    topLeftRadius = topLeftRadius < maxRadius ? topLeftRadius : maxRadius;
    topRightRadius = topLeftRadius < maxRadius ? topRightRadius : maxRadius;
    bottomRightRadius = bottomRightRadius < maxRadius ? bottomRightRadius : maxRadius;
    bottomLeftRadius = bottomLeftRadius < maxRadius ? bottomLeftRadius : maxRadius;
    // 声明各个点 topLeft -> A & B, topRight -> C & D, bottomRight -> E & F, bottomLeft -> G & H;
    CGPoint topLeftPoint     = CGPointMake(x, y);
    CGPoint topRightPoint    = CGPointMake(width, y);
    CGPoint bottonRightPoint = CGPointMake(width, height);
    CGPoint bottonLeftPoint  = CGPointMake(x, height);
    CGPoint aPoint = topLeftPoint, bPoint = topLeftPoint, cPoint = topRightPoint, dPoint = topRightPoint, ePoint = bottonRightPoint, fPoint = bottonRightPoint, gPoint = bottonLeftPoint, hPoint = bottonLeftPoint;
    
    // 声明控制点(有控制点则为圆角处理---实际是根据定点对应的两坐标点是否一致来进行控制的,否则为非圆角处理)
    CGPoint nullControlPoint = CGPointMake(-100, -100);// 为了逻辑严谨，这个点应该修改为 NaN 这样的形式
    CGPoint aControlPoint = nullControlPoint, bControlPoint = nullControlPoint, cControlPoint = nullControlPoint, dControlPoint = nullControlPoint, eControlPoint = nullControlPoint, fControlPoint = nullControlPoint, gControlPoint = nullControlPoint, hControlPoint = nullControlPoint;

    // 定义圆角常量(0.552 为一个近似值,具体值得的计算请自行查阅贝塞尔曲线相关知识)
    CGFloat controlPointOffsetRatio = 0.552;

    // 根据圆角来设置每个点的实际坐标和圆角控制点
    UIRectCorner cornerType = model.dr_cornerType;
    if ((cornerType & UIRectCornerTopLeft) && topLeftRadius > 1) {
        CGFloat offset = controlPointOffsetRatio * topLeftRadius;
        aPoint = CGPointMake(aPoint.x, aPoint.y + topLeftRadius);
        bPoint = CGPointMake(bPoint.x + topLeftRadius, bPoint.y);
        aControlPoint = CGPointMake(aPoint.x          , aPoint.y - offset);
        bControlPoint = CGPointMake(bPoint.x - offset , bPoint.y         );
    }
    if ((cornerType & UIRectCornerTopRight) && topRightRadius > 1) {
        CGFloat offset = controlPointOffsetRatio * topRightRadius;
        cPoint = CGPointMake(cPoint.x - topRightRadius, cPoint.y);
        dPoint = CGPointMake(dPoint.x, dPoint.y + topRightRadius);
        cControlPoint = CGPointMake(cPoint.x + offset , cPoint.y         );
        dControlPoint = CGPointMake(dPoint.x          , dPoint.y - offset);
    }
    if (cornerType & UIRectCornerBottomRight && bottomRightRadius > 1) {
        CGFloat offset = controlPointOffsetRatio * bottomRightRadius;
        ePoint = CGPointMake(ePoint.x, ePoint.y - bottomRightRadius);
        fPoint = CGPointMake(fPoint.x - bottomRightRadius, fPoint.y);
        eControlPoint = CGPointMake(ePoint.x          , ePoint.y + offset);
        fControlPoint = CGPointMake(fPoint.x + offset , fPoint.y         );
    }
    if (cornerType & UIRectCornerBottomLeft && bottomLeftRadius > 1) {
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
    UIBezierPath *fillPath = [UIBezierPath bezierPathWithRect:viewBounds];
    [fillPath appendPath:cornerPath];
    // 设置 shapeLayer
    CAShapeLayer *cornerLayer = [self drLayout_cornerLayer];
    cornerLayer.path = fillPath.CGPath;
    cornerLayer.fillRule = kCAFillRuleEvenOdd;
    cornerLayer.fillColor = model.dr_coverBGColor.CGColor;
    CAShapeLayer *borderLayer = [self drLayout_borderLayer];
    if (borderLayer) {
        borderLayer.path = cornerPath.CGPath;
        borderLayer.fillColor = UIColor.clearColor.CGColor;
        borderLayer.lineWidth = lineWidth;
        borderLayer.strokeColor = model.dr_borderColor.CGColor;
    }
}

#pragma mark >>>>>>> 改写 end


- (void)removeDRLayoutCorner {
    [[self drLayout_cornerLayer] removeFromSuperlayer];
    [[self drLayout_borderLayer] removeFromSuperlayer];
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DRCornerLayoutCornerLayerName), nil, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DRCornerLayoytBorderLayerName), nil, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DRCornerLayoutModelName), nil, OBJC_ASSOCIATION_RETAIN);
}

@end
