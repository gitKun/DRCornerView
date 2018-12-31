//
//  UIView+DRCorner.m
//  正确圆角设置方式
//
//  Created by apple on 16/3/2.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "UIView+DRCorner.h"
#import <objc/runtime.h>

static NSString *DRCornerLayerName = @"DRCornerShapeLayer";
const NSString *DRCornerModelName = @"DRCORNERMODELNAME";

@implementation DRCornerModel

- (instancetype)copyWithZone:(NSZone *)zone {
    DRCornerModel *model = [[[self class] alloc] init];//这里可以自行查阅为什么使用 [self class] ->`正确实现 copyWithZone`
    model.cornerType = self.cornerType;
    model.cornerRadius = self.cornerRadius;
    model.superBGColor = self.superBGColor;
    model.borderColor = self.borderColor;
    model.lineWidth = self.lineWidth;
    return model;
}

+ (DRCornerModel *)cornerModelWithRadius:(CGFloat)radius superBGColor:(UIColor *)sBGColor cornerType:(DRRoundCorner)type borderColor:(UIColor *)borderColor lineWidth:(int)lineWidth {
    DRCornerModel *model = [[DRCornerModel alloc] init];
    model.cornerType = type;
    model.cornerRadius = radius;
    model.superBGColor = sBGColor;
    model.borderColor = borderColor;
    model.lineWidth = lineWidth;
    return model;
}

/*
 * 链式调用
 */
- (DRCornerModel *(^)(CGFloat))chainedCornerRadius {
    return ^(CGFloat cornerRadius) {
        self.cornerRadius = cornerRadius;
        return self;
    };
}
- (DRCornerModel *(^)(UIColor *))chainedSuperBGColor {
    return ^(UIColor *color){
        self.superBGColor = color;
        return self;
    };
}
- (DRCornerModel *(^)(DRRoundCorner))chainedCornerType {
    return ^(DRRoundCorner type){
        self.cornerType = type;
        return self;
    };
}
- (DRCornerModel *(^)(UIColor *))chainedBorderColor {
    return ^(UIColor *color){
        self.borderColor = color;
        return self;
    };
}
- (DRCornerModel *(^)(int))chainedLineWidth {
    return ^(int width){
        self.lineWidth = width;
        return self;
    };
}

@end


@implementation UIView (DRCorner)

#pragma mark --- 改写 begain

- (CAShapeLayer *)dr_cornerLayer {
    CAShapeLayer *shapLayer = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(DRCornerLayerName));
    return shapLayer;
}

- (void)registDRCornenrLayer {
    if (![self dr_cornerLayer]) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DRCornerLayerName), shapeLayer, OBJC_ASSOCIATION_RETAIN);
        [self.layer insertSublayer:shapeLayer atIndex:1000];
    }
}

- (BOOL)hasDRCornered {
    return [self dr_cornerLayer] != nil;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalLayoutSublayersOfLayerMethod = class_getInstanceMethod(self, @selector(layoutSublayersOfLayer:));
        Method drLayoutSublayersOfLayer = class_getInstanceMethod(self, @selector(dr_layoutSublayersOfLayer:));
        method_exchangeImplementations(originalLayoutSublayersOfLayerMethod, drLayoutSublayersOfLayer);
    });
}

- (void)dr_layoutSublayersOfLayer:(CALayer *)layer {
    [self dr_layoutSublayersOfLayer:layer];
    if ([self hasDRCornered] ) {
        //NSLog(@"self is : %@ subLayer class is : %@",[self class],[layer class]);
        //printf("dr_layoutSublayersOfLayer:\n");
        [self resetCornerLayer];
    }
}


- (void)resetCornerLayer {
    DRCornerModel *model = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(DRCornerModelName));
    if (model.cornerRadius < 1) {
        return;
    }
    if (!model.superBGColor) {
        if (self.superview && self.superview.backgroundColor != [UIColor clearColor]) {
            model.superBGColor = self.superview.backgroundColor;
        }else {
            return;
        }
    }
    if (CGRectEqualToRect(self.bounds, CGRectZero)) {
        return;
    }
    CGRect cornerBounds = self.bounds;
    CGFloat width = CGRectGetWidth(cornerBounds);
    CGFloat height = CGRectGetHeight(cornerBounds);
    UIBezierPath * path= [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, width, height)];
    CAShapeLayer *shapeLayer = [self dr_cornerLayer];
    UIRectCorner sysCorner = (UIRectCorner)model.cornerType;
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:cornerBounds byRoundingCorners:sysCorner cornerRadii:CGSizeMake(model.cornerRadius, model.cornerRadius)];
    [path  appendPath:cornerPath];
        //[path setUsesEvenOddFillRule:YES];
    shapeLayer.path = path.CGPath;
    /*
     字面意思是“奇偶”。按该规则，要判断一个点是否在图形内，从该点作任意方向的一条射线，然后检测射线与图形路径的交点的数量。如果结果是奇数则认为点在内部，是偶数则认为点在外部
     */
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    shapeLayer.fillColor = model.superBGColor.CGColor;
    if (model.borderColor) {
        //CGPathApply
        CGFloat cornerPathLength = drLengthOfCGPath(model.cornerType,model.cornerRadius,cornerBounds.size);
        CGFloat totolPathLength = 2*(CGRectGetHeight(cornerBounds)+CGRectGetWidth(cornerBounds))+cornerPathLength;
        shapeLayer.strokeStart = (totolPathLength-cornerPathLength)/totolPathLength;
        shapeLayer.strokeEnd = 1.0;
        shapeLayer.strokeColor = model.borderColor.CGColor;
        if (model.lineWidth > 0) {
            shapeLayer.lineWidth = model.lineWidth;
        }
    }
}


- (void)dr_cornerWithCornerModel:(DRCornerModel *)model {
    if (!model) {
        return;
    }
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DRCornerModelName), model, OBJC_ASSOCIATION_RETAIN);
    [self registDRCornenrLayer];
    [self setNeedsDisplay];
}

- (void)dr_conveniencesCornerWithBGColor:(UIColor *)bgColor {
    DRCornerModel *model = [DRCornerModel cornerModelWithRadius:(self.bounds.size.width * 0.5) superBGColor:(UIColor *)bgColor cornerType:DRRoundCornerAll borderColor:nil lineWidth:0];
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DRCornerModelName), model, OBJC_ASSOCIATION_RETAIN);
    [self registDRCornenrLayer];
    [self setNeedsDisplay];
}


#pragma mark --- 改写 end

/**
 关于 CGPath 的 length 的计算请参看 http://www.mlsite.net/blog/?p=1312 与 http://stackoverflow.com/questions/6515158/get-info-about-a-cgpath-uibezierpath 在这里简单的计算就能满足要求因此不做过多讨论
 */
float drLengthOfCGPath (DRRoundCorner roundingCorner,CGFloat radius,CGSize size) {
    CGFloat totolLength = 0.0;
    switch (roundingCorner) {
        case DRRoundCornerTop:
        case DRRoundCornerBottom:
            totolLength = 2*(size.width + size.height) - 4*radius + (M_PI * radius);
            break;
        case DRRoundCornerAll:
            totolLength = 2*(size.width + size.height) - 8*radius + (M_PI * radius)*2;
        default:
            break;
    }
    return totolLength;
}


-(void)removeDRCorner {
    [[self dr_cornerLayer] removeFromSuperlayer];
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(DRCornerLayerName), nil, OBJC_ASSOCIATION_RETAIN);
}


@end
