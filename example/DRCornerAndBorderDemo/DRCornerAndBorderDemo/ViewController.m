//
//  ViewController.m
//  DRCornerAndBorderDemo
//
//  Created by DR_Kun on 2018/12/31.
//  Copyright © 2018 DR_Kun. All rights reserved.
//

#import "ViewController.h"
#import "UIView+DRCornerBorderStyle.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *cornerBGView;
@property (weak, nonatomic) IBOutlet UIButton *cornerBtn;

@property (weak, nonatomic) IBOutlet UIView *infoContentView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redViewHeight;
@property (weak, nonatomic) IBOutlet UIView *blueView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.infoContentView dr_makeCornerBorder:^(DRCornerBorderStyle * _Nonnull style) {
        style.topLeftRadius.equalToWidth(5)
        .topRightRadius.equalToWidth(10)
        .bottomRightRadius.equalToWidth(15)
        .bottomLeftRadius.equalToWidth(50)
        .cornerBorderColor.equalTo(UIColor.lightGrayColor)
        .cornerLineWidth.equalToWidth(4)
        .coverBGColor.equalTo(UIColor.whiteColor);
    }];
    self.redViewHeight.constant = 20;
#if 1
    if (arc4random() % 2) {
        if (arc4random() % 2) {
            NSLog(@"use border edg!");
            [self.redView dr_makeCornerBorder:^(DRCornerBorderStyle * _Nonnull style) {
                style.cornerLineWidth.equalToWidth(4)
                .rightBorder
                .borderColor.equalTo(UIColor.lightGrayColor)
                .borderLineWidth.equalToWidth(1)
                .rightBorderEdg.equalToEdgInsets(UIEdgeInsetsMake(3, 0, 5, 0));
            }];
        }else {
            // autoCorner
            NSLog(@"use auto corner!");
            [self.redView dr_autoCorner:^(DRCornerBorderStyle * _Nonnull style) {

            }];
        }

    }else {
        // 类似于 autoCorner, 不过可以做为 约束最大圆角半径来用
        [self.redView dr_makeCornerBorder:^(DRCornerBorderStyle * _Nonnull style) {
            style.cornerBorderColor.equalTo(UIColor.lightGrayColor)
            .topLeftRadius.topRightRadius
            .bottomLeftRadius.bottomRightRadius
            .equalToWidth(15)
            .cornerLineWidth.equalToWidth(3);
        }];
    }
#else
    [self.redView dr_makeCornerBorder:^(DRCornerBorderStyle * _Nonnull style) {
        style.cornerLineWidth.equalToWidth(4);
    }];
#endif

    [self.blueView dr_makeCornerBorder:^(DRCornerBorderStyle * _Nonnull style) {
        style.bottomBorder.rightBorder.borderColor.equalTo(UIColor.lightGrayColor)
        .borderLineWidth.equalToWidth(2);
    }];
}


- (IBAction)clicked:(id)sender {

    static NSInteger tapCount = 1;

    switch (tapCount) {
        case 1:
            [self allCornerWithoutBorder];
            break;
        case 2:
            [self allCornenWithLineWidth:5];
            break;
        case 3:
            [self allCornenWithLineWidth:3 radius:15];
            break;
        case 4:
            [self topLeftAndTopRight];
            break;
        case 5:
            [self topLeftAndBottomLeft];
            break;
        case 6:
            [self topLeftAndBottonRightNotEquel];
            break;
        case 7: {
            [self.cornerBGView dr_removeAllStyle];
            self.infoLabel.text = @"移除所有圆角";
            tapCount = 0;
        }

            break;
        default:
            tapCount = 0;
            break;
    }
    tapCount++;

    NSInteger height = arc4random() % 6 * 10 + 10;
    self.redViewHeight.constant = height;
}

- (void)allCornerWithoutBorder {
    [self allCornenWithLineWidth:0 radius:10];
}

- (void)allCornenWithLineWidth:(CGFloat)lineWidth {
    [self allCornenWithLineWidth:lineWidth radius:10];
}

- (void)allCornenWithLineWidth:(CGFloat)lineWidth radius:(CGFloat)radius {
    [self.cornerBGView dr_makeCornerBorder:^(DRCornerBorderStyle * _Nonnull style) {
        style.coverBGColor.equalTo(UIColor.whiteColor)
        .cornerLineWidth.equalToWidth(lineWidth)
        .cornerBorderColor.equalTo(UIColor.lightGrayColor)
        .topLeftRadius
        .topRightRadius
        .bottomRightRadius
        .bottomLeftRadius
        .equalToWidth(radius);
    }];
    NSString *info  = [self cornenrInforWihtType:UIRectCornerAllCorners radius:[NSString stringWithFormat:@"tl->bl(%@,%@,%@,%@)",@(radius),@(radius),@(radius),@(radius)] hasBorder:YES lineWidth:lineWidth];
    self.infoLabel.text = info;
}

- (void)topLeftAndTopRight {
    [self.cornerBGView dr_makeCornerBorder:^(DRCornerBorderStyle * _Nonnull style) {
        style.coverBGColor.equalTo(UIColor.whiteColor)
        .cornerLineWidth.equalToWidth(4)
        .topLeftRadius
        .topRightRadius
        .equalToWidth(10)
        .cornerBorderColor
        .equalTo(UIColor.lightGrayColor);
    }];
    NSString *info  = [self cornenrInforWihtType:UIRectCornerTopLeft | UIRectCornerTopRight radius:[NSString stringWithFormat:@"tl->bl(%@,%@,%@,%@)",@(10),@(10),@(10),@(10)] hasBorder:YES lineWidth:4];
    self.infoLabel.text = info;
}

- (void)topLeftAndBottomLeft {
    [self.cornerBGView dr_makeCornerBorder:^(DRCornerBorderStyle * _Nonnull style) {
        style.coverBGColor.equalTo(UIColor.whiteColor)
        .cornerLineWidth.equalToWidth(4)
        .cornerBorderColor.equalTo(UIColor.lightGrayColor)
        .topLeftRadius.bottomLeftRadius.equalToWidth(10);
    }];
    NSString *info  = [self cornenrInforWihtType:UIRectCornerTopLeft | UIRectCornerBottomLeft radius:[NSString stringWithFormat:@"tl->bl(%@,%@,%@,%@)",@(10),@(0),@(0),@(10)] hasBorder:YES lineWidth:4];
    self.infoLabel.text = info;
}

- (void)topLeftAndBottonRightNotEquel {
    [self.cornerBGView dr_makeCornerBorder:^(DRCornerBorderStyle * _Nonnull style) {
        style.coverBGColor.equalTo(UIColor.whiteColor)
        .cornerLineWidth.equalToWidth(8)
        .cornerBorderColor.equalTo(UIColor.lightGrayColor)
        .topLeftRadius.bottomRightRadius.equalToWidth(10);
    }];
    NSString *info  = [self cornenrInforWihtType:UIRectCornerTopLeft | UIRectCornerBottomRight radius:[NSString stringWithFormat:@"tl->bl(%@,%@,%@,%@)",@(10),@(0),@(30),@(0)] hasBorder:YES lineWidth:8];
    self.infoLabel.text = info;
}

- (NSString *)cornenrInforWihtType:(UIRectCorner)type radius:(NSString *)radius hasBorder:(BOOL)border lineWidth:(CGFloat)lineWidth {
    NSString *typeString = @"";
    if (type & UIRectCornerTopLeft) {
        typeString = [typeString stringByAppendingString:@"左上 "];
    }
    if (type & UIRectCornerTopRight) {
        typeString = [typeString stringByAppendingString:@"右上 "];
    }
    if (type & UIRectCornerBottomRight) {
        typeString = [typeString stringByAppendingString:@"右下 "];
    }
    if (type & UIRectCornerBottomLeft) {
        typeString = [typeString stringByAppendingString:@"左下 "];
    }
    if (!typeString.length) {
        typeString = @"无";
    }
    NSString *borderedString = border ? @"有" : @"无";
    NSString *info = [NSString stringWithFormat:@"圆角位置:%@,\n圆角半径:%@,\n有无边框:%@,\n边框宽度:%@",typeString,radius,borderedString,@(lineWidth)];

    return info;
}

// tools

- (UIRectCorner)cornerType {
    NSArray *array = @[
                       @(UIRectCornerTopLeft),
                       @(UIRectCornerTopRight),
                       @(UIRectCornerBottomRight),
                       @(UIRectCornerBottomLeft),
                       @(UIRectCornerTopLeft | UIRectCornerTopRight),
                       @(UIRectCornerTopLeft | UIRectCornerBottomRight),
                       @(UIRectCornerTopLeft | UIRectCornerBottomLeft),
                       @(UIRectCornerTopRight | UIRectCornerBottomRight),
                       @(UIRectCornerTopRight | UIRectCornerBottomLeft),
                       @(UIRectCornerBottomRight | UIRectCornerBottomLeft),
                       @(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight),
                       @(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft),
                       @(UIRectCornerTopLeft | UIRectCornerBottomRight | UIRectCornerBottomLeft),
                       @(UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft),
                       @(UIRectCornerAllCorners)];
    UIRectCorner type = (UIRectCorner)[array[arc4random()%array.count] integerValue];
    return type;
}

@end
