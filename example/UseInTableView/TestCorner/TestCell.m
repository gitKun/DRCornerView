//
//  TestCell.m
//  TestCorner
//
//  Created by DR_Kun on 2018/11/9.
//  Copyright © 2018 DR_Kun. All rights reserved.
//

#import "TestCell.h"
//tools
#import "UIView+DRCornerBorderStyle.h"
@interface TestCell ()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation TestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)reuseID {
    return @"TestCellID";
}

- (void)updateUIWihtInfo:(NSString *)info cornerTop:(BOOL)top cornerBottom:(BOOL)bottom {
    self.infoLabel.text = info;
    self.infoLabel.backgroundColor = [UIColor colorWithRed:arc4random()%256 * 1.0 / 255.0 green:arc4random()%246 * 1.0 / 255.0 blue:arc4random()%256 * 1.0 / 255.0 alpha:1];
    
    if (top && bottom) {
        [self.infoLabel dr_makeCornerBorder:^(DRCornerBorderStyle * _Nonnull style) {
            style.topLeftRadius.topRightRadius
            .bottomRightRadius.bottomLeftRadius
            .equalToWidth(5.0);
        }];
    }else if (top) {
        [self.infoLabel dr_makeCornerBorder:^(DRCornerBorderStyle * _Nonnull style) {
            style.topLeftRadius.topRightRadius.equalToWidth(5.0);
        }];
    }else if (bottom) {
        [self.infoLabel dr_makeCornerBorder:^(DRCornerBorderStyle * _Nonnull style) {
            style.bottomRightRadius.bottomLeftRadius.equalToWidth(5.0);
        }];
    }else {
        [self.infoLabel dr_removeAllStyle];
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
