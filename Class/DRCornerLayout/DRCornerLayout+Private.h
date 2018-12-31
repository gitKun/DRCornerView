//
//  DRCornerLayout+Private.h
//  Demo
//
//  Created by DR_Kun on 2018/12/28.
//  Copyright © 2018 DR_Kun. All rights reserved.
//

#import "DRCornerLayout.h"

@interface DRCornerLayout (Private)

@property (nonatomic, strong, readonly) UIColor *dr_coverBGColor;
@property (nonatomic, assign, readonly) UIRectCorner dr_cornerType;
@property (nonatomic, strong, readonly) UIColor *dr_borderColor;//描边的颜色
@property (nonatomic, assign, readonly) CGFloat dr_lineWidth;


/**
 自动圆角:针对xib文件中的变高控件的自适应圆角化(以宽和高的最小值进行圆角)
 */
@property (nonatomic, assign, readonly) BOOL dr_autoCorner;

@property (nonatomic, assign, readonly) CGFloat dr_allCornerRadius;
// 这里改为 可以分别控制 每个角的圆角半径 (一旦设置 allCornerRadius 下面四个值将不再控制各角的圆角半径,仅设置圆角位置)
@property (nonatomic, assign, readonly) CGFloat dr_topLeftRadius;
@property (nonatomic, assign, readonly) CGFloat dr_topRightRadius;
@property (nonatomic, assign, readonly) CGFloat dr_bottomRightRadius;
@property (nonatomic, assign, readonly) CGFloat dr_bottomLeftRadius;


- (void)cleanCache;


@end
