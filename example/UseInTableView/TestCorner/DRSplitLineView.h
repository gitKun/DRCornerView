//
//  DRSplitLineView.h
//  银洲街新UI测试
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>


IB_DESIGNABLE
@interface DRSplitLineView : UIView

/** 线条的颜色 */
@property (nonatomic, strong) IBInspectable UIColor *lineColor;
/** 宽度 */
@property (nonatomic, assign) IBInspectable CGFloat splitWidth;

@end
