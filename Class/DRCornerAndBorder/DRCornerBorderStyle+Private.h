//
//  DRCornerBorderStyle+Private.h
//  DRCornerAndBorderDemo
//
//  Created by DR_Kun on 2018/12/31.
//  Copyright © 2018 DR_Kun. All rights reserved.
//

#import "DRCornerBorderStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRCornerBorderStyle (Private)


- (CGFloat)dr_topLeftRadius;
- (CGFloat)dr_topRightRadius;
- (CGFloat)dr_bottomRightRadius;
- (CGFloat)dr_bottomLeftRadius;
- (CGFloat)dr_cornerLineWidth;
- (UIRectCorner)dr_cornerType;
- (UIColor *)dr_coverBGColor;
- (UIColor *)dr_cornerBorderColor;


- (UIEdgeInsets)dr_topBorderEdg;
- (UIEdgeInsets)dr_rightBorderEdg;
- (UIEdgeInsets)dr_bottomBorderEdg;
- (UIEdgeInsets)dr_leftBorderEdg;
- (BOOL)dr_hasTopBorder;
- (BOOL)dr_hasRightBorder;
- (BOOL)dr_hasBottomBorder;
- (BOOL)dr_hasLeftBorder;

- (CGFloat)dr_borderLineWidth;
- (UIColor *)dr_borderColor;

- (BOOL)dr_useAutoCorner;

- (void)cleanCache;

@end

NS_ASSUME_NONNULL_END
