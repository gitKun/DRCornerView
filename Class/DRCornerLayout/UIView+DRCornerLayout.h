//
//  UIView+DRCornerLayout.h
//  Demo
//
//  Created by DR_Kun on 2018/12/28.
//  Copyright © 2018 DR_Kun. All rights reserved.
//

#import "DRCornerLayout.h"


@interface UIView (DRCornerLayout)

/**
 添加圆角，如果已经对元素圆角处理此方法会先清空原有的style然后重新设置

 @param layout 圆角设置
 */
- (void)dr_makeCorner:(void(^)(DRCornerLayout *layout))layout;

/**
 更新圆角设置，不会清除已有设置

 @param layout 圆角设置
 */
- (void)dr_updateCorner:(void(^)(DRCornerLayout *layout))layout;

/**
 自动设置圆角:针对 1.xib文件中自适应宽高,或动态宽高的控件(无法得到圆角半径的) 2.简单书写不需要圆角半径
 注意:这个方法中 你必须自己设置圆角的位置类型否则内部会设置为 UIRectCornerAllCorners

 @param layout 圆角设置
 */
- (void)dr_autoLayoutCorner:(void(^)(DRCornerLayout *layout))layout;

- (BOOL)hasDRLayoutCornered;

- (void)removeDRLayoutCorner;

@end

