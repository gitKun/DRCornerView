//
//  TestCell.h
//  TestCorner
//
//  Created by DR_Kun on 2018/11/9.
//  Copyright © 2018 DR_Kun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TestCell : UITableViewCell

+ (NSString *)reuseID;

- (void)updateUIWihtInfo:(NSString *)info cornerTop:(BOOL)top cornerBottom:(BOOL)bottom;

@end

