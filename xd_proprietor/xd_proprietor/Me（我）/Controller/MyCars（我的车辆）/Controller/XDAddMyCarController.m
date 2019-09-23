//
//  XDAddMyCarController.m
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDAddMyCarController.h"
#import "XDAddMyCarsFootView.h"
#import "XDAddMyCarCell.h"

@interface XDAddMyCarController ()

@end

@implementation XDAddMyCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加车辆";
    self.tableView.backgroundColor = litterBackColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDAddMyCarCell *cell = [XDAddMyCarCell cellWithTableView:tableView];
    
    if (indexPath.row == 0) {
        cell.titleLabels.text = @"车辆品牌";
        cell.inputText.placeholder = @"请输入车辆品牌";
        cell.inputText.text = self.carBrand;
        cell.lineView.hidden = NO;
    }else {
        cell.titleLabels.text = @"车  牌  号";
        cell.inputText.placeholder = @"请输入车牌号";
        cell.inputText.text = self.carNumber;
        cell.lineView.hidden = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
}

/**
 *  设置table的foot
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    XDAddMyCarsFootView *foot = [XDAddMyCarsFootView footerViewWithTableView:tableView];
    foot.commitBlock = ^{
        NSLog(@"tijiao");
    };
    return foot;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 120;
}



@end
