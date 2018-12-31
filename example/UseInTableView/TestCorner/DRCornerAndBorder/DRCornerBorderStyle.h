//
//  DRCornerBorderStyle.h
//  DRCornerAndBorderDemo
//
//  Created by DR_Kun on 2018/12/31.
//  Copyright © 2018 DR_Kun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRCornerBorderStyle : NSObject


// 圆角相关
- (DRCornerBorderStyle *)topLeftRadius;
- (DRCornerBorderStyle *)topRightRadius;
- (DRCornerBorderStyle *)bottomRightRadius;
- (DRCornerBorderStyle *)bottomLeftRadius;
- (DRCornerBorderStyle *)cornerLineWidth;
- (DRCornerBorderStyle *)cornerBorderColor;
- (DRCornerBorderStyle *)coverBGColor;
//- (DRCornerBorderStyle *)allRadius;

// 设置值
- (DRCornerBorderStyle *(^)(CGFloat value))equalToWidth;
- (DRCornerBorderStyle *(^)(id value))equalTo;
- (DRCornerBorderStyle *(^)(UIEdgeInsets value))equalToEdgInsets;

// 边框相关
- (DRCornerBorderStyle *)topBorder;
- (DRCornerBorderStyle *)rightBorder;
- (DRCornerBorderStyle *)bottomBorder;
- (DRCornerBorderStyle *)leftBorder;
- (DRCornerBorderStyle *)borderLineWidth;
- (DRCornerBorderStyle *)borderColor;
- (DRCornerBorderStyle *)topBorderEdg;
- (DRCornerBorderStyle *)rightBorderEdg;
- (DRCornerBorderStyle *)bottomBorderEdg;
- (DRCornerBorderStyle *)leftBorderEdg;


#pragma mark === 最简单的设置

- (DRCornerBorderStyle *)autoCorner;


@end

NS_ASSUME_NONNULL_END
