//
//  ViewController.m
//  TestCorner
//
//  Created by DR_Kun on 2018/11/9.
//  Copyright © 2018 DR_Kun. All rights reserved.
//

#import "ViewController.h"
//view
#import "TestCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self bindingAction];
}

#pragma mark === UI Setting

- (void)bindingAction {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TestCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[TestCell reuseID]];
}

#pragma mark === Constant
- (NSArray *)dataArray {
    return @[@"Top Corner",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
             @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"Bottom Corner"];
}

#pragma mark === Delegate

#pragma mark ==- UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TestCell *tCell = (TestCell *)cell;
    if (indexPath.section == 0) {
        BOOL cornerTop = NO;
        BOOL cornerBottom = NO;
        if (indexPath.row == 0) {
            cornerTop = YES;
        }else if (indexPath.row == self.dataArray.count - 1) {
            cornerBottom = YES;
        }
        [tCell updateUIWihtInfo:self.dataArray[indexPath.row] cornerTop:cornerTop cornerBottom:cornerBottom];
    }else {
        [tCell updateUIWihtInfo:@"All Corner" cornerTop:YES cornerBottom:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;


#pragma mark ==- UITabeViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.dataArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:[TestCell reuseID]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}




@end
