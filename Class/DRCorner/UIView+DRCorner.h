//
//  UIView+DRCorner.h
//  正确圆角设置方式
//
//  Created by apple on 16/3/2.
//  Copyright © 2016年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, DRRoundCorner) {
    DRRoundCornerTop = (UIRectCornerTopLeft | UIRectCornerTopRight),
    DRRoundCornerBottom = (UIRectCornerBottomLeft | UIRectCornerBottomRight),
    DRRoundCornerAll = UIRectCornerAllCorners
};

@interface DRCornerModel : NSObject<NSCopying>

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *superBGColor;
@property (nonatomic, assign) DRRoundCorner cornerType;
@property (nonatomic, strong) UIColor *borderColor;//描边的颜色
@property (nonatomic, assign) int lineWidth;


/**
 快速创建
 */
+ (DRCornerModel *)cornerModelWithRadius:(CGFloat)radius superBGColor:(UIColor *)sBGColor cornerType:(DRRoundCorner)type borderColor:(UIColor *)borderColor lineWidth:(int)lineWidth;
/*
 * 链式调用
 */
- (DRCornerModel *(^)(CGFloat))chainedCornerRadius;
- (DRCornerModel *(^)(UIColor *))chainedSuperBGColor;
- (DRCornerModel *(^)(DRRoundCorner))chainedCornerType;
- (DRCornerModel *(^)(UIColor *))chainedBorderColor;
- (DRCornerModel *(^)(int))chainedLineWidth;



@end


@interface UIView (DRCorner)

- (BOOL)hasDRCornered;

- (void)dr_cornerWithCornerModel:(DRCornerModel *)model;
/***  便捷的圆型,例如头像等(需要要保证width和height相等)  ****/
- (void)dr_conveniencesCornerWithBGColor:(UIColor *)bgColor;

- (void)removeDRCorner;

@end
