//
//  DRCornerBorderStyle.m
//  DRCornerAndBorderDemo
//
//  Created by DR_Kun on 2018/12/31.
//  Copyright © 2018 DR_Kun. All rights reserved.
//

#import "DRCornerBorderStyle.h"
#import "DRCornerBorderStyle+Private.h"


@interface DRCornerBorderStyleModle : NSObject

//@property (nonatomic, assign) CGFloat allCornerRadius;
//@property (nonatomic, assign) UIRectCorner cornerType;
//@property (nonatomic, assign) BOOL autoCorner;

// 圆角与圆角描边
@property (nonatomic, strong) UIColor *coverBGColor;
@property (nonatomic, strong) UIColor *cornerBorderColor;//描边的颜色
@property (nonatomic, assign) CGFloat cornerLineWidth;
@property (nonatomic, assign) CGFloat topleftRadius;
@property (nonatomic, assign) CGFloat topRightRadius;
@property (nonatomic, assign) CGFloat bottomRightRadius;
@property (nonatomic, assign) CGFloat bottomLeftRadius;
@property (nonatomic, assign) UIRectCorner cornerType;

// 边框x
@property (nonatomic, assign) BOOL hasTopBorder;
@property (nonatomic, assign) BOOL hasRightBorder;
@property (nonatomic, assign) BOOL hasBottomBorder;
@property (nonatomic, assign) BOOL hasLeftBorder;
@property (nonatomic, assign) UIEdgeInsets topBorderEdg;
@property (nonatomic, assign) UIEdgeInsets rightBorderEdg;
@property (nonatomic, assign) UIEdgeInsets bottomBorderEdg;
@property (nonatomic, assign) UIEdgeInsets leftBorderEdg;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderLineWidth;

@property (nonatomic, assign) BOOL autoCorner;

@end


@implementation DRCornerBorderStyleModle



@end


@interface DRCornerBorderStyle ()

@property (nonatomic, strong) NSMutableArray *styleNames;
@property (nonatomic, strong) DRCornerBorderStyleModle *model;

@end


@implementation DRCornerBorderStyle

#define DR_CACHE_STYLE_NAME(name) \
do {\
if (![self.styleNames containsObject:@""#name]) {\
[self.styleNames addObject:@""#name];\
}\
} while (0);\
return self;


#pragma mark === Public

// 圆角相关
- (DRCornerBorderStyle *)topLeftRadius {
    DR_CACHE_STYLE_NAME(TopLeftRadius)
}

- (DRCornerBorderStyle *)topRightRadius {
    DR_CACHE_STYLE_NAME(TopRightRadius)
}

- (DRCornerBorderStyle *)bottomRightRadius {
    DR_CACHE_STYLE_NAME(BottomRightRadius)
}

- (DRCornerBorderStyle *)bottomLeftRadius {
    DR_CACHE_STYLE_NAME(BottomLeftRadius)
}

- (DRCornerBorderStyle *)cornerLineWidth {
    DR_CACHE_STYLE_NAME(CornerLineWidth)
}

- (DRCornerBorderStyle *)cornerBorderColor {
    DR_CACHE_STYLE_NAME(CornerBorderColor)
}

- (DRCornerBorderStyle *)coverBGColor {
    DR_CACHE_STYLE_NAME(CoverBGColor)
}

#define DR_APPLY_STYLE(key, value) \
do {\
if ([self.styleNames containsObject:@""#key]) {\
[self setModel##key:value];\
}\
} while (0);

- (DRCornerBorderStyle *(^)(CGFloat value))equalToWidth {
    return ^DRCornerBorderStyle*(CGFloat value){
        DR_APPLY_STYLE(TopLeftRadius, value)
        DR_APPLY_STYLE(TopRightRadius, value)
        DR_APPLY_STYLE(BottomRightRadius, value)
        DR_APPLY_STYLE(BottomLeftRadius, value)
        DR_APPLY_STYLE(CornerLineWidth, value)
        DR_APPLY_STYLE(BorderLineWidth, value)
        [self.styleNames removeAllObjects];
        return self;
    };
}

- (DRCornerBorderStyle *(^)(id value))equalTo {
    return ^DRCornerBorderStyle*(id value){
        DR_APPLY_STYLE(BorderColor, value)
        DR_APPLY_STYLE(CornerBorderColor, value)
        DR_APPLY_STYLE(CoverBGColor, value)
        [self.styleNames removeAllObjects];
        return self;
    };
}

- (DRCornerBorderStyle *(^)(UIEdgeInsets value))equalToEdgInsets {
    return ^DRCornerBorderStyle*(UIEdgeInsets value){
        DR_APPLY_STYLE(TopBorderEdg, value)
        DR_APPLY_STYLE(RightBorderEdg, value)
        DR_APPLY_STYLE(BottomBorderEdg, value)
        DR_APPLY_STYLE(LeftBorderEdg, value)
        [self.styleNames removeAllObjects];
        return self;
    };
}

#define DR_ADD_BORDER(Key) self.model.has##Key = YES;\
return self;
// 边框相关
- (DRCornerBorderStyle *)topBorder {
    DR_ADD_BORDER(TopBorder)
}

- (DRCornerBorderStyle *)rightBorder {
    DR_ADD_BORDER(RightBorder)
}

- (DRCornerBorderStyle *)bottomBorder {
    DR_ADD_BORDER(BottomBorder)
}

- (DRCornerBorderStyle *)leftBorder {
    DR_ADD_BORDER(LeftBorder)
}

- (DRCornerBorderStyle *)borderLineWidth {
    DR_CACHE_STYLE_NAME(BorderLineWidth)
}

- (DRCornerBorderStyle *)borderColor {
    DR_CACHE_STYLE_NAME(BorderColor)
}

- (DRCornerBorderStyle *)topBorderEdg {
    DR_CACHE_STYLE_NAME(TopBorderEdg)
}

- (DRCornerBorderStyle *)rightBorderEdg {
    DR_CACHE_STYLE_NAME(RightBorderEdg)
}

- (DRCornerBorderStyle *)bottomBorderEdg {
    DR_CACHE_STYLE_NAME(BottomBorderEdg)
}

- (DRCornerBorderStyle *)leftBorderEdg {
    DR_CACHE_STYLE_NAME(LeftBorderEdg)
}

- (DRCornerBorderStyle *)autoCorner {
    self.model.autoCorner = YES;
    return self;
}

- (void)cleanCache {
    self.model = nil;
}

#pragma mark === Private setter

- (void)setModelTopLeftRadius:(CGFloat)radius {
    self.model.topleftRadius = radius;
}

- (void)setModelTopRightRadius:(CGFloat)radius {
    self.model.topRightRadius = radius;
}

- (void)setModelBottomRightRadius:(CGFloat)radius {
    self.model.bottomRightRadius = radius;
}

- (void)setModelBottomLeftRadius:(CGFloat)radius {
    self.model.bottomLeftRadius = radius;
}

- (void)setModelCornerLineWidth:(CGFloat)lineWidth {
    self.model.cornerLineWidth = lineWidth;
}

- (void)setModelCornerBorderColor:(UIColor *)color {
    self.model.cornerBorderColor = color;
}

- (void)setModelCoverBGColor:(UIColor *)color {
    self.model.coverBGColor = color;
}

- (void)setModelBorderLineWidth:(CGFloat)lineWidth {
    self.model.borderLineWidth = lineWidth;
}

- (void)setModelBorderColor:(UIColor *)color {
    self.model.borderColor = color;
}

- (void)setModelTopBorderEdg:(UIEdgeInsets)edg {
    self.model.topBorderEdg = edg;
}

- (void)setModelRightBorderEdg:(UIEdgeInsets)edg {
    self.model.rightBorderEdg = edg;
}

- (void)setModelBottomBorderEdg:(UIEdgeInsets)edg {
    self.model.bottomBorderEdg = edg;
}

- (void)setModelLeftBorderEdg:(UIEdgeInsets)edg {
    self.model.leftBorderEdg = edg;
}

#pragma mark === Ext

- (CGFloat)dr_topLeftRadius {
    return self.model.topleftRadius;
}

- (CGFloat)dr_topRightRadius {
    return self.model.topRightRadius;
}

- (CGFloat)dr_bottomRightRadius {
    return self.model.bottomRightRadius;
}

- (CGFloat)dr_bottomLeftRadius {
    return self.model.bottomLeftRadius;
}

- (CGFloat)dr_cornerLineWidth {
    return self.model.cornerLineWidth;
}

- (UIRectCorner)dr_cornerType {
    return self.model.cornerType;
}

- (UIColor *)dr_coverBGColor {
    return self.model.coverBGColor;
}

- (UIColor *)dr_cornerBorderColor {
    return self.model.cornerBorderColor;
}

- (UIEdgeInsets)dr_topBorderEdg {
    return self.model.topBorderEdg;
}

- (UIEdgeInsets)dr_rightBorderEdg {
    return self.model.rightBorderEdg;
}

- (UIEdgeInsets)dr_bottomBorderEdg {
    return self.model.bottomBorderEdg;
}

- (UIEdgeInsets)dr_leftBorderEdg {
    return self.model.leftBorderEdg;
}

- (BOOL)dr_hasTopBorder {
    return self.model.hasTopBorder;
}

- (BOOL)dr_hasRightBorder {
    return self.model.hasRightBorder;
}

- (BOOL)dr_hasBottomBorder {
    return self.model.hasBottomBorder;
}

- (BOOL)dr_hasLeftBorder {
    return self.model.hasLeftBorder;
}

- (CGFloat)dr_borderLineWidth {
    return self.model.borderLineWidth;
}

- (UIColor *)dr_borderColor {
    return self.model.borderColor;
}

- (BOOL)dr_useAutoCorner {
    return self.model.autoCorner;
}

#pragma mark === Lazy load

- (NSMutableArray *)styleNames {
    if (!_styleNames) {
        self.styleNames = [[NSMutableArray alloc] init];
    }
    return _styleNames;
}

- (DRCornerBorderStyleModle *)model {
    if (!_model) {
        self.model = [[DRCornerBorderStyleModle alloc] init];
    }
    return _model;
}


@end
