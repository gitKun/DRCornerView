//
//  UIView+DRCornerBorderStyle.h
//  DRCornerAndBorderDemo
//
//  Created by DR_Kun on 2018/12/31.
//  Copyright © 2018 DR_Kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRCornerBorderStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (DRCornerBorderStyle)

- (void)dr_makeCornerBorder:(void(^)(DRCornerBorderStyle *style))style;

- (void)dr_removeAllStyle;


/**
 @brief 针对动态高或者宽的圆角设置,为全部圆角半径为 MIN(width,height) * 0.5
 */
- (void)dr_autoCorner:(void(^)(DRCornerBorderStyle *style))style;

@end

NS_ASSUME_NONNULL_END
