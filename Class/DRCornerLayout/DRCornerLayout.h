//
//  DRCornerLayout.h
//  Demo
//
//  Created by DR_Kun on 2018/12/28.
//  Copyright © 2018 DR_Kun. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class DRCornerLayout;

//typedef NS_OPTIONS(NSUInteger, DRLayoutRoundCorner) {
//    DRLayoutRoundCornerTop = (UIRectCornerTopLeft | UIRectCornerTopRight),
//    DRLayoutRoundCornerBottom = (UIRectCornerBottomLeft | UIRectCornerBottomRight),
//    DRLayoutRoundCornerAll = UIRectCornerAllCorners
//};

@interface DRCornerLayout : NSObject


- (DRCornerLayout *(^)(NSInteger radius))allCornerRadius;

- (DRCornerLayout *(^)(UIRectCorner type))cornerType;

- (DRCornerLayout *(^)(UIColor *bgColor))coverBGColor;

- (DRCornerLayout *(^)(UIColor *borderColor))borderColor;

- (DRCornerLayout *(^)(CGFloat lineWidth))lineWidth;

// 下面是仿照 masonry 的写法
// 类似于 .topLeftRadius.equalTo(20).topRightRadius.bottomRightRadius.bottomLeftRadius.equalTo(10)

- (DRCornerLayout *)topLeftRadius;
- (DRCornerLayout *)topRightRadius;
- (DRCornerLayout *)bottomRightRadius;
- (DRCornerLayout *)bottomLeftRadius;

- (DRCornerLayout *(^)(CGFloat radius))radiusEqualTo;

// 一旦设置为auto将不会采用其他样式
- (void)autoLayoutCorner;

@end

