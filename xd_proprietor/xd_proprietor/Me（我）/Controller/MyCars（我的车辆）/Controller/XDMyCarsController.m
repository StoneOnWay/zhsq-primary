//
//  XDMyCarsController.m
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDMyCarsController.h"
#import "XDMyCarsCell.h"
#import "XDAddMyCarController.h"

@interface XDMyCarsController ()

@end

@implementation XDMyCarsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的车辆";
    self.tableView.backgroundColor = litterBackColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"btn_jia" frame:CGRectMake(0, 0, 30, 30) target:self action:@selector(addMyCars)];
}

- (void)addMyCars{
    
    XDAddMyCarController *addCar = [[XDAddMyCarController alloc]init];
    [self.navigationController pushViewController:addCar animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    XDMyCarsCell *cell = [XDMyCarsCell cellWithTableView:tableView];
    cell.selectionStyle = 0;
    cell.linView.hidden = NO;
    if (indexPath.row == 5) {
        cell.linView.hidden = YES;
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
}
#pragma mark - Table view 侧滑修改和删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  YES;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewRowAction *layTopRowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"删除");
        
        [tableView setEditing:YES animated:YES];
        
    }];
    layTopRowAction1.backgroundColor = [UIColor redColor];
    
    
    
    UITableViewRowAction *layTopRowAction2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {

        XDAddMyCarController *addCar = [[XDAddMyCarController alloc]init];
        XDMyCarsCell *cell = (XDMyCarsCell *)[tableView cellForRowAtIndexPath:indexPath];
        addCar.carBrand = cell.carName.text;
        addCar.carNumber = cell.carNumber.text;
        [self.navigationController pushViewController:addCar animated:YES];
        [tableView setEditing:YES animated:YES];
        
    }];
    
    layTopRowAction2.backgroundColor = RGB(127, 222, 204);
    
    NSArray *arr = @[layTopRowAction1,layTopRowAction2];
    
    return arr;
    
}



@end
