//
//  DRCornerLayout.m
//  Demo
//
//  Created by DR_Kun on 2018/12/28.
//  Copyright © 2018 DR_Kun. All rights reserved.
//

#import "DRCornerLayout.h"
#import "DRCornerLayout+Private.h"


@interface DRCornerLayoutModel : NSObject

@property (nonatomic, assign) CGFloat allCornerRadius;
@property (nonatomic, strong) UIColor *coverBGColor;
@property (nonatomic, assign) UIRectCorner cornerType;
@property (nonatomic, strong) UIColor *borderColor;//描边的颜色
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) BOOL autoCorner;

@property (nonatomic, assign) CGFloat topleftRadius;
@property (nonatomic, assign) CGFloat topRightRadius;
@property (nonatomic, assign) CGFloat bottomRightRadius;
@property (nonatomic, assign) CGFloat bottomLeftRadius;

@end


@implementation DRCornerLayoutModel


@end


@interface DRCornerLayout () 

@property (nonatomic, strong) NSMutableArray *radiusNames;
@property (nonatomic, strong) DRCornerLayoutModel *model;

@end


@implementation DRCornerLayout


//- (BOOL)isEqual:(id)object {
//    if (![object isKindOfClass:[DRCornerLayout class]]) {
//        return NO;
//    }
//    DRCornerLayout *obj = (DRCornerLayout *)object;
//    if (obj.cornerRadius != self.cornerRadius) {
//        return NO;
//    }
//    return [super isEqual:object];
//}

- (DRCornerLayout *(^)(NSInteger radius))allCornerRadius {
    return ^DRCornerLayout* (NSInteger radius) {
        self.model.allCornerRadius = radius;
        return self;
    };
}

- (DRCornerLayout *(^)(UIRectCorner type))cornerType {
    return ^DRCornerLayout* (UIRectCorner type) {
        self.model.cornerType = type;
        return self;
    };
}

- (DRCornerLayout *(^)(UIColor *bgColor))coverBGColor {
    return ^DRCornerLayout* (UIColor *bgColor) {
        self.model.coverBGColor = bgColor;
        return self;
    };
}

- (DRCornerLayout *(^)(UIColor *borderColor))borderColor {
    return ^DRCornerLayout* (UIColor *borderColor) {
        self.model.borderColor = borderColor;
        return self;
    };
}

- (DRCornerLayout *(^)(CGFloat lineWidth))lineWidth {
    return ^DRCornerLayout* (CGFloat lineWidth) {
        self.model.lineWidth = lineWidth;
        return self;
    };
}

- (void)autoLayoutCorner {
    UIRectCorner type = self.model.cornerType;
    if (!(type & UIRectCornerTopLeft) && !(type & UIRectCornerTopRight) && !(type & UIRectCornerBottomRight) && !(type & UIRectCornerBottomLeft)) {
        self.model.cornerType = UIRectCornerAllCorners;
    }
    self.model.autoCorner = YES;
}

#pragma mark === Ext

- (CGFloat)dr_allCornerRadius {
    return self.model.allCornerRadius;
}

- (CGFloat)dr_lineWidth {
    return self.model.lineWidth;
}

- (UIColor *)dr_coverBGColor {
    return self.model.coverBGColor;
}

- (UIRectCorner)dr_cornerType {
    return self.model.cornerType;
}
- (UIColor *)dr_borderColor {
    return self.model.borderColor;
}

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

- (BOOL)dr_autoCorner {
    return self.model.autoCorner;
}

#pragma mark === 来一发链式调用 begain

#define DR_CACHE_RADIUS_NAME(name) \
do {\
if (![self.radiusNames containsObject:@""#name]) {\
[self.radiusNames addObject:@""#name];\
}\
} while (0);\
return self;


- (DRCornerLayout *)topLeftRadius {
    self.model.cornerType |= UIRectCornerTopLeft;
//    do {
//        if (![self.radiusNames containsObject:@"TopLeftRadius"]) {
//            [self.radiusNames addObject:@"TopLeftRadius"];
//        }
//    } while (0);
//    return self;
    DR_CACHE_RADIUS_NAME(TopLeftRadius)
}
- (DRCornerLayout *)topRightRadius {
    self.model.cornerType |= UIRectCornerTopRight;
    DR_CACHE_RADIUS_NAME(TopRightRadius)
}
- (DRCornerLayout *)bottomRightRadius {
    self.model.cornerType |= UIRectCornerBottomRight;
    DR_CACHE_RADIUS_NAME(BottomRightRadius)
}
- (DRCornerLayout *)bottomLeftRadius {
    self.model.cornerType |= UIRectCornerBottomLeft;
    DR_CACHE_RADIUS_NAME(BottomLeftRadius)
}


#define DR_APPLY_RADIUS(key, radius) \
do {\
if ([self.radiusNames containsObject:@""#key]) {\
[self setModel##key:radius];\
}\
} while (0);

- (DRCornerLayout *(^)(CGFloat radius))radiusEqualTo {
    return ^DRCornerLayout* (CGFloat radius) {
//        do {
//            if ([self.radiusNames containsObject:@"TopLeftRadius"]) {
//                [self setModelTopLeftRadius:radius];
//            }
//        } while (0);
        DR_APPLY_RADIUS(TopLeftRadius, radius)
        DR_APPLY_RADIUS(TopRightRadius, radius)
        DR_APPLY_RADIUS(BottomRightRadius, radius)
        DR_APPLY_RADIUS(BottomLeftRadius, radius)
        [self.radiusNames removeAllObjects];
        return self;
    };
}


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



// 懒加载可以在 init 里面创建成员，防止不使用点语法调用造成的崩溃等问题
- (NSMutableArray *)radiusNames {
    if (!_radiusNames) {
        self.radiusNames = [NSMutableArray new];
    }
    return _radiusNames;
}

- (DRCornerLayoutModel *)model {
    if (!_model) {
        self.model = [[DRCornerLayoutModel alloc] init];
    }
    return _model;
}

- (void)cleanCache {
    self.model = nil;
}

#pragma mark === 来一发链式调用 begain



@end
