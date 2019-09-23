//
//  KYShopcartTableViewProxy.m
//  KYShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "KYShopcartTableViewProxy.h"
#import "KYShopcartBrandModel.h"
#import "KYShopcartCell.h"
#import "KYShopcartHeaderView.h"
#import "KYShopcartResoucelistModel.h"

@implementation KYShopcartTableViewProxy

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    KYShopcartBrandModel *brandModel = self.dataArray[section];
    NSArray *productArray = brandModel.data;
    return productArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KYShopcartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KYShopcartCell"];
    KYShopcartBrandModel *brandModel = self.dataArray[indexPath.section];
    NSArray *productArray = brandModel.data;
    if (productArray.count > indexPath.row) {
        KYShopcartProductModel *productModel = productArray[indexPath.row];

        KYShopcartResoucelistModel *resouce = productModel.resourceList.firstObject;
        NSString *url = [NSString stringWithFormat:@"%@/%@",K_BASE_URL,resouce.url];
        /**
         *   商品名称
         *   商品价
         *   商品折后价
         *   商品数量
         *   商品名称
         *   商品名称
         */
        [cell configureShopcartCellWithProductURL:url productName:productModel.name productPrice:productModel.price productDisCountPrice:productModel.discountprice productCount:productModel.count productSize:productModel.size productSelected:productModel.isSelected];
        cell.isEdit = self.isEdit;
        
    }
    
    __weak __typeof(self) weakSelf = self;
    cell.shopcartCellBlock = ^(BOOL isSelected){
        if (weakSelf.shopcartProxyProductSelectBlock) {
            weakSelf.shopcartProxyProductSelectBlock(isSelected, indexPath);
        }
    };
    
    cell.shopcartCellEditBlock = ^(NSInteger count){
        if (weakSelf.shopcartProxyChangeCountBlock) {
            weakSelf.shopcartProxyChangeCountBlock(count, indexPath);
        }
    };
    
    return cell;
}

#pragma mark UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    KYShopcartBrandModel *brandModel = self.dataArray[section];
    if (brandModel.data.count == 0) {
        return nil;
    }
    KYShopcartHeaderView *shopcartHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"KYShopcartHeaderView"];
    if (self.dataArray.count > section) {
        KYShopcartBrandModel *brandModel = self.dataArray[section];
        KYShopcartProductModel *productModel = brandModel.data.firstObject;
        [shopcartHeaderView configureShopcartHeaderViewWithBrandName:productModel.homename brandSelect:brandModel.isSelected];
    }
    
    __weak __typeof(self) weakSelf = self;
    shopcartHeaderView.shopcartHeaderViewBlock = ^(BOOL isSelected){
        if (weakSelf.shopcartProxyBrandSelectBlock) {
            weakSelf.shopcartProxyBrandSelectBlock(isSelected, section);
        }
    };
    return shopcartHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    KYShopcartBrandModel *brandModel = self.dataArray[section];
    if (brandModel.data.count == 0) {
        return 0.001;
    }
    return 40;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (self.shopcartProxyDeleteBlock) {
            self.shopcartProxyDeleteBlock(indexPath);
        }
    }];
    
//    UITableViewRowAction *starAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        if (self.shopcartProxyStarBlock) {
//            self.shopcartProxyStarBlock(indexPath);
//        }
//    }];
    
    return @[deleteAction];
}

@end
